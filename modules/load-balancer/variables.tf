variable "project_name" {
  description = "For naming resources according to the project"
  type        = string
}

variable "project_tags" {
  type = map(string)
}

variable "subnets" {
  description = "Public subnets to deploy the load balancer in"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID for the VPC to deploy the load balancer in"
  type        = string
}