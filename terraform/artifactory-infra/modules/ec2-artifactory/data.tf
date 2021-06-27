# # artifactory ami
# data "aws_ami" "artifactory_ami" {
#   most_recent = true

#   owners = ["${var.account_id}"]

#   filter {
#     name   = "name"
#     values = ["artifactory-*"]
#   }
# }


data "aws_ami" "artifactory_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["*ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }


  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

}
