provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// Create a new bucket for storing content such as images,text files
resource "aws_s3_bucket" "content_bucket" {
  bucket = "devops-stories-content-bucket"
  // Will delete the resource even if the bucket is not empty
  force_destroy = true
  tags = {
    Name        = "devops-stories-content-bucket"
    Environment = "Production"
  }
}

// Enabling versioning for content_bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.content_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "content_bucket_ownership_control" {
  bucket = aws_s3_bucket.content_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "content_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.content_bucket_ownership_control]

  bucket = aws_s3_bucket.content_bucket.id
  acl    = "private"
}

// create a new bucket named my-tf-log-bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-devops-stories-log-bucket"
  // Will delete the resource even if the bucket is not empty
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership_control" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_ownership_control]

  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

// Enabling logging for content_bucket to store logs in log_bucket
resource "aws_s3_bucket_logging" "content_bucket_logging" {
  bucket = aws_s3_bucket.content_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}