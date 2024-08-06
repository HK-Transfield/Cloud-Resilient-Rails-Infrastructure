/**
Name: Ruby of Rails EC2 Instance
Contributors: HK Transfield
*/

resource "aws_instance" "webserver" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "${var.name_prefix}-web-server"
  }

  user_data = file("${path.module}/script.sh")
}
