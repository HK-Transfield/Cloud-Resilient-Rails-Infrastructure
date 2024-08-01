/**
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/
module "network" {
  source                = "./modules/rails-network"
  cidr_block            = "10.17.0.0/16"
  reserved_subnet_cidrs = ["10.17.0.0/20", "10.17.64.0/20"]
  db_subnet_cidrs       = ["10.17.16.0/20", "10.17.80.0/20"]
  app_subnet_cidrs      = ["10.17.32.0/20", "10.17.96.0/20"]
  web_subnet_cidrs      = ["10.17.48.0/20", "10.17.112.0/20"]
}