/**
Name: Cloud Resilient Ruby-on-Rails Infrastructure
Contributors: HK Transfield
*/

data "aws_availability_zones" "available" {}

################################################################################
# Rails Network Infrastructure Module
################################################################################

locals {
  az_a = data.aws_availability_zones.available.names[0]
  az_b = data.aws_availability_zones.available.names[1]
}

module "rails-network" {
  source     = "./modules/rails-network"
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
# Rails Autoscaling Group Module
################################################################################

#TODO

################################################################################
# Rails Application Load Balancer Module
################################################################################

#TODO

################################################################################
# Rails Application Server Instance Module
################################################################################

data "aws_key_pair" "this" {
  key_name = "rails-key"
}

module "rails-app-server-A" {
  source    = "./modules/rails-app-server"
  key_name  = data.aws_key_pair.this.key_name
  vpc_id    = module.rails-network.vpc_id
  subnet_id = module.rails-network.app_a_subnet_id
}

# module "rails-app-server-B" {
#   source    = "./modules/rails-app-server"
#   key_name  = data.aws_key_pair.this.key_name
#   vpc_id    = module.rails-network.vpc_id
#   subnet_id = module.rails-network.app_b_subnet_id
# }

################################################################################
# Rails Database Instance Module
################################################################################

#TODO
