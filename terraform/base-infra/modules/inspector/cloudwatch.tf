#####
# Cloudwatch for Inspector
#####

resource "aws_cloudwatch_event_rule" "inspector_event_schedule" {
  name                = "${var.project_prefix}-cw-inspector-schedule"
  description         = "Trigger an Inspector Assessment"
  schedule_expression = substr(var.project_prefix, 5, 3) == "prd" ? "rate(7 days)" : "rate(15 days)"
  # schedule_expression = "rate(7 days)"

  tags = {
    Name        = "${var.project_prefix}-inspector-schedule"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_cloudwatch_event_target" "inspector_event_target" {
  rule     = aws_cloudwatch_event_rule.inspector_event_schedule.name
  arn      = aws_inspector_assessment_template.assessment_template.arn
  role_arn = aws_iam_role.inspector_event_role.arn
}
