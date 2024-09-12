/**
Module for creating a simple network architecture in AWS.

Contributors: HK Transfield
*/
data "aws_availability_zones" "available" {}

locals {
  newbits     = 8
  vpc_prefix  = "vpc1"
  az_prefixes = ["A", "B"]
}

################################################################################
# Virtual Private Cloud
################################################################################

locals {
  vpc_name = "${var.project_name}-${local.vpc_prefix}"
}

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name    = local.vpc_name
    Project = var.project_name
  }
}

################################################################################
# Subnets
################################################################################

locals {
  subnet_name = "${var.project_name}-sn"
}

resource "aws_subnet" "db" {
  for_each                        = var.db_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = each.value.availability_zone
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "${local.subnet_name}-db-${each.key}"
    Project = var.project_name
  }
}

resource "aws_subnet" "app" {
  for_each                        = var.app_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = each.value.availability_zone
  assign_ipv6_address_on_creation = true

  tags = {
    Name    = "${local.subnet_name}-app-${each.key}"
    Project = var.project_name
  }
}

resource "aws_subnet" "web" {
  for_each                        = var.web_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = each.value.availability_zone
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true

  tags = {
    Name    = "${local.subnet_name}-web-${each.key}"
    Project = var.project_name
  }
}

################################################################################
# Internet Gateway
################################################################################

locals {
  igw_name = "${local.vpc_name}-igw"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = local.igw_name
    Project = var.project_name
  }
}

################################################################################
# Network Address Translation Gateway w/ Elastic IPs
################################################################################

locals {
  nat_gateway_name = "${local.vpc_name}-natgw"
}

resource "aws_nat_gateway" "this" {
  for_each          = aws_subnet.web
  subnet_id         = each.value.id
  allocation_id     = aws_eip.this[each.key].id
  connectivity_type = "public"

  tags = {
    Name    = "${local.nat_gateway_name}-${each.key}"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.this] # Recommended to add explicit dependency on IGW for VPC.
}

resource "aws_eip" "this" {
  for_each = toset(local.az_prefixes)
  domain   = "vpc"
}

################################################################################
# Public Route Tables
################################################################################

locals {
  route_table_name = "${local.vpc_name}-rt"
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }

  tags = {
    Name    = "${local.route_table_name}-web"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "web" {
  for_each       = aws_subnet.web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.web.id
}

################################################################################
# Private Route Tables
################################################################################

resource "aws_route_table" "private" {
  for_each = toset(local.az_prefixes)
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name    = "${local.route_table_name}-private-${each.key}"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "db" {
  for_each       = aws_subnet.db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "app" {
  for_each       = aws_subnet.app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}