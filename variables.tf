variable "aws_region" {
  description = "The region to deploy the web server"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "The master username for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The master password for the RDS database"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "Personal IP address for SSH access"
  type        = string
  sensitive   = true
}