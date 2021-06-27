#####
# Bastion Elastic IP
#####

resource "aws_eip" "elastic_ip" {
  vpc = true

  tags = {
    Name        = "${var.project_prefix}-ec2-bastion"
    environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion[0].id
  allocation_id = aws_eip.elastic_ip.id
}


