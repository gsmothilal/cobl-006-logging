variable "aws_region" {
  type = string
}

variable "log_bucket_name" {
  type = string
}

variable "account_id" {
  type = string
}

variable "cloudwatch_retention_days" {
  type    = number
  default = 90
}