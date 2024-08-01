variable "aws_region" {
  description = "The region to deploy the web server"
  type        = string
  default     = "us-east-1"
}

variable "reserved_subnet_cidrs" {
  description = "Private reserved subnet CIDR values"
  type        = list(string)
  default     = ["10.17.0.0/20", "10.17.64.0/20"]
}

variable "reserved_subnet_netnums" {
  description = "Private reserved IPv6 cidr prefix"
  type        = list(number)
  default     = [0, 4]
}

variable "db_subnet_cidrs" {
  description = "Private database subnet CIDR values"
  type        = list(string)
  default     = ["10.17.16.0/20", "10.17.80.0/20"]
}

variable "app_subnet_cidrs" {
  description = "Private application subnet CIDR values"
  type        = list(string)
  default     = ["10.17.32.0/20", "10.17.96.0/20"]
}

variable "web_subnet_cidrs" {
  description = "Public web subnet CIDR values"
  type        = list(string)
  default     = ["10.17.48.0/20", "10.17.112.0/20"]
}

