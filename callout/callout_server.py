import os
from typing import Union
from loguru import logger
from grpc import ServicerContext
from envoy.service.ext_proc.v3 import external_processor_pb2 as service_pb2
from extproc import server
from multiprocessing import Process
from protodef.envoy.service.ext_proc.v3.external_processor_pb2 import ImmediateResponse
from envoy.service.ext_proc.v3.external_processor_pb2 import BodyResponse
from extproc import tools

class CalloutServer(server.CalloutServer):
 
  def on_request_headers(self, headers: service_pb2.HttpHeaders, context: ServicerContext) -> service_pb2.HeadersResponse:
    global calloutConfig
    return calloutConfig.execute('request_headers', headers, context, tools=tools)
  
  def on_response_headers(self, headers: service_pb2.HttpHeaders, context: ServicerContext) -> service_pb2.HeadersResponse:
    return super().on_response_headers(body, context)
  
  def on_request_body(self, body, context)  -> Union[None, BodyResponse, ImmediateResponse]:
    return super().on_request_body(body, context)
  
  def on_response_body(self, body, context) -> Union[None, BodyResponse]:
    return super().on_response_body(body, context)
  
if __name__ == '__main__':
  
  logger.info("starting server!!")
  calloutServer = CalloutServer(health_check_port=81)
  calloutServer.run()
