#####
# AWS EC2 KeyPair
#####

#  Key Pair
resource "aws_key_pair" "bastion_kp" {
  count      = var.bastion_count
  key_name   = "${var.project_prefix}-kp-ec2"
  public_key = var.ec2_kp_sudo_pub_key

  tags = {
    Name        = "${var.project_prefix}-kp-ec2"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}
