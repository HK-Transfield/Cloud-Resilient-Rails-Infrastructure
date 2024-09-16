variable "project_name" {
  description = "For naming resources according to the project"
  type        = string
}

variable "project_tags" {
  type = map(string)
}

variable "min_size" {
  description = "The minimum capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum capacity of the Auto Scaling Group"
  type        = number
  default     = 2

}

variable "desired_capacity" {
  description = "The maximum capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC to launch the EC2 instance in"
  type        = string
}

variable "target_group_arns" {
  description = "Set of ARNs, for use with Application Load Balancing"
  type        = list(string)
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of an Amazon EC2 key pair"
  type        = string
}

variable "lb_sg" {
  description = "Load Balancer security group to source traffic from"
  type        = string
}

#? Need to finish configuring the database
# variable "db_sg" {
#   description = "Database security group to send traffic to"
#   type        = string
# }

variable "my_ip" {
  description = "Personal IP address for connecting to SSH"
  type        = string
  sensitive   = true
}