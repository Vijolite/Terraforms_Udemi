variable "access_key" {}
variable "secret_key" {}

variable "region" {
  description = "Please Enter AWS region to deploy server"
  type        = string
  default     = "ca-central-1"
}

variable "users" {
  description = "List of IAM users to create"
  default     = ["Anna", "Maria", "Antony", "Jack", "Rimma", "Rosy"]
}
