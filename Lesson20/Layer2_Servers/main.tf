provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

/*
terraform {
  backend "s3" {
    bucket = "new-bucket-ija"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}
*/
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
/*
resource "aws_security_group" "my_webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

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
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
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
*/
output "network-details" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
