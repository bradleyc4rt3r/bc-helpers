#####
# Cloudwatch for Cloudtrail
#####

resource "aws_cloudwatch_log_group" "cloudtrail_log_cwg" {
  name              = "${var.project_prefix}-cwg-cloudtrail"
  retention_in_days = substr(var.project_prefix, 5, 3) == "prd" ? "90" : "30"

  tags = {
    Name        = "${var.project_prefix}-cwg-cloudtrail"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role" "cloudtrail_log_rol" {
  name = "${var.project_prefix}-rol-cloudtrail"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_prefix}-rol-cloudtrail"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy" "cloudtrail_log_pol" {
  name = "${var.project_prefix}-pol-cloudtrail"
  role = aws_iam_role.cloudtrail_log_rol.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}
