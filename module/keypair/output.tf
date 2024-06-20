output "prv-keypair" {
    value = tls_private_key.prv-keypair.private_key_pem
}

output "key-id" {
    value = aws_key_pair.pub-keypair.id
}