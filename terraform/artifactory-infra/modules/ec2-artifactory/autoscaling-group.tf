#####
# Autoscaling Group
#####

resource "aws_autoscaling_group" "ec2_artifactory_autoscale" {
  name = "${var.project_prefix}-asg-artifactory-v1"

  min_size                  = var.ec2_artifactory_min_count
  desired_capacity          = var.ec2_artifactory_desired_count
  max_size                  = var.ec2_artifactory_max_count
  default_cooldown          = 90
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [var.target_group_arn]
  launch_configuration      = aws_launch_configuration.ec2_artifactory_launch.name
  vpc_zone_identifier       = var.ec2_subnets

  metrics_granularity = "1Minute"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_prefix}-ec2-artifactory"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "CreatedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

}
