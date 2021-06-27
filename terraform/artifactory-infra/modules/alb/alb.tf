#####
# Load Balancer
#####

resource "aws_lb" "ec2_artifactory_alb" {
  name                       = "${var.project_prefix}-alb-artifactory-v1"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.alb_security_gp
  subnets                    = var.alb_subnet_list
  enable_deletion_protection = true

  access_logs {
    bucket  = data.aws_s3_bucket.infra_logs.id
    prefix  = "${var.project_prefix}-alb-artifactory-v1"
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.project_prefix}-alb-artifactory-v1"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}
