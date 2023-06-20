provider "aws" {
  region     = "eu-north-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
/*
module "vpc-default" { #module's variables used with their default values
  source = "../modules/aws_network"
}
*/
module "vpc-dev" {
  source               = "../modules/aws_network" #source can be also for example from github "git@github.com:...//..."
  env                  = "development"            #can assign different values to module's variables
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}

module "vpc-prod" {
  source               = "../modules/aws_network"
  env                  = "production" #can assign different values to module's variables
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

module "vpc-test" {
  source               = "../modules/aws_network"
  env                  = "staging" #can assign different values to module's variables
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24"]
}

output "prod_public_subnets_ids" {
  value = module.vpc-prod.public_subnet_ids #can select outputs only from module's outputs
}

output "prod_private_subnets_ids" {
  value = module.vpc-prod.private_subnet_ids #can select outputs only from module's outputs
}

output "development_public_subnets_ids" {
  value = module.vpc-dev.public_subnet_ids #can select outputs only from module's outputs
}

output "development_private_subnets_ids" {
  value = module.vpc-dev.private_subnet_ids #can select outputs only from module's outputs
}
