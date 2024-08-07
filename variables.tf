variable "aws_region" {
  description = "The region to deploy the web server"
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "CIDR block to assign to VPC"
  type        = string
  default     = ""
}

variable "reserved" {
  description = "Private reserved subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
  default = {}
}

variable "db" {
  description = "Private database subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
  default = {}
}

variable "app" {
  description = "Private application subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
  default = {}
}

variable "web" {
  description = "Public web subnet CIDR values"
  type = map(object({
    cidr_block             = string
    ipv6_cidr_block_netnum = number
    az_name_index          = number
  }))
  default = {}
}