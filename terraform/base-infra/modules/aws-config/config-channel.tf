#####
# AWS Config Delivery Channel
#####

resource "aws_config_delivery_channel" "configs_channel" {
  name           = "${var.project_prefix}-aws-configs"
  s3_bucket_name = var.logging_s3
  s3_key_prefix  = "${var.project_prefix}-aws-configs"
  depends_on     = [aws_config_configuration_recorder.configs_recorder]
}
