/**
Name: Cloud Resilient Application Load Balancing Module
Author: HK Transfield, 2024

Provides a simple internet facing Application Load Balancer (ALB). The 
ALB will automatically distribute traffic across the EC2 instances in 
multiple Availability Zones.

This module is designed to be used as part of the Cloud Resilient Rails 
Infrastructure project.
*/

################################################################################
# Log Storage Configuration
################################################################################

data "aws_elb_service_account" "main" {}

locals {
  bucket_name = "${local.alb_name}-logs-${random_id.this.hex}"
}

resource "random_id" "this" {
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  force_destroy = true # To destroy the alb log prefixes
  bucket        = local.bucket_name

  tags = {
    project = var.project_name
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}

data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
  }
}

################################################################################
# Application Load Balancer
################################################################################

locals {
  alb_name = "${var.project_name}-alb"
}

resource "aws_lb" "this" {
  name               = local.alb_name
  internal           = false # Make it internet facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnets

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
    prefix  = "access-logs"
  }

  connection_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
    prefix  = "connection-logs"
  }

  tags = {
    project = var.project_name
  }
}

################################################################################
# Target Group and Listeners
################################################################################

locals {
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group" "this" {
  name     = "${local.alb_name}-tg"
  port     = local.port
  protocol = local.protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = local.port
  protocol          = local.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

################################################################################
# Security Group
################################################################################

locals {
  alb_security_group_name = "${local.alb_name}-sg"
}

resource "aws_security_group" "this" {
  name   = local.alb_security_group_name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_internet" {
  security_group_id = aws_security_group.this.id
  description       = "HTTP from the Load Balancer"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_internet" {
  security_group_id = aws_security_group.this.id
  description       = "HTTPS from the Load Balancer"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_local_internet" {
  security_group_id = aws_security_group.this.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
#   security_group_id = aws_security_group.this.id
#   description       = "Send traffic out to the public internet"
#   ip_protocol       = "-1" # Allows all outbound traffic
#   cidr_ipv4         = "0.0.0.0/0"
# }

resource "aws_vpc_security_group_egress_rule" "send_http_app" {
  security_group_id            = aws_security_group.this.id
  description                  = "HTTP from the Load Balancer"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.asg_sg
}

resource "aws_vpc_security_group_egress_rule" "send_https_app" {
  security_group_id            = aws_security_group.this.id
  description                  = "HTTPS from the Load Balancer"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.asg_sg
}

resource "aws_vpc_security_group_egress_rule" "send_local_app" {
  security_group_id            = aws_security_group.this.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.asg_sg
}