## Building Callout Service for GCP Load Balancer


Service Extensions enables the users of Google Cloud products, such as Cloud Load Balancing and Media CDN, to insert programmability directly into the data path. This helps you customize the behavior of these proxies to meet your business needs. This page provides a high-level overview about Service Extensions.

Original GCP implemetation: https://github.com/GoogleCloudPlatform/service-extensions.git   

Callout Servie Externations docs: https://cloud.google.com/service-extensions/docs/overview   


---


## Instructions

```
python3 -m venv .venv

source .venv/bin/activate

pip install -r requirements.txt 

npm install @bufbuild/buf -g
```

Using buf to generate proto to python files and use them as a package:

```
buf -v generate https://github.com/envoyproxy/envoy.git#subdir=api   --path envoy/service/ext_proc/v3/external_processor.proto   --include-imports`

# Install the package via setup.py
pip install protodef/ 

```

Download the SSL Certificate:

```
git clone https://github.com/GoogleCloudPlatform/service-extensions.git extensions 
cp -R extensions/callouts/python/extproc/ssl_creds ./extproc/ 
sudo rm -R extensions
```

Running the service locally:

```
python3 -m callout.callout_server
```

Ports & Endpoints:

   -  health checks: http://localhost:81/   
   -  gRPC endpoint: http://localhost:80/  
   -  gRPC endpoint (TLS): http://localhost:443/

---

Local Testing with envoy server

`docker compose up`

Run the local service via VSCode debugger - to check local server (depends on the logic you should see headers/body outputs):

`curl -I -v http://localhost:8888`