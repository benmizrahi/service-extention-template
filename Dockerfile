#buf builder
FROM bufbuild/buf as BUF
RUN apk add git
COPY ./buf.gen.yaml ./buf.gen.yaml
RUN buf -v generate https://github.com/envoyproxy/envoy.git#subdir=api --path envoy/service/ext_proc/v3/external_processor.proto --include-imports
RUN git clone https://github.com/GoogleCloudPlatform/service-extensions.git extensions



# admin 
FROM node:latest as NODE 
WORKDIR /front 
COPY front /front 
RUN npm install 
RUN npm run build

# # Build the callout service. 
FROM marketplace.gcr.io/google/debian12 as dynamic-service-callout

# # Install pip for package management.
RUN apt-get update && apt-get install -y python3-pip --no-install-recommends --no-install-suggests

# # Use pip to install requirements.
COPY ./requirements.txt .

RUN pip install -r requirements.txt --break-system-packages --root-user-action=ignore

WORKDIR /home/callouts/python

# # Copy over the protobuf files from the buf build.
COPY --from=BUF ./protodef .

COPY --from=NODE ./dist ./dist

# # Setup the service callout files.
COPY ./extproc ./extproc

COPY --from=BUF ./extensions/callouts/python/extproc/ssl_creds ./extproc/ssl_creds

# # Copy over example specific files.
COPY . ./

# # Set up communication ports.
EXPOSE 443
EXPOSE 80
EXPOSE 8080
EXPOSE 3000

# # Start the service.
ENTRYPOINT /usr/bin/python3 -um callout.dynamic_callout_server "$@"