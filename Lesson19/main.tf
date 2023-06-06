
#----------------------------------------------------------
# My Terraform
#
# Resources in multiple AWS Regions/Accounts
#-----------------------------------------------------------

provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  region     = "us-east-1"
  alias      = "USA"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  region     = "eu-central-1"
  alias      = "EU"
  access_key = var.access_key
  secret_key = var.secret_key
  # assume_role = { #using role for reaching another account (if there is this role created)
  #   role_arn = "arn:aws:iam:1234567890:role/RemoteAdministrators"
  #   session_name = "TERRAFORM_SESSION"
  # }
}

#-----------------------------------------------------------
data "aws_ami" "defaut_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.EU
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
#-----------------------------------------------------------

resource "aws_instance" "my_default_server" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.defaut_latest_ubuntu.id
  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "my_usa_server" {
  provider      = aws.USA
  instance_type = "t3.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  tags = {
    Name = "USA Server"
  }
}

resource "aws_instance" "my_eu_server" {
  provider      = aws.EU
  instance_type = "t3.micro"
  ami           = data.aws_ami.ger_latest_ubuntu.id
  tags = {
    Name = "EU Server"
  }
}
