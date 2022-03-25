require 'aws-sdk-s3'

def bucket_exists?(s3_client, bucket_name)
  response = s3_client.list_buckets
  response.buckets.each do |bucket|
    return true if bucket.name == bucket_name
  end
  return false
rescue StandardError => e
  puts "Error listing buckets: #{e.message}"
  return false
end

s3_client = Aws::S3::Client.new(
  region: 'ap-northeast-1',
  credentials: Aws::SSOCredentials.new(
    sso_account_id: '348858295373',
    sso_role_name: 'AdministratorAccess',
    sso_region: 'ap-northeast-1',
    sso_start_url: 'https://d-95671c748d.awsapps.com/start'
  )
)
bucket_name = 'yurusuta-sample1'

puts bucket_exists?(s3_client, bucket_name) ? 'ありました' : 'ありません'
