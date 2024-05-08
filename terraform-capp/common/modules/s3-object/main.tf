resource "aws_s3_bucket_object" "s3object" {
  bucket = var.bucket_name   
  key    = var.bucket_key
  source = var.object_source
}