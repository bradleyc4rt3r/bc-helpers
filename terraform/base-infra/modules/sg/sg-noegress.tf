#####
# Security Groups
#####

##  Security Group for no egress
resource "aws_security_group" "no_egress" {
  name        = "${var.project_prefix}-sg-noegress"
  description = "No egress"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_prefix}-sg-noegress"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}
