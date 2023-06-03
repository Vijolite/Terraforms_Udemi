
#----------------------------------------------------------
# My Terraform
#
# passwords (password is visible in file terraform.tfstate)
#-----------------------------------------------------------

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "name" {
  default = "Anna"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&" #what special simbols we are ok to use
  keepers = {               #value of password will be changed is name changes
    keeper1 = var.name
    //keeper2 = var.something
  }
}

resource "aws_ssm_parameter" "rds_password" { #find in aws Parameter Store
  name        = "/prod/mysql"
  description = "Master password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "default" { #find in aws RDS
  identifier        = "prod-rds"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  //name                 = "prod"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

output "rds_password" {
  value     = data.aws_ssm_parameter.my_rds_password.value
  sensitive = true
}
