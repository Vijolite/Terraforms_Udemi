#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
#----------------------------------------------------------
provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "new-bucket-ija"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#==================================================

output "company_name" {
  value = "Company XYZ"
}

output "owner" {
  value = "Ija S"
}

output "tags" {
  value = {
    Project    = "Proj XYZ"
    CostCenter = "CostCenter XYZ"
    Country    = "Canada"
  }
}
