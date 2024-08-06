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

## SECTION 1: Virtual Private Cloud
resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.name_prefix}-${local.vpc_prefix}"
  }
}

## SECTION 2: Subnets
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

## SECTION 3: Internet Gateways
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-${local.vpc_prefix}-igw"
  }
}

## SECTION 4: Network Address Translation Gateway w/ Elastic IPs
resource "aws_nat_gateway" "this" {
  for_each          = aws_subnet.web
  subnet_id         = each.value.id
  allocation_id     = aws_eip.this[each.key].id
  connectivity_type = "public"

  tags = {
    Name = "${var.name_prefix}-${local.vpc_prefix}-natgw-${each.key}"
  }

  depends_on = [aws_internet_gateway.this] # Recommended to add explicit dependency on IGW for VPC.
}

resource "aws_eip" "this" {
  for_each = toset(local.az_prefixes)
  domain   = "vpc"
}

## SECTION 4: Route Tables
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
    Name = "${var.name_prefix}-${local.vpc_prefix}-rt-web"
  }
}

resource "aws_route_table_association" "web" {
  for_each       = aws_subnet.web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table" "private" {
  for_each = toset(local.az_prefixes)
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${var.name_prefix}-${local.vpc_prefix}-rt-private${each.key}"
  }
}

resource "aws_route_table_association" "reserved" {
  for_each       = aws_subnet.reserved
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
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