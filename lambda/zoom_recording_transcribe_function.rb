require 'json'
require 'aws-sdk-transcribeservice'
require 'logger'

def lambda_handler(event:, context:)
    logger = Logger.new($stdout)
    
    logger.info("Hook Event")
    logger.info(event)
    
    record = event["Records"][0]
    s3 = record["s3"]
    region = record["awsRegion"]

    bucket = s3["bucket"]["name"]
    object_key = s3["object"]["key"]
    path = "https://#{bucket}.s3-#{region}.amazonaws.com/#{object_key}"
    job_name = "TranscriptionJobName_#{object_key.sub(/recording\//, "")}"
    output_key = object_key.sub(/recording/, "text").sub(/\.mp4/, "")

    logger.info("S3 info")
    logger.info(bucket)
    logger.info(object_key)
    logger.info(path)

    client = Aws::TranscribeService::Client.new(region: region)
    
    response = client.start_transcription_job({
        transcription_job_name: job_name,
        language_code: "ja-JP",
        media_format: "mp4",
        media: {
            media_file_uri: path
        },
        output_bucket_name: bucket,
        output_key: "#{output_key}.txt"
    })

    logger.info("TranscriptionJob start #{response.transcription_job.transcription_job_name}")
end