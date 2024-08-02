/**
Module for creating a simple network architecture in AWS.

Contributors: HK Transfield
*/
data "aws_availability_zones" "available" {}

locals {
  newbits = 8
}

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.name_prefix}-vpc1"
  }
}

resource "aws_subnet" "reserved" {
  for_each                        = var.reserved_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = data.aws_availability_zones.available.names[each.value.az_name_index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.name_prefix}-sn-reserved-${each.key}"
  }
}

resource "aws_subnet" "db" {
  for_each                        = var.db_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = data.aws_availability_zones.available.names[each.value.az_name_index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.name_prefix}-sn-db-${each.key}"
  }
}

resource "aws_subnet" "app" {
  for_each                        = var.app_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = data.aws_availability_zones.available.names[each.value.az_name_index]
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.name_prefix}-sn-app-${each.key}"
  }
}

resource "aws_subnet" "web" {
  for_each                        = var.web_subnet_cidrs
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.newbits, each.value.ipv6_cidr_block_netnum)
  availability_zone               = data.aws_availability_zones.available.names[each.value.az_name_index]
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true

  tags = {
    Name = "${var.name_prefix}-sn-web-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-vpc1-igw"
  }
}

resource "aws_route_table" "this" {
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
    Name = "${var.name_prefix}-vpc1-rt-web"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = aws_subnet.web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.this.id
}