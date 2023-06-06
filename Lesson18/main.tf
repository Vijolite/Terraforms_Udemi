
#----------------------------------------------------------
# My Terraform
#
# Count and For if
#-----------------------------------------------------------

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_user" "user1" {
  name = "Shrek"
}

resource "aws_iam_user" "users" {
  count = length(var.users)
  name  = element(var.users, count.index) #element(list,index)
}

output "created_iam_users_all" {
  value = aws_iam_user.users
}

output "created_iam_users_all_ids" {
  value = aws_iam_user.users[*].id # for each user
}

output "created_iam_users_all_ids_and_arn" {
  value = [
    for u in aws_iam_user.users :
    "Hello Username: ${u.name} has ARN ${u.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for u in aws_iam_user.users :
    u.unique_id => u.id #"AIDAYIKASY5GOIKOGYMIS": "Rimma"
  }
}

output "custom_if_length_is_4_chars" {
  value = [
    for u in aws_iam_user.users :
    u.name
    if length(u.name) == 4
  ]
}
#-----------------------------------------------------------

data "aws_ami" "latest_linux" {
  owners      = ["137112412989"] //find ami for linux ec2, serch Images->Public Images and take info from there
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] //find ami for linux ec2, serch Images->Public Images and take info from there
  }
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.latest_linux.id
  count         = 3
  instance_type = "t3.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

output "server_all" {
  value = {
    for s in aws_instance.my_server :
    s.id => s.public_ip
  }
}
#-----------------------------------------------------------

