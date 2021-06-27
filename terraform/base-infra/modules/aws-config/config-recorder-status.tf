#####
# AWS Config Configuration Recorder Status
#####

resource "aws_config_configuration_recorder_status" "configs_recorder_status" {
  name       = aws_config_configuration_recorder.configs_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.configs_channel]
}
