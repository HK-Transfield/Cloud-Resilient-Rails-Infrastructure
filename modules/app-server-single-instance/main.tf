/**
Name: Cloud Resilient Application Server Module
Author: HK Transfield, 2024

Provisions a simple application server using Amazon EC2 instances. Included 
in the module is a  bash script for installing the Ruby Version Manager (RVM) 
and Rails, along with any other required dependencies. This script is passed 
into the instance as user data.

This module is designed to be used as part of the Cloud Resilient Rails 
Infrastructure project.
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
# User Data
################################################################################

locals {
  filename = "install_rails_yum.sh"
  filepath = "${path.module}/scripts/${local.filename}"
}

data "cloudinit_config" "user_data" {
  part {
    filename     = local.filename
    content_type = "text/x-shellscript"

    content = file(local.filepath)
  }
}

################################################################################
# EC2 Instance
################################################################################

locals {
  web_server_name = "${var.project_name}-app-server"
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name    = local.web_server_name
    Project = var.project_name
  }

  #! This is not working as intented
  # user_data = data.cloudinit_config.user_data.rendered
}

################################################################################
# Security Group
################################################################################

locals {
  web_server_security_group_name = "${local.web_server_name}-sg"
}

resource "aws_security_group" "this" {
  name        = local.web_server_security_group_name
  description = "Security Group for the ${var.project_name} Web Server"
  vpc_id      = var.vpc_id

  tags = {
    Name    = local.web_server_security_group_name
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ssh" {
  security_group_id = aws_security_group.this.id
  description       = "SSH from anywhere"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.this.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1" # Allows all outbound traffic
  cidr_ipv4         = "0.0.0.0/0"
}