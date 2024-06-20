# RSA key of size 4096 bits
resource "tls_private_key" "prv-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key-name" {
  content  = tls_private_key.prv-keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}

resource "aws_key_pair" "pub-keypair" {
  key_name   = "keypair"
  public_key = tls_private_key.prv-keypair.public_key_openssh
}

