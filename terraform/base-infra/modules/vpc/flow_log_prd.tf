#####
# VPC Flow Logs
#####

# VPC Flow Logs - CloudWatch
resource "aws_flow_log" "vpc_flow_log_cloudwatch" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_rol.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_cwg.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_prefix}-vpc-flow-log-cloudwatch"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_cloudwatch_log_group" "vpc_flow_log_cwg" {
  name              = "${var.project_prefix}-cwg-vpc-flow-log"
  retention_in_days = substr(var.project_prefix, 5, 3) == "prd" ? "14" : "5"

  tags = {
    Name        = "${var.project_prefix}-cwg-vpc-flow-log"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role" "vpc_flow_log_rol" {
  name = "${var.project_prefix}-rol-vpc-flow-log"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_prefix}-rol-vpc-flow-log"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy" "vpc_flow_log_pol" {
  name = "${var.project_prefix}-pol-vpc-flow-log"
  role = aws_iam_role.vpc_flow_log_rol.id

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


# VPC Flow Logs - S3
resource "aws_flow_log" "vpc_flow_log_s3" {
  log_destination          = "${var.s3_logging_arn}/${var.project_prefix}-vpc-flow-log"
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.vpc.id
  max_aggregation_interval = 60

  tags = {
    Name        = "${var.project_prefix}-vpc-flow-log-s3"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}
