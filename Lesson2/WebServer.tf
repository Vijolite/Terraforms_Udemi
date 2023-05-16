#-----------------------------
# My Terraform
# Build WebServer during Bootstrap
#

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-03aefa83246f44ef2" # Amazon Linux AMI
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id] #attach security group to the server
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "WebServer Build by Terraform"
    Owner = "Ija S"
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
