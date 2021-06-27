#####
# Autoscaling Policy
#####

# Scale Up
resource "aws_autoscaling_policy" "ec2_artifactory_autoscale_policy_up" {
  name                   = "${var.project_prefix}-ec2-artifactory-autoscale-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_artifactory_autoscale.name
}

resource "aws_cloudwatch_metric_alarm" "ec2_artifactory_autoscale_cpu_alarm_up" {
  alarm_name          = "${var.project_prefix}-ec-artifactory-autoscale-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_artifactory_autoscale.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.ec2_artifactory_autoscale_policy_up.arn]

  tags = {
    Name        = "${var.project_prefix}-ec2-artifactory-autoscale-policy-up"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}


# Scale Down
resource "aws_autoscaling_policy" "ec2_artifactory_autoscale_policy_down" {
  name                   = "${var.project_prefix}-ec2-artifactory-autoscale-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_artifactory_autoscale.name
}

resource "aws_cloudwatch_metric_alarm" "ec2_artifactory_autoscale_cpu_alarm_down" {
  alarm_name          = "${var.project_prefix}-ec2-artifactory-autoscale-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_artifactory_autoscale.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.ec2_artifactory_autoscale_policy_down.arn]

  tags = {
    Name        = "${var.project_prefix}-ec2-artifactory-autoscale-policy-down"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}
