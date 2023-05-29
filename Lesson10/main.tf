
#----------------------------------------------------------
# My Terraform
# green-blue deployment
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#-----------------------------------------------------------

provider "aws" {
  region     = "ca-central-1"
}

data data_aws_availability_zones "available" {}


data "aws_ami" "latest_linux" {
  owners      = ["137112412989"] //find ami for linux ec2, serch Images->Public Images and take info from there
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230503.0-kernel-*"] //find ami for linux ec2, serch Images->Public Images and take info from there
  }
}

output "latest_linux_ami_id" {
  value = data.aws_ami.latest_linux.id
}

output "latest_linux_ami_name" {
  value = data.aws_ami.latest_linux.name
}

data "aws_ami" "latest_win" {
  owners      = ["801119661308"] //find ami for windows ec2, serch Images->Public Images and take info from there
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"] //find ami for windows ec2, serch Images->Public Images and take info from there
  }
}

output "latest_win_ami_id" {
  value = data.aws_ami.latest_win.id
}

output "latest_win_ami_name" {
  value = data.aws_ami.latest_win.name
}
