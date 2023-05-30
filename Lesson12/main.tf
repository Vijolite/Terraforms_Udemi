
#----------------------------------------------------------
# My Terraform
#
# Variables
#-----------------------------------------------------------

provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

data "aws_ami" "latest_linux" {
  owners      = ["137112412989"] //find ami for linux ec2, serch Images->Public Images and take info from there
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] //find ami for linux ec2, serch Images->Public Images and take info from there
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  # tags = {
  #   Name   = "Server IP"
  #   Region = var.region
  #   Owner  = "Ija S"
  # }
  //tags = var.common_tags
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP", Region = var.region })
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  monitoring             = var.enable_detailed_monitoring //to monitor additional info - additional costs
  # tags = {
  #   Name   = "Server"
  #   Region = var.region
  #   Owner  = "Ija S"
  # }
  //tags = var.common_tags
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server", Region = var.region })
}

resource "aws_security_group" "my_webserver" {
  name   = "Dynamic Security Group"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ports
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

  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Security Groups", Region = var.region })
}

