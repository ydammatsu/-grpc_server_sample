# frozen_string_literal: true

# このクラスを GRPC::RpcServer.new に渡す。
# このクラス内に定義するメソッドは proto に定義した rpc と対応するように書く
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

    file_blob = S3.download(file_name, file_blob)
    if file_blob
      response.error = :NO_ERROR
      response.file_blob = file_blob
    else
      response.error = :UNKNOWN_ERROR
    end

    response
  end
end
