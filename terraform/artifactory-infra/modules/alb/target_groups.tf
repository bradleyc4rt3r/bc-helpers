#####
# Load Balancer Target Group
#####

resource "aws_lb_target_group" "ec2_artifactory_tg" {
  name                 = "${var.project_prefix}-tg-artifactory-v1"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "300"
  health_check {
    port                = "traffic-port"
    path                = var.alb_health_check_path
    timeout             = "10"
    protocol            = "HTTP"
    interval            = "30"
    matcher             = var.alb_health_status_code
    healthy_threshold   = "5"
    unhealthy_threshold = "5"
  }

  tags = {
    Name        = "${var.project_prefix}-tg-artifactory-v1"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}
