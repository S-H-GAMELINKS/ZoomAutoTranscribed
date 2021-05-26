resource "aws_s3_bucket" "zoom-recoding-bucket" {
  bucket = "zoom-recoding-bucket"
  acl    = "private"
}