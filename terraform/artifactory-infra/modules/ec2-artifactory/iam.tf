#####
# IAM
#####

resource "aws_iam_instance_profile" "artifactory_profile" {
  name = "${var.project_prefix}-instance-profile-artifactory"
  role = aws_iam_role.ec2_artifactory_role.name
}

resource "aws_iam_role" "ec2_artifactory_role" {
  name               = "${var.project_prefix}-rol-artifactory"
  path               = "/"
  description        = "Communicate with other services"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_prefix}-tg-artifactory-v1"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy" "ec2_artifactory_role_policy" {
  name   = "${var.project_prefix}-pol-ec2-artifactory"
  role   = aws_iam_role.ec2_artifactory_role.name
  policy = data.template_file.ec2_role_policy.rendered
}

data "template_file" "ec2_role_policy" {
  template = file(
    "${path.module}/templates/iam/iam-role-policy-ec2-artifactory.template",
  )

  vars = {
    artifactory-bucket-arn = "arn:aws:s3:::${var.artifactory_bucket}"
  }
}
