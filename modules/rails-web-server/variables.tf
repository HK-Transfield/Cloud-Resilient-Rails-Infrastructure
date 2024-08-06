variable "name_prefix" {
  description = "For naming resources according to the project."
  type        = string
  default     = "rails"
}

variable "key_name" {
  description = "The name of an Amazon EC2 key pair."
  type        = string
}