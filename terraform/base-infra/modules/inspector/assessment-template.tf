#####
# Inspector Assessment Template
#####

resource "aws_inspector_assessment_template" "assessment_template" {
  name       = "${var.project_prefix}-inspector-assessment-template"
  target_arn = aws_inspector_assessment_target.assessment_target.arn
  duration   = substr(var.project_prefix, 5, 3) == "prd" ? "3600" : "900"
  #  duration   = 3600

  rules_package_arns = data.aws_inspector_rules_packages.rules.arns

  tags = {
    Name        = "${var.project_prefix}-inspector-assessment-template"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}
