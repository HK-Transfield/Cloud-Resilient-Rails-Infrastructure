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

variable "target_group_arns" {
  description = "Set of ARNs, for use with Application Load Balancing"
  type        = list(string)
}