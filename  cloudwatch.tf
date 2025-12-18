resource "aws_cloudwatch_log_group" "this" {
  name              = "/cobl-006/application-logs"
  retention_in_days = var.cloudwatch_retention_days
}