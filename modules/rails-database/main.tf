/**
Name: Ruby of Rails Database Infrastructure
Contributors: HK Transfield
*/

################################################################################
# RDS Instance
################################################################################
locals {
  db_name = "${var.name_prefix}-rds-instance"
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
    Name    = "${var.name_prefix}-rds"
    project = var.name_prefix
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
