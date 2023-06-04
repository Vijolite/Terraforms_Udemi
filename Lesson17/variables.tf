variable "access_key" {}
variable "secret_key" {}

variable "region" {
  description = "Please Enter AWS region to deploy server"
  type        = string
  default     = "eu-central-1"
}

variable "env" {
  default = "prod"
}

variable "prod_owner" {
  default = "Ija S"
}

variable "noprod_owner" {
  default = "Vita"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t3.small"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev" = ["80", "443", "8080", "22"]
  }
}
