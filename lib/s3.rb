# frozen_string_literal: true

require 'aws-sdk-s3'

# S3 との接続を行う
class S3
  BUCKET_NAME = 'yurusuta-sample1'

  def self.upload(file_name, file_blob)
    client.put_object(
      bucket: BUCKET_NAME,
      key: file_name,
      body: file_blob,
      metadata: {}
    )
  rescue Aws::Errors::ServiceError => e
    puts "Couldn't upload file #{file_name} to #{BUCKET_NAME}. Here's why: #{e.message}"
    false
  end

  def self.download(file_name)
    obj = client.get_object(bucket: BUCKET_NAME, key: file_name)
    obj.body.read
  rescue Aws::Errors::ServiceError => e
    puts "Couldn't download file #{file_name} to #{BUCKET_NAME}. Here's why: #{e.message}"
    false
  end

  def self.client
    @client ||= Aws::S3::Client.new(
      region: 'ap-northeast-1',
      credentials: Aws::SSOCredentials.new(**fetch_aws_env)
    )
  end

  def self.fetch_aws_env
    {
      sso_account_id: ENV['SANDBOX_KYOTO_ACCOUNT_ID'],
      sso_role_name: ENV['SANDBOX_KYOTO_ROLE'],
      sso_region: 'ap-northeast-1',
      sso_start_url: ENV['MF_SSO_START_URL']
    }
  end
end
