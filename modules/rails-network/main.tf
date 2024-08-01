/**
Module for creating a simple network architecture in AWS.

Contributors: HK Transfield
*/
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.name_prefix}-vpc1"
  }
}

resource "aws_subnet" "reserved" {
  count             = length(var.reserved_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.reserved_subnet_cidrs, count.index)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, element(var.reserved_subnet_netnums, count.index))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-sn-reserved-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.db_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-sn-db-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.app_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-sn-app-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

resource "aws_subnet" "web" {
  count             = length(var.web_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.web_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-sn-web-${(count.index + 1) % 2 == 0 ? "B" : "A"}"
  }
}

# todo: Create igw to attach to web subnets -> 'rails-vpc1-igw
# todo: Create route tables for web subnets (default IPv4 route, default IPv6 route) -> rails-vpc1-rt-web