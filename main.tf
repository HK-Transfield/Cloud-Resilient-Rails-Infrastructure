/**
Name: Cloud Resilient Ruby-on-Rails Infrastructure
Author: HK Transfield, 2024

A simple Infrastructure-as-Code (IAC) project that provisions a simple 
Ruby-on-Rails application in AWS using Terraform.
*/

################################################################################
# General Configuration Settings
################################################################################

locals {
  project_name = "rails"
  project_tags = {
    Project = local.project_name
  }
}

################################################################################
# Three-tiered VPC Network Configuration
################################################################################

data "aws_availability_zones" "available" {}

locals {
  az_a = data.aws_availability_zones.available.names[0]
  az_b = data.aws_availability_zones.available.names[1]
}

module "network" {
  source       = "./modules/network"
  project_name = local.project_name
  project_tags = local.project_tags
  cidr_block   = "10.17.0.0/16"
  db_sn = {
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
  app_sn = {
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
  web_sn = {
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
# Web Tier Configuration - Load Balancer & Storage
################################################################################

module "alb" {
  source       = "./modules/web-traffic"
  project_name = local.project_name
  project_tags = local.project_tags
  asg_sg       = module.app-server.asg_security_group_id
  vpc_id       = module.network.vpc_id
  subnets      = [module.network.web_a_subnet_id, module.network.web_b_subnet_id]
}

################################################################################
# App Tier Configuration - Auto Scaling Group 
################################################################################

data "aws_key_pair" "this" {
  key_name = "rails-key-pair"
}

module "app-server" {
  source              = "./modules/app-server"
  project_name        = local.project_name
  project_tags        = local.project_tags
  vpc_id              = module.network.vpc_id
  vpc_zone_identifier = [module.network.app_a_subnet_id, module.network.app_b_subnet_id]
  target_group_arns   = [module.alb.target_group_arn]
  lb_sg               = module.alb.lb_security_group_id
  key_name            = data.aws_key_pair.this.key_name
  my_ip               = var.my_ip
}

################################################################################
# Database Tier Configuration - RDS
################################################################################

#TODO - Add db config to root module
