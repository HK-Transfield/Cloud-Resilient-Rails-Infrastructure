output "vpc_id" {
  value = aws_vpc.this.id
}

output "web_a_subnet_id" {
  value = aws_subnet.web["A"].id
}

output "web_b_subnet_id" {
  value = aws_subnet.web["B"].id
}

