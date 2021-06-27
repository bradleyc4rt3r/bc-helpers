#####
# Inspector Assessment Target
#####

resource "aws_inspector_assessment_target" "assessment_target" {
  name = "${var.project_prefix}-inspector-assessment-target"

}
