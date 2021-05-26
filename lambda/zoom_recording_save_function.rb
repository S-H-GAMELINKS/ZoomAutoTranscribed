require 'json'
require 'logger'
require 'aws-sdk-s3'
require 'open-uri'
require 'net/http'

def lambda_handler(event:, context:)
    logger = Logger.new($stdout)
    
    logger.info(event)
    
    body = JSON.parse(event["body"])
    
    logger.info(body)
    
    logger.info("Get Zoom Recording file download path")
    
    region = 'us-east-2'
    bucket_name = "zoom-recoding-bucket"
    
    s3_client = Aws::S3::Client.new(region: region)
    
    recording_files = body["payload"]["object"]["recording_files"]
    meeting_id = body["payload"]["object"]["id"]
    
    token = body["download_token"]
    path = recording_files[0]["download_url"]
    
    download_path = "#{path}?access_token=#{token}"

    object_key = "#{meeting_id}.mp4"

    logger.info(download_path)
    logger.info(token)
    
    URI.open(download_path) do |file|
        s3_client.put_object({
            :bucket => bucket_name,
            :key    => "recording/#{object_key}",
            :content_type => "movie/mp4",
            :body   => file.read
        })
    end
end