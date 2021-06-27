#####
# Launch Template with AMI
#####
resource "aws_launch_template" "launch_template_eks_node" {
  name                   = "${var.project_prefix}-eks-node-launch"
  image_id               = var.ubuntu_ami
  key_name               = var.key_pair
  ebs_optimized          = true
  vpc_security_group_ids = flatten([var.private_security_group])
  user_data              = base64encode(data.template_file.eks_user_data.rendered)

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.node_disk_size
      volume_type = "gp2"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_prefix}-eks-node"
      environment = var.environment
      CreatedBy   = "Terraform"
    }
  }

  tags = {
    Name        = "${var.project_prefix}-eks-node-launch"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

data "template_file" "eks_user_data" {
  template = file("${path.module}/templates/ec2/userdata.tpl")
  vars = {
    CLUSTER_NAME   = aws_eks_cluster.cluster.name
    B64_CLUSTER_CA = aws_eks_cluster.cluster.certificate_authority[0].data
    API_SERVER_URL = aws_eks_cluster.cluster.endpoint
    project_prefix = var.project_prefix
  }
}
