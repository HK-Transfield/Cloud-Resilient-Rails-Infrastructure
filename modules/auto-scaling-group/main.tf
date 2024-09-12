locals {
  asg_name    = "${local.project_name}-asg"
  bucket_name = "${locals.project_name}-logs-${random_id.bucket.hex}"
}

resource "aws_autoscaling_group" "this" {
  name                      = local.asg_name
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.rails-network.app_a_subnet_id, module.rails-network.app_b_subnet_id]
  # target_group_arns         = var.target_group_arns
  #   launch_configuration      = aws_launch_configuration.rubyonrails.name
}

resource "random_id" "bucket" {
  byte_length = 8
}

resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_name
}
