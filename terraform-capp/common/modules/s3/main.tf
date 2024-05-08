resource "aws_s3_bucket" "s3_bucket" {
  bucket = try(var.bucket_name,null)
  force_destroy = tobool(lower(var.force_destroy))


  
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  count = try(var.versioning_enabled,false) == true ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}