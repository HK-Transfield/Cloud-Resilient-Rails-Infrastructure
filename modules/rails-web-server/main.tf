resource "aws_instance" "webserver" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-development-environment.html
  # https://rvm.io/
  # https://www.ruby-lang.org/en/documentation/installation/
  provisioner "remote-exec" {
    inline = [
      # Install dependencies to run Rails
      "sudo yum install ruby",
      "ruby --version",
      "sudo yum install sqlite3",
      "sqlite3 --version",
      "gem install rails",
      "rails --version",

      # Create Rails server
      "rails new webapp",
      "cd webapp",
      "bin/rails server"
    ]
  }

  tags = {
    Name = "rails-web-server"
  }
}
