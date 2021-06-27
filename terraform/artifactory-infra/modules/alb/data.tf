# S3 Bucket - Logs
data "aws_s3_bucket" "infra_logs" {
  bucket = "${var.project_prefix}-s3-infra-logs"
}

# ACM
data "aws_acm_certificate" "certificate" {
  domain      = var.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}