/**
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/

data "aws_key_pair" "this" {
  key_name = "rails-key"
}

module "rails-web-server" {
  source   = "./modules/rails-web-server"
  key_name = data.aws_key_pair.this.key_name
}

module "rails-network" {
  source                = "./modules/rails-network"
  cidr_block            = var.cidr_block
  reserved_subnet_cidrs = var.reserved
  db_subnet_cidrs       = var.db
  app_subnet_cidrs      = var.app
  web_subnet_cidrs      = var.web
}