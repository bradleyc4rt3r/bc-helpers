#####
# IAM for Inspector
#####

data "aws_iam_policy_document" "inspector_event_role_policy" {
  statement {
    sid = "StartAssessment"
    actions = [
      "inspector:StartAssessmentRun",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "inspector_event_role" {
  name               = "${var.project_prefix}-rol-inspector-event"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_prefix}-rol-inspector-event"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy" "inspector_event" {
  name   = "${var.project_prefix}-pol-inspector-event"
  role   = aws_iam_role.inspector_event_role.id
  policy = data.aws_iam_policy_document.inspector_event_role_policy.json
}
