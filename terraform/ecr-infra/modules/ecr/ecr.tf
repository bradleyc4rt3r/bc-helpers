#####
# ECR 
#####

# Repository
resource "aws_ecr_repository" "repository" {
  name                 = "${var.ecr_name}"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }

    tags = {
    Name        = "${var.ecr_name}"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}
