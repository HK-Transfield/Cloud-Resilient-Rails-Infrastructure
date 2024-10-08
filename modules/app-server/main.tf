/**
Name: Cloud Resilient Auto Scaling Group Module
Author: HK Transfield, 2024

Creates an Auto Scaling Group  to scale EC2 instances across multiple 
Availability Zones.

This module is designed to be used as part of the Cloud Resilient Rails 
Infrastructure project.
*/

locals {
  app_server_name = "${var.project_name}-app-server"
}

################################################################################
# User Data
################################################################################

locals {
  filename = "install_rails.sh"
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
# Session Manager IAM Role
################################################################################

locals {
  iam_name = "${var.project_name}-ssm-ec2"
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_ec2" {
  name               = "${local.iam_name}-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  tags               = var.project_tags
}

# The policy for Amazon EC2 Role to enable AWS Systems Manager service core functionality.
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ssm_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_ec2" {
  name = "${local.iam_name}-instance-profile"
  role = aws_iam_role.ssm_ec2.name
  tags = var.project_tags
}

################################################################################
# Launch Template Configuration
################################################################################

locals {
  lt_name = "${var.project_name}-launch-template"
}

resource "aws_launch_template" "this" {
  name                   = local.lt_name
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_ec2.name
  }

  #! fixme: This may not be working as intended yet
  # user_data              = data.cloudinit_config.user_data.rendered

  tag_specifications {
    resource_type = "instance"
    tags          = merge({ Name = "${local.app_server_name}" }, var.project_tags)
  }

  tags = var.project_tags
}

################################################################################
# Auto Scaling Group Configuration
################################################################################

locals {
  asg_name = "${var.project_name}-asg"
}

resource "aws_autoscaling_group" "this" {
  name                      = local.asg_name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

################################################################################
# Security Group
################################################################################

locals {
  app_server_security_group_name = "${local.app_server_name}-sg"
}

resource "aws_security_group" "this" {
  name        = local.app_server_security_group_name
  description = "Security Group for the ${var.project_name} Web Server"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_web" {
  security_group_id            = aws_security_group.this.id
  description                  = "HTTP from the Load Balancer"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.lb_sg
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_web" {
  security_group_id            = aws_security_group.this.id
  description                  = "HTTPS from the Load Balancer"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.lb_sg
}

resource "aws_vpc_security_group_ingress_rule" "allow_local_web" {
  security_group_id            = aws_security_group.this.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.lb_sg
}

#? Need to finish configuring the database
# resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
#   security_group_id            = aws_security_group.this.id
#   from_port                    = 3306
#   to_port                      = 3306
#   ip_protocol                  = "-1" # Allows all outbound traffic
#   referenced_security_group_id = var.db_sg
# }

#? Remove this later
resource "aws_vpc_security_group_egress_rule" "allow_all_http" {
  security_group_id = aws_security_group.this.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp" # Allows all outbound traffic
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_https" {
  security_group_id = aws_security_group.this.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp" # Allows all outbound traffic
  cidr_ipv4         = "0.0.0.0/0"
}