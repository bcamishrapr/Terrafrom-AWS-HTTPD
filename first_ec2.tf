resource "aws_instance" "myec2" {
   ami = "ami-0bcf5425cdc1d8a85"
   instance_type = "t2.micro"
   security_groups = [ aws_security_group.security.name ]
   key_name = aws_key_pair.key.key_name
   tags = {
      Name = "Webserver"
  }
}



resource "null_resource" "command" {
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.privatekey.private_key_pem
    # priavte_key = file("\path")
    host = aws_instance.myec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/bcamishrapr/Static-webpage.git /var/www/html/",
    ]
}
}


resource "null_resource" "command3" {
   depends_on = [
      null_resource.command
  ]

  provisioner "local-exec" {
    command = "google-chrome http://${ aws_instance.myec2.public_ip } --no-sandbox"
}
}


output "myinstanceid"{
  value = aws_instance.myec2.id
}

output "myinstance_publicip"{
  value = aws_instance.myec2.public_ip
}
