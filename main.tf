/**
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/

################################################################################
# Rails EC2 Instance
################################################################################

data "aws_key_pair" "this" {
  key_name = "rails-key"
}

module "rails-web-server" {
  source    = "./modules/rails-web-server"
  key_name  = data.aws_key_pair.this.key_name
  vpc_id    = module.rails-network.vpc_id
  subnet_id = module.rails-network.web_a_subnet_id
}

################################################################################
# Rails Network Architecture
################################################################################

locals {
  cidr_block = "10.17.0.0/16"

  reserved = {
    "A" = {
      cidr_block             = "10.17.0.0/20"
      ipv6_cidr_block_netnum = 0
      az_name_index          = 0
    }
    "B" = {
      cidr_block             = "10.17.64.0/20"
      ipv6_cidr_block_netnum = 4
      az_name_index          = 1
    }
  }

  db = {
    "A" = {
      cidr_block             = "10.17.16.0/20"
      ipv6_cidr_block_netnum = 1
      az_name_index          = 0
    }
    "B" = {
      cidr_block             = "10.17.80.0/20"
      ipv6_cidr_block_netnum = 5
      az_name_index          = 1
    }
  }

  app = {
    "A" = {
      cidr_block             = "10.17.32.0/20"
      ipv6_cidr_block_netnum = 2
      az_name_index          = 0
    }
    "B" = {
      cidr_block             = "10.17.48.0/20"
      ipv6_cidr_block_netnum = 6
      az_name_index          = 1
    }
  }

  web = {
    "A" = {
      cidr_block             = "10.17.96.0/20"
      ipv6_cidr_block_netnum = 3
      az_name_index          = 0
    }
    "B" = {
      cidr_block             = "10.17.112.0/20"
      ipv6_cidr_block_netnum = 7
      az_name_index          = 1
    }
  }
}

module "rails-network" {
  source                = "./modules/rails-network"
  cidr_block            = local.cidr_block
  reserved_subnet_cidrs = local.reserved
  db_subnet_cidrs       = local.db
  app_subnet_cidrs      = local.app
  web_subnet_cidrs      = local.web
}