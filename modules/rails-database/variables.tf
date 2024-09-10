variable "name_prefix" {
  description = "For naming resources according to the project"
  type        = string
  default     = "rails"
}

################################################################################
# Database Settings
################################################################################

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs"
  type        = list(string)
}

################################################################################
# Database Settings
################################################################################

variable "rds_engine" {
  description = "The database engine."
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "The database engine version."
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "The instance type for the database"
  type        = string
  default     = "db.t2.micro"
}

variable "rds_allocated_storage" {
  description = "The amount of storage in GB for the database"
  type        = number
  default     = 10
}

variable "skip_final_snapshot" {
  description = "Skips final snapshot of the database"
  type        = bool
  default     = true
}

################################################################################
# Database Login
################################################################################

variable "db_username" {
  description = "The admin username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The admin password for the database"
  type        = string
  sensitive   = true
}