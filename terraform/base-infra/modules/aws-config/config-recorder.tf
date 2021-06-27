#####
# AWS Config Configuration Recorder
#####

resource "aws_config_configuration_recorder" "configs_recorder" {
  name     = "${var.project_prefix}-aws-configs-recorder"
  role_arn = aws_iam_role.awsconfig_role.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}
