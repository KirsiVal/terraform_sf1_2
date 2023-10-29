
#provider

provider "aws" {
  region = "eu-north-1"
}

# EC2 Instance Configuration
resource "aws_instance" "my_instance" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet[0].id
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.my_web_security_group.id]
  user_data                   = file("script.sh")
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  tags = {
    Name = "web-instance"
  }
}
 provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",  # Make the script executable
      "sudo /tmp/script.sh",           # Execute the script
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"                 # Replace with the appropriate SSH user
    private_key = file("var.key_name")
  }
