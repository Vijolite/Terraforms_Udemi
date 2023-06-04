
#----------------------------------------------------------
# My Terraform
#
# Conditions and Lookups
#-----------------------------------------------------------

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "my_webserver1" {
  ami = "ami-03a71cec707bfc3d7"
  //instance_type = (var.env == "prod" ? "t2.large" : "t2.micro")
  instance_type = (var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"])
  tags = {
    Name  = "${var.env}-server"
    Owner = (var.env == "prod" ? var.prod_owner : var.noprod_owner)
  }
}

resource "aws_instance" "my_webserver2" {
  ami           = "ami-03a71cec707bfc3d7"
  instance_type = lookup(var.ec2_size, var.env)
  tags = {
    Name  = "${var.env}-server"
    Owner = (var.env == "prod" ? var.prod_owner : var.noprod_owner)
  }
}

resource "aws_instance" "my_dev" {
  ami           = "ami-03a71cec707bfc3d7"
  count         = (var.env == "dev" ? 1 : 0) #this should be created only at dev environment
  instance_type = "t2.micro"
  tags = {
    Name  = "Dev-Server-additional"
    Owner = var.noprod_owner
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first security group"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
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

