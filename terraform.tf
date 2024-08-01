terraform {
  cloud {

    organization = "HKT-Projects"

    workspaces {
      name = "cloud-resilient-rails-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}