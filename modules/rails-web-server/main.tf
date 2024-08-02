resource "aws_instance" "webserver" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = var.script_filename
    destination = var.script_filename
  }

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-development-environment.html
  # https://rvm.io/
  # https://www.ruby-lang.org/en/documentation/installation/
  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.script_filename}",
      "./${var.script_filename}"
    ]
  }

  tags = {
    Name = "${var.name_prefix}-web-server"
  }
}
