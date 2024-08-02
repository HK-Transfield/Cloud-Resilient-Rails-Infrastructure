/**
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/
module "webapp" {
  source          = "./modules/rails-web-server"
  script_filename = "script.sh"
}

module "network" {
  source     = "./modules/rails-network"
  cidr_block = "10.17.0.0/16"
  reserved_subnet_cidrs = {
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

  db_subnet_cidrs = {
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

  app_subnet_cidrs = {
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

  web_subnet_cidrs = {
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