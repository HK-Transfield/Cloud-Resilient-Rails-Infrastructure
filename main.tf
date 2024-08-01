/*
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/
data "aws_availability_zones" "available" {}

resource "aws_instance" "webserver" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-development-environment.html
  # https://rvm.io/
  # https://www.ruby-lang.org/en/documentation/installation/
  provisioner "remote-exec" {
    inline = [
      # Install dependencies to run Rails
      "sudo yum install ruby",
      "ruby --version",
      "sudo yum install sqlite3",
      "sqlite3 --version",
      "gem install rails",
      "rails --version",

      # Create Rails server
      "rails new webapp",
      "cd webapp",
      "bin/rails server"
    ]
  }

  tags = {
    Name = "rails-web-server"
  }
}

module "network" {
  source                = "./modules/hkt-rails-network"
  reserved_subnet_cidrs = ["10.17.0.0/20", "10.17.64.0/20"]
  db_subnet_cidrs       = ["10.17.16.0/20", "10.17.80.0/20"]
  app_subnet_cidrs      = ["10.17.32.0/20", "10.17.96.0/20"]
  web_subnet_cidrs      = ["10.17.48.0/20", "10.17.112.0/20"]
}