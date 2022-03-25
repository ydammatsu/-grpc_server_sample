require 'grpc'
require_relative '../file_storage_server'

s = GRPC::RpcServer.new
s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
s.handle(Server)
s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
