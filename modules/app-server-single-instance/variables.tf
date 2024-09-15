variable "project_name" {
  description = "For naming resources according to the project."
  type        = string
  default     = "rails"
}

variable "project_tags" {
  type = map(string)
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