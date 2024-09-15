/**
Name: Cloud Resilient Auto Scaling Group Module
Author: HK Transfield, 2024

Creates an Auto Scaling Group  to scale EC2 instances across multiple 
Availability Zones.

This module is designed to be used as part of the Cloud Resilient Rails 
Infrastructure project.
*/

################################################################################
# Launch Template Configuration
################################################################################

#TODO - Add in the Launch Template Configuration

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
}

