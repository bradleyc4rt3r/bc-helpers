#####
# Bastion EC2 instance
#####

data "aws_availability_zones" "available" {
  state = "available"
}

#  Bastion EC2 instance 
resource "aws_instance" "bastion" {
  count                  = var.bastion_count
  subnet_id              = var.pub_subnet_id[0] 
  vpc_security_group_ids = [var.ssh_access_sg]
  instance_type          = var.bastion_instance_type
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile[0].name
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.bastion_kp[0].key_name
  user_data              = data.template_file.bastion_user_data.rendered

  disable_api_termination = false #changed from true, this prevents a full terraform destroy

  tags = {
    Name        = "${var.project_prefix}-ec2-bastion"
    environment = var.environment
    CreatedBy = "Terraform"
  }
}


data "template_file" "bastion_user_data" {
  template = file("${path.module}/templates/ec2/user_data.sh")
  vars = {
    ec2_kp_developer_pub_key = var.ec2_kp_developer_pub_key
    bastion_ssh_port         = var.bastion_ssh_port
    project_prefix           = var.project_prefix
  }
}
