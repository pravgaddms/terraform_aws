resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.pk.public_key_openssh
  }


# resource "local_sensitive_file" "pem_file" {
#   filename = ${"./myKey.pem")
#   file_permission = "600"
#   directory_permission = "700"
#   content = tls_private_key.ssh.private_key_pem
# }


resource "aws_secretsmanager_secret" "secretmasterDB" {
   name = "ec2-key"
}

# Creating a AWS secret versions for database master account (Masteraccoundb)

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "private_key": "${tls_private_key.pk.private_key_pem}"
    "public_key": "${tls_private_key.pk.public_key_openssh}"
   }
EOF
}

