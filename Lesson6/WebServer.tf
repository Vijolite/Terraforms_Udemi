#-----------------------------
# My Terraform
# Build WebServer during Bootstrap
#

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-03a71cec707bfc3d7" # Amazon Linux AMI
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id] #attach security group to the server
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Ija",
    l_name = "S",
    names  = ["Anna", "Peter", "John", "Mary", "Test", "Katy"]
  })

  tags = {
    Name  = "WebServer Build by Terraform"
    Owner = "Ija S"
  }

  lifecycle {
    #prevent_destroy = true #does not allow to destroy
    #ignore_changes = ["ami", "user_data"] #ignore changes in categories
    create_before_destroy = true
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My first security group"
  vpc_id      = aws_default_vpc.default.id

  ingress { #input
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #input
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #output
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer Build by Terraform"
    Owner = "Ija S"
  }

}


