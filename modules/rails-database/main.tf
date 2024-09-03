/**
Name: Ruby of Rails Database Infrastructure
Contributors: HK Transfield
*/

################################################################################
# RDS Instance
################################################################################
#TODO: https://medium.com/strategio/using-terraform-to-create-aws-vpc-ec2-and-rds-instances-c7f3aa416133
resource "aws_db_instance" "this" {
  identifier = "${var.name_prefix}-rds-instance"

  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_type      = var.rds_storage_type

  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  port                   = var.rds_port
  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  skip_final_snapshot = var.rds_skip_final_snapshot
  apply_immediately   = var.rds_apply_immediately

  tags = {
    Name = "${var.name_prefix}-rds"
  }
}

################################################################################
# RDS Subnet Group
################################################################################
locals {
  rds_subnet_group_name = "${var.name_prefix}-rds-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  name       = local.rds_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = local.rds_subnet_group_name
  }
}

################################################################################
# RDS Security Group
################################################################################
