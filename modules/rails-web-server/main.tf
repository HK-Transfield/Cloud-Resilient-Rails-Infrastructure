/**
Name: Ruby of Rails EC2 Instance
Contributors: HK Transfield
*/

locals {
  filename = "install_rails.sh"
  filepath = "${path.module}/scripts/${local.filename}"
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = local.filename
    content_type = "text/x-shellscript"

    content = file(local.filepath)
  }
}

#TODO: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
#todo: https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config
resource "aws_instance" "webserver" {
  ami             = "ami-0a0e5d9c7acc336f1"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = ["launch-wizard-1"]

  tags = {
    Name = "${var.name_prefix}-web-server"
  }

  user_data = data.cloudinit_config.user_data.rendered
}
