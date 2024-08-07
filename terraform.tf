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
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.4"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# No configuration needed for this provider
provider "cloudinit" {}