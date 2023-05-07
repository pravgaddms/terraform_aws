output "private_key" {
  value = tls_private_key.pk.public_key_openssh
  sensitive = true
}

output "public_ip" {
  value = aws_instance.web.public_ip
}