# frozen_string_literal: true

# このクラスを GRPC::RpcServer.new に渡す。
# このクラス内に定義するメソッドは proto に定義した rpc と対応するように書く
# 第一引数に gRPC からのリクエストが入ってくる
# 各メソッドの戻り値は gRPC のレスポンスを返す
class FileStorageServer < Sample::FileStorage::Service
  def upload(request, _unused_call)
    file_name = request.file_name
    file_blob = Base64.decode64(request.file_blob)

    response = Sample::UploadResponse.new

    response.error = if S3.upload(file_name, file_blob)
                       puts "#{file_name} のアップロードに成功しました"
                       :NO_ERROR
                     else
                        puts "#{file_name} のアップロードに失敗しました"
                       :UNKNOWN_ERROR
                     end
    # response.created_at = DateTime.now.to_s

    response
  end

  def download(request, _unused_call)
    file_name = request.file_name

    response = Sample::DownloadResponse.new

    file_blob = S3.download(file_name)
    if file_blob
      puts "#{file_name} のダウンロードに成功しました"
      response.error = :NO_ERROR
      response.file_blob = Base64.encode64(file_blob)
    else
      puts "#{file_name} のダウンロードに失敗しました"
      response.error = :UNKNOWN_ERROR
    end

    response
  end
end
