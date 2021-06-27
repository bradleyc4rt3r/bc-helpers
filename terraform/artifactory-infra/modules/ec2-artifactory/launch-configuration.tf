#####
# Launch Configuration
#####

#  artifactory EC2 instance 
resource "aws_launch_configuration" "ec2_artifactory_launch" {
  name                 = "${var.project_prefix}-launch-artifactory-${var.ec2_artifactory_launch_version}"
  image_id             = data.aws_ami.artifactory_ami.id
  instance_type        = var.ec2_artifactory_instance_type
  key_name             = var.ec2_artifactory_key_name
  security_groups      = [aws_security_group.ec2_artifactory.id]
  iam_instance_profile = aws_iam_instance_profile.artifactory_profile.name
  user_data            = data.template_file.ec2_artifactory_user_data.rendered  
  enable_monitoring    = true
  ebs_optimized        = true

  root_block_device {
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = "false"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ec2_artifactory_user_data" {
  template = file("${path.module}/templates/ec2/user_data.sh")
  vars = {
    project-prefix     = var.project_prefix
    artifactory-bucket = var.artifactory_bucket
    domain-name        = var.domain_name
  }
}
