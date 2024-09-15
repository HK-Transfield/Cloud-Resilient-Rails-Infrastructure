variable "project_name" {
  description = "For naming resources according to the project"
  type        = string
}

variable "project_tags" {
  type = map(string)
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

variable "db_sn" {
  description = "Private database subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}

variable "app_sn" {
  description = "Private application subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}

variable "web_sn" {
  description = "Public web subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    availability_zone      = string
  }))
}