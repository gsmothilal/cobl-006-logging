provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "cobl-006-log-archive-123456"
}

# Enable versioning (required for log integrity)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access (required)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Lifecycle rules for log retention (COBL-006 Item 2)
resource "aws_s3_bucket_lifecycle_configuration" "log_retention" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id     = "cloudtrail-log-retention"
    status = "Enabled"

    filter {
      prefix = "AWSLogs/"
    }

    # Move logs to cheaper storage after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Archive logs after 180 days
    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    # Delete logs after ~7 years (example compliance period)
    expiration {
      days = 2555
    }
  }
}
# CloudTrail for API audit logging (COBL-006 Item 1)
resource "aws_cloudtrail" "cobl_trail" {
  name                          = "cobl-006-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::cobl-006-log-archive-123456/AWSLogs/852492840868/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::cobl-006-log-archive-123456"
      }
    ]
  })
}
# CloudWatch Log Group for execution / operational logs (COBL-006 Item 1)
resource "aws_cloudwatch_log_group" "cobl_logs" {
  name              = "/cobl-006/application-logs"
  retention_in_days = 90
}
