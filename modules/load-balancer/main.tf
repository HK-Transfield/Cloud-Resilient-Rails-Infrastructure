/**
Name: Cloud Resilient Application Load Balancer Configuration
Contributors: HK Transfield, 2024
*/

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
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets

  access_logs {
    bucket  = var.bucket
    enabled = true
    prefix  = "access-logs"
  }

  connection_logs {
    bucket  = var.bucket
    enabled = true
    prefix  = "connection-logs"
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
