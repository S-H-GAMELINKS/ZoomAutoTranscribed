require 'json'
require 'aws-sdk-s3'
require 'logger'

def lambda_handler(event:, context:)
    logger = Logger.new($stdout)
    
    logger.info("Hook Event")
    logger.info(event)
    
    record = event["Records"][0]
    s3 = record["s3"]
    region = record["awsRegion"]
    
    client = Aws::S3::Resource.new(region: region)

    bucket_name = s3["bucket"]["name"]
    object_key = s3["object"]["key"]
    path = "./#{object_key}"
    
    logger.info("S3 info")
    logger.info(bucket_name)
    logger.info(object_key)
    logger.info(path)
    
    obj = client.bucket(bucket_name).object(object_key)
    
    text = obj.get.body.read

    json = JSON.parse(text)
    
    logger.info("Transcribed result")
    logger.info(json["results"]["transcripts"][0]["transcript"])
end
