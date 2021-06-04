resource "tls_private_key" "privatekey" {
   algorithm = "RSA"
   rsa_bits = "4096"
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.privatekey.public_key_openssh
}

output "mykey"{
  value = aws_key_pair.key.key_pair_id
}

###This is used to store private key in a file
/*resource "local_file" "private_key" {
    content  = aws_key_pair.key.key_pair_id
    filename = "private_key.pem"
}*/
