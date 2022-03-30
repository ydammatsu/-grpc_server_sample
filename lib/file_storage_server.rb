# frozen_string_literal: true

# このクラスを GRPC::RpcServer.new に渡す。
# このクラス内に定義するメソッドは proto に定義した rpc と対応するように書く
# 第一引数に gRPC からのリクエストが入ってくる
# 各メソッドの戻り値は gRPC のレスポンスを返す
class FileStorageServer < Sample::FileStorage::Service
  def upload(request, _unused_call)
    # リクエストから値を取得
    file_name = request.file_name
    file_blob = Base64.decode64(request.file_blob)

    # S3に画像をアップロード
    is_upload_success = S3.upload(file_name, file_blob)

    # レスポンスを生成
    response = Sample::UploadResponse.new

    # レスポンスに値を詰めていく
    if is_upload_success
      puts "#{file_name} のアップロードに成功しました"
      response.error = :NO_ERROR
      # enum は文字列を入れるとエラーになる。symbol を入れる
      # もしくはタグの数字を入れる (例1) Sample::ErrorType::NO_ERROR (例2) 0

      response.created_at = Time.now
      # "2022-03-31 22:22" や DateTime.now を渡すとエラーになる
      # timestamp は seconds と　nanos を持っているので内部で time.to_f とかを呼んでる?
    else
      puts "#{file_name} のアップロードに失敗しました"
      :UNKNOWN_ERROR
    end

    # インスタンス生成時に値を入れることもできる
    # response = Sample::UploadResponse.new(
    #   created_at: Time.now,
    #   error: :NO_ERROR  
    # )

    response
  end

  def download(request, _unused_call)
    # リクエストから値を取得
    file_name = request.file_name

    # S3からファイルをダウンロード
    file_blob = S3.download(file_name)

    # レスポンスを生成
    response = Sample::DownloadResponse.new

    # レスポンスに値を詰めていく
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
