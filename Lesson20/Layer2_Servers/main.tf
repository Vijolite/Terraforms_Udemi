provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "new-bucket-ija"
    key    = "dev/servsrs/terraform.tfstate" //save in s3 bucket different! file
    region = "us-east-1"
  }
}

#-----------------------------------------------------------

data "terraform_remote_state" "network" { //from where take remote data
  backend = "s3"
  config = {
    bucket     = "new-bucket-ija"
    key        = "dev/network/terraform.tfstate"
    region     = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#-----------------------------------------------------------

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with Remote State"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "my_webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id //using of remote data

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr] //using of remote data
  }

  egress { #output
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "web-server-sg"
    Owner = "Ija S"
  }
}

output "webserver-sg-id" { //to use remotely
  value = aws_security_group.my_webserver.id
}

output "webserver-public-ip" { //to use remotely
  value = aws_instance.web_server.public_ip
}
