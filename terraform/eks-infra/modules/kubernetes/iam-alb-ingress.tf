#####
# IAM for ALB Ingress
#####

resource "aws_iam_policy" "alb_ingress_policy" {
  name   = "${var.project_prefix}-pol-eks-alb-ingress-controller"
  policy = data.template_file.lb_controller_policy.rendered
}


data "template_file" "lb_controller_policy" {
  template = file("${path.module}/templates/iam/lb-controller-policy.json")
}


resource "aws_iam_role" "eks_alb_ingress_controller" {
  name        = "${var.project_prefix}-rol-eks-alb-ingress-controller"
  description = "Permissions required by the Kubernetes AWS ALB Ingress controller to do it's job."

  force_detach_policies = true

  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:alb-ingress-controller"
        }
      }
    }
  ]
}
ROLE

  tags = {
    Name        = "${var.project_prefix}-rol-eks-alb-ingress-controller"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}

resource "aws_iam_policy" "alb_ingress_admin_policy" {
  name        = "${var.project_prefix}-pol-eks-alb-ingress-controller-admin"
  description = "Permissions required by the Kubernetes AWS ALB Ingress controller to do it's job."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1620918348440",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "alb_ingress_admin_policy_attachment" {
  policy_arn = aws_iam_policy.alb_ingress_admin_policy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}
