#####
# Security Groups
#####

##  Security Group for alb
resource "aws_security_group" "ec2_infa_to_alb" {
  name        = "${var.project_prefix}-sg-alb"
  description = "ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "External access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "External access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_prefix}-sg-alb"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}
