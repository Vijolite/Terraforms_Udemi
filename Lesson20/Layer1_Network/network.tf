
#----------------------------------------------------------
# My Terraform
#
# Terraform Remote State
#
# to set up backend credentials:
# terraform init -backend-config="access_key=<...>" -backend-config="secret_key=<...>"
#-----------------------------------------------------------

provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "new-bucket-ija"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

#-----------------------------------------------------------

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

#-----------------------------------------------------------

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

