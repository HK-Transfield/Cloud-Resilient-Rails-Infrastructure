variable "name_prefix" {
  description = "For naming resources according to the project"
  type        = string
  default     = "rails"
}

################################################################################
# VPC Configuration
################################################################################

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

################################################################################
# Subnet Configurations
################################################################################

variable "db_subnet_cidrs" {
  description = "Private database subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}

variable "app_subnet_cidrs" {
  description = "Private application subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}

variable "web_subnet_cidrs" {
  description = "Public web subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}