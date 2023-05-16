provider "aws" {
  region     = "eu-central-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "my_webserver" {
  name = "WebServer Security Group"
  description "My firrst security group"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_instance" "my_resource" {
  ami           = "ami-06f81ab85dd2fa968"
  instance_type = "t3.micro"
  tags = {
    Name    = "My Win server"
    Owner   = "Ija S"
    Project = "Terraform lessons"
  }
}

resource "aws_instance" "my_amazon_linux" {
  ami           = "ami-03aefa83246f44ef2"
  instance_type = "t3.small"
  tags = {
    Name    = "My amazon server"
    Owner   = "Ija S"
    Project = "Terraform lessons"
  }
}
