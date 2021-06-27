#####
# ECR -Jenkins Master
#####

resource "aws_ecr_repository" "repository_master" {
  name                 = "${var.project_prefix}-jenkins-master"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }

    tags = {
    Name        = "${var.project_prefix}-jenkins-master"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "master_lifecycle_policy" {
  repository = aws_ecr_repository.repository_master.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
