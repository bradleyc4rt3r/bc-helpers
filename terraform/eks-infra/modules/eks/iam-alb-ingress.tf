#####
# IAM for ALB ingress
#####

# EKS Cluster
resource "aws_iam_role" "iam_role_eks_lb" {
  name = "${var.project_prefix}-role-eks-lb"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": [
          "sts:AssumeRole", 
          "sts:AssumeRoleWithWebIdentity"
        ]
    }
  ]
}
POLICY

  tags = {
    Name        = "${var.project_prefix}-role-eks-lb"
    environment = var.environment
    CreatedBy = "Terraform"
  }

}

resource "aws_iam_role_policy_attachment" "lb_controller_policy" {
  policy_arn = aws_iam_policy.lb_controller.arn
  role       = aws_iam_role.iam_role_eks_lb.name
}

resource "aws_iam_policy" "lb_controller" {
  name        = "${var.project_prefix}-policy-eks-lb"
  path        = "/"
  description = "ALB ingress controller IAM policy"
  policy = templatefile("lb_controller_policy.json", {})
}
