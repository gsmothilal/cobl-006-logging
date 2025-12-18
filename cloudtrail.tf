resource "aws_cloudtrail" "this" {
  name                          = "cobl-006-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
}