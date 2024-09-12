variable "project_name" {
  description = "For naming resources according to the project."
  type        = string
  default     = "rails"
}

################################################################################
# EC2 Settings
################################################################################

variable "key_name" {
  description = "The name of an Amazon EC2 key pair."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
  default     = "t2.micro"
}

################################################################################
# Network Settings
################################################################################

variable "vpc_id" {
  description = "The VPC to launch the EC2 instance in."
  type        = string
}

variable "subnet_id" {
  description = "The VPC subnet ID to launch in."
  type        = string
}

variable "vpc_zone_identifiers" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)
}

################################################################################
# Load Balancers
################################################################################

variable "target_group_arns" {
  description = "Set of ARNS for use with Application Load Balancing"
  type        = list(string)
}