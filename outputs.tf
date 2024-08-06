output "fingerprint" {
  value = data.aws_key_pair.this.fingerprint
}

output "name" {
  value = data.aws_key_pair.this.key_name
}

output "id" {
  value = data.aws_key_pair.this.id
}