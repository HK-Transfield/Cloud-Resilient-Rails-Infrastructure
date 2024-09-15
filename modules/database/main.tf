/**
Name: Cloud Resilient Database Module
Author: HK Transfield, 2024

Provisions a simple Amazon Relational Database Service (RDS) instance.

This module is designed to be used as part of the Cloud Resilient Rails 
Infrastructure project.
*/

################################################################################
# RDS Instance
################################################################################

locals {
  db_name = "${var.project_name}-db"
}

#TODO: https://medium.com/strategio/using-terraform-to-create-aws-vpc-ec2-and-rds-instances-c7f3aa416133
resource "aws_db_instance" "this" {
  identifier             = local.db_name
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  db_name                = local.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = var.skip_final_snapshot

  tags = {
    Project = var.project_name
  }
}

################################################################################
# RDS Subnet Group
################################################################################

locals {
  db_subnet_group_name = "${local.db_name}-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  name       = local.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Project = var.project_name
  }
}

################################################################################
# RDS Security Group
################################################################################

locals {
  db_security_group_name = "${local.db_name}-sg"
}

resource "aws_security_group" "this" {
  name        = local.db_security_group_name
  description = "Security Group for the ${var.project_name} Database"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_db_traffic" {
  security_group_id = aws_security_group.this.id
  description       = "Allow DB Traffic only from the web security group"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}
