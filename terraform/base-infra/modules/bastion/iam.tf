#####
# IAM for Bastion
#####

resource "aws_iam_instance_profile" "bastion_profile" {
  count = var.bastion_count
  name  = "${var.project_prefix}-instance-profile-bastion-v1"
  role  = aws_iam_role.bastion_role[0].name

}

resource "aws_iam_role" "bastion_role" {
  count              = var.bastion_count
  name               = "${var.project_prefix}-rol-ec2-bastion"
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
    Name        = "${var.project_prefix}-rol-ec2-bastion"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# resource "aws_iam_role_policy" "bastion-role-policy" {
#   count      = var.bastion_count
#   name   = "${var.project_prefix}-pol-ec2-bastion"
#   role   = aws_iam_role.bastion_role.name
#   policy = data.template_file.bastion-ec2-role-policy.rendered
# tags = {
#   Name        = "${var.project_prefix}-pol-ec2-bastion"
#   environment = var.environment
# }
# }

# data "template_file" "bastion-ec2-role-policy" {
#   template = file(
#     "${path.module}/templates/iam/iam-role-policy-bastion.template",
#   )
# }
