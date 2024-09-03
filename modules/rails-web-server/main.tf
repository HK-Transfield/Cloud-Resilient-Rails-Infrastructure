/**
Name: Ruby of Rails EC2 Instance
Contributors: HK Transfield
*/

################################################################################
# Amazon Machine Image (AMI)
################################################################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################################################################
# EC2 User Data
################################################################################

data "cloudinit_config" "user_data" {
  part {
    filename     = local.filename
    content_type = "text/x-shellscript"

    content = file(local.filepath)
  }
}

locals {
  filename = "install_rails_yum.sh"
  filepath = "${path.module}/scripts/${local.filename}"
}

################################################################################
# EC2 Web Server
################################################################################

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.webserver.id]

  tags = {
    Name    = "${var.name_prefix}-web-server"
    Project = var.name_prefix
  }

  user_data = data.cloudinit_config.user_data.rendered
}

################################################################################
# VPC Security Group
################################################################################

resource "aws_security_group" "webserver" {
  name        = "${var.name_prefix}-sg"
  description = "Security Group for ${var.name_prefix} Web Server"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.name_prefix}-sg"
    Project = var.name_prefix
  }
}

resource "aws_vpc_security_group_ingress_rule" "name" {
  security_group_id = aws_security_group.webserver.id
  description       = "SSH from anywhere"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "name" {
  security_group_id = aws_security_group.webserver.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1" # Allows all outbound traffic
  cidr_ipv4         = "0.0.0.0/0"
}