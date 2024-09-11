/**
Name: Ruby of Rails Autoscaling Group
Contributors: HK Transfield
*/

################################################################################
# Autoscaling Group
################################################################################

locals {
  asg_name = "${var.project_name}-asg"
}

resource "aws_autoscaling_group" "this" {
  name                      = "rubyonrails"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_configuration      = aws_launch_configuration.rubyonrails.name
  vpc_zone_identifier       = [aws_subnet.rubyonrails.id]
  target_group_arns         = [aws_lb_target_group.rubyonrails.arn]
}