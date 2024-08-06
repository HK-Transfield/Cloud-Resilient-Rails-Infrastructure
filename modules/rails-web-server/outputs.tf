output "public_dns" {
  value = aws_instance.webserver.public_dns
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
}

output "arn" {
  value = aws_instance.webserver.arn
}