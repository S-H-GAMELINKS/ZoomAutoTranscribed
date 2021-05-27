data "archive_file" "zoom_recording_save_function" {
  type        = "zip"
  source_file  = "${path.module}/lambda/zoom_recording_save/lambda_function.rb"
  output_path = "${path.module}/lambda/upload/zoom_recording_save_function.zip"
}

data "archive_file" "zoom_recording_transcribe_function" {
  type        = "zip"
  source_file  = "${path.module}/lambda/zoom_recording_transcribe/lambda_function.rb"
  output_path = "${path.module}/lambda/upload/zoom_recording_transcribe_function.zip"
}

data "archive_file" "zoom_recording_transcribed_text_alert_function" {
  type        = "zip"
  source_file  = "${path.module}/lambda/zoom_recording_transcribed_text_alert/lambda_function.rb"
  output_path = "${path.module}/lambda/upload/zoom_recording_transcribed_text_alert_function.zip"
}

resource "aws_lambda_function" "zoom_recording_save" {
  function_name = "zoom_recording_save"

  filename = "${path.module}/${data.archive_file.zoom_recording_save_function.output_path}"

  handler     = "lambda_function.lambda_handler"
  role        = aws_iam_role.zoom_recording_save_role.arn
  runtime     = "ruby2.7"
  timeout     = 900
  memory_size = 10240
}

resource "aws_lambda_function" "zoom_recording_transcribe" {
  function_name = "zoom_recording_transcribe"

  filename = "${path.module}/${data.archive_file.zoom_recording_transcribe_function.output_path}"

  handler     = "lambda_function.lambda_handler"
  role        = aws_iam_role.zoom_recording_transcribe_role.arn
  runtime     = "ruby2.7"
  timeout     = 60
  memory_size = 10240
}

resource "aws_lambda_function" "zoom_recording_transcribed_text_alert" {
  function_name = "zoom_recording_transcribed_text_alert"

  filename = "${path.module}/${data.archive_file.zoom_recording_transcribed_text_alert_function.output_path}"

  handler     = "lambda_function.lambda_handler"
  role        = aws_iam_role.zoom_recording_transcribed_text_alert_role.arn
  runtime     = "ruby2.7"
  timeout     = 60
  memory_size = 10240
}

resource "aws_iam_role" "zoom_recording_save_role" {
  name               = "zoom_recording_save_role"
  path               = "/service-role/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "zoom_recording_transcribe_role" {
  name               = "zoom_recording_transcribe_role"
  path               = "/service-role/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "zoom_recording_transcribed_text_alert_role" {
  name               = "zoom_recording_transcribed_text_alert_role"
  path               = "/service-role/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
