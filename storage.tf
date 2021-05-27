resource "aws_s3_bucket" "zoom-recoding-bucket" {
  bucket = "zoom-recoding-bucket"
  acl    = "private"
}

resource "aws_lambda_permission" "zoom_recording_save_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.zoom_recording_transcribe.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.zoom-recoding-bucket.arn
}

resource "aws_lambda_permission" "zoom_recording_transcribed_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.zoom_recording_transcribed_text_alert.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.zoom-recoding-bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.zoom-recoding-bucket.id

  lambda_function {
    lambda_function_arn     = aws_lambda_function.zoom_recording_transcribe.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "recording/"
  }

  lambda_function {
    lambda_function_arn     = aws_lambda_function.zoom_recording_transcribed_text_alert.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "text/"
  }

  depends_on = [
    aws_lambda_permission.zoom_recording_save_allow_bucket,
    aws_lambda_permission.zoom_recording_transcribed_allow_bucket,
  ]
}