/**
Name: Cloud Resilient Ruby-on-Rails Infrastructure
Contributors: HK Transfield, 2024

A simple Infrastructure-as-Code (IAC) project that 
provisions a simple Ruby-on-Rails application in 
AWS using Terraform. 
*/

################################################################################
# Rails Network Configuration
################################################################################

data "aws_availability_zones" "available" {}

locals {
  az_a = data.aws_availability_zones.available.names[0]
  az_b = data.aws_availability_zones.available.names[1]
}

module "rails-network" {
  source     = "./modules/network"
  cidr_block = "10.17.0.0/16"
  db_subnet_cidrs = {
    "A" = {
      cidr_block             = "10.17.16.0/20"
      ipv6_cidr_block_netnum = 1
      availability_zone      = local.az_a
    }
    "B" = {
      cidr_block             = "10.17.80.0/20"
      ipv6_cidr_block_netnum = 5
      availability_zone      = local.az_b
    }
  }
  app_subnet_cidrs = {
    "A" = {
      cidr_block             = "10.17.32.0/20"
      ipv6_cidr_block_netnum = 2
      availability_zone      = local.az_a
    }
    "B" = {
      cidr_block             = "10.17.48.0/20"
      ipv6_cidr_block_netnum = 6
      availability_zone      = local.az_b
    }
  }
  web_subnet_cidrs = {
    "A" = {
      cidr_block             = "10.17.96.0/20"
      ipv6_cidr_block_netnum = 3
      availability_zone      = local.az_a
    }
    "B" = {
      cidr_block             = "10.17.112.0/20"
      ipv6_cidr_block_netnum = 7
      availability_zone      = local.az_b
    }
  }
}

################################################################################
# Rails Autoscaling Group Configuration
################################################################################

locals {
  asg_name = "rails-asg"
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

################################################################################
# Rails Application Load Balancer Configuration
################################################################################

#TODO

################################################################################
# Rails Application Server Configuration
################################################################################

data "aws_key_pair" "this" {
  key_name = "rails-key"
}

module "rails-app-server-A" {
  source    = "./modules/app-server"
  key_name  = data.aws_key_pair.this.key_name
  vpc_id    = module.rails-network.vpc_id
  subnet_id = module.rails-network.app_a_subnet_id
}

# module "rails-app-server-B" {
#   source    = "./modules/app-server"
#   key_name  = data.aws_key_pair.this.key_name
#   vpc_id    = module.rails-network.vpc_id
#   subnet_id = module.rails-network.app_b_subnet_id
# }

################################################################################
# Rails Database Configuration
################################################################################

#TODO
