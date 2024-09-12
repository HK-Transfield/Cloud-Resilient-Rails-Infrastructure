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

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}