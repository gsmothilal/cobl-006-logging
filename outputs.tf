output "log_bucket" {
  value = aws_s3_bucket.log_bucket.bucket
}

output "cloudtrail" {
  value = aws_cloudtrail.this.name
}