variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "reserved_subnet_cidrs" {
  description = "Private reserved subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
}

variable "db_subnet_cidrs" {
  description = "Private database subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
}

variable "app_subnet_cidrs" {
  description = "Private application subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
}

variable "web_subnet_cidrs" {
  description = "Public web subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
}

variable "name_prefix" {
  description = "For naming resources according to the project"
  type        = string
  default     = "rails"
}