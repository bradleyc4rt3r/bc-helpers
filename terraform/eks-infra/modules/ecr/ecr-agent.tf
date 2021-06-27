#####
# ECR -Jenkins Agent
#####

resource "aws_ecr_repository" "repository_agent" {
  name                 = "${var.project_prefix}-jenkins-agent"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }

    tags = {
    Name        = "${var.project_prefix}-jenkins-agent"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "agent_lifecycle_policy" {
  repository = aws_ecr_repository.repository_agent.name

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

