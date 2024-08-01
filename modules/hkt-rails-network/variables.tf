variable "reserved_subnet_cidrs" {
  description = "Private reserved subnet CIDR values"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "Private database subnet CIDR values"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "Private application subnet CIDR values"
  type        = list(string)
}

variable "web_subnet_cidrs" {
  description = "Public web subnet CIDR values"
  type        = list(string)
}

variable "reserved_subnet_netnums" {
  description = "Private reserved IPv6 cidr prefix"
  type        = list(number)
  default     = [0, 4]
}