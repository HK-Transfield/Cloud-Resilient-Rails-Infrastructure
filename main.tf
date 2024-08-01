/*
Name: Ruby on Rails AWS Web Server
Contributors: HK Transfield
*/

locals {
  common_tags = {
    Code = "ror"
  }
}

# resource "aws_instance" "webserver" {
#   ami           = "ami-0427090fd1714168b"
#   instance_type = "t2.micro"

#   # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-development-environment.html
#   # https://rvm.io/
#   # https://www.ruby-lang.org/en/documentation/installation/
#   provisioner "remote-exec" {
#     inline = [
#       # Install dependencies to run Rails
#       "sudo yum install ruby",
#       "ruby --version",
#       "sudo yum install sqlite3",
#       "sqlite3 --version",
#       "gem install rails",
#       "rails --version",

#       # Create Rails server
#       "rails new webapp",
#       "cd webapp",
#       "bin/rails server"
#     ]
#   }

#   tags = {
#     Name = "rails-server"
#     Code = "ror"
#   }
# }

resource "aws_vpc" "main" {
  cidr_block       = "10.17.0.0/16"
  instance_tenancy = "default"

  tags = local.common_tags
}

resource "aws_subnet" "reserved" {
  count             = length(var.reserved_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.reserved_subnet_cidrs, count.index)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, element(var.reserved_subnet_netnums, count.index))
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "sn-reserved-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.db_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "sn-db-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.app_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "sn-app-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "web" {
  count             = length(var.web_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.web_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "sn-web-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}