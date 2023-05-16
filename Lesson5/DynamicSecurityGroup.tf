#-----------------------------
# My Terraform
# Build WebServer during Bootstrap
#

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first security group"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress { #output
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic Security Groups"
    Owner = "Ija S"
  }

}
