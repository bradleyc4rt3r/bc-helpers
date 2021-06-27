#####
# IAM for AWS Config 
#####

resource "aws_iam_role" "awsconfig_role" {
  name = "${var.project_prefix}-rol-awsconfig"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
  tags = {
    Name        = "${var.project_prefix}-rol-awsconfig"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy_attachment" "awsconfig_role_policy_attachment" {
  role       = aws_iam_role.awsconfig_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
