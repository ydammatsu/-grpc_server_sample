# frozen_string_literal: true

require 'date'
require './pb/sample_services_pb'
require './lib/s3'
require './lib/file_storage_server'

s = GRPC::RpcServer.new
s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
s.handle(FileStorageServer)
s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
