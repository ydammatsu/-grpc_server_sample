require 'datetime'
require_relative 'pb/hoge_pb'
require_relative 's3'

class FileStorageServer < Sample::FileStorage::Service
  def upload(request, _unused_call)
    file_name = request.file_name
    file_blob = request.file_blob

    response = Sample::FileStorage::UploadResponse.new

    if S3.upload(file_name, file_blob)
      response.error = :NO_ERROR
      response.created_at = DateTime.now
    else
      response.error = :UNKNOWN_ERROR
    end

    response
  end

  def download(request)
    file_name = request.file_name

    response = Sample::FileStorage::DownloadResponse.new

    if file_blob = S3.download(file_name, file_blob)
      response.error = :NO_ERROR
      response.file_blob = file_blob
    else
      response.error = :UNKNOWN_ERROR
    end

    response
  end
end

s = GRPC::RpcServer.new
s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
s.handle(Server)
s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
