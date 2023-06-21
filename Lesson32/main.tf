provider "aws" { // My Root Account
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" { // My DEV Account
  region     = "us-west-1"
  alias      = "dev"
  access_key = var.access_key
  secret_key = var.secret_key
  /*
  assume_role {
    role_arn = "arn:aws:iam::639130796919:role/TerraformRole"
  }
  */
}

provider "aws" { // My PROD Account
  region     = "ca-central-1"
  alias      = "prod"
  access_key = var.access_key
  secret_key = var.secret_key
  /*
  assume_role {
    role_arn = "arn:aws:iam::032823347814:role/TerraformRole"
  }
  */
}
#--------------------------------------------------------------

module "servers" {
  source        = "./modules"
  instance_type = "t3.small"
  providers = { #to use providers inside module: value in module = value from program
    aws.root = aws
    aws.prod = aws.prod
    aws.dev  = aws.dev
  }
}
