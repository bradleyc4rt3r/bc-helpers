#####
# Cloudtrail
#####

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.project_prefix}-cloudtrail"
  s3_bucket_name                = var.logging_s3
  s3_key_prefix                 = "${var.project_prefix}-cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_log_rol.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_log_cwg.arn}:*"

  insight_selector {
    insight_type = "ApiCallRateInsight"
  }

  tags = {
    Name        = "${var.project_prefix}-cloudtrail"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}
