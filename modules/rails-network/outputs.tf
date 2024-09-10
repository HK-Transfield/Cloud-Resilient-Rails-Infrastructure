################################################################################
# VPC
################################################################################

output "vpc_id" {
  value = aws_vpc.this.id
}

################################################################################
# Public Subnets
################################################################################

output "web_a_subnet_id" {
  value = aws_subnet.web["A"].id
}

output "web_b_subnet_id" {
  value = aws_subnet.web["B"].id
}

################################################################################
# Private Subnets
################################################################################

output "app_a_subnet_id" {
  value = aws_subnet.app["A"].id
}

output "app_b_subnet_id" {
  value = aws_subnet.app["B"].id
}

output "db_a_subnet_id" {
  value = aws_subnet.db["A"].id
}

output "db_b_subnet_id" {
  value = aws_subnet.db["B"].id
}