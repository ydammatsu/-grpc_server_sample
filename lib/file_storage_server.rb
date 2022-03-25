# frozen_string_literal: true

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

__END__

require_relative './lib/s3'

method = ARGV[0]
file_name_or_path = ARGV[1]

def upload(file_path)
  file      = File.open(file_path)
  file_name = File.basename(file.path)
  file_blob = file.read
  S3.upload(file_name, file_blob)

  puts "Upload 完了"
end

def download(file_name)
  obj = S3.download(file_name)
  File.open("#{Dir.home}/Desktop/test_#{file_name}", "w") do |f|
    f.write(obj.body.read)
  end

  puts "Download 完了"
end

send(method, file_name_or_path)