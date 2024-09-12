variable "project_name" {
  description = "For naming resources according to the project"
  type        = string
  default     = "rails"
}

variable "subnets" {
  description = "Public subnets to deploy the load balancer in"
  type        = list(string)
}

variable "bucket" {
  description = "ID for bucket for storing logs in"
  type        = string
}

variable "vpc_id" {
  description = "ID for the VPC to deploy the load balancer in"
  type        = string
}