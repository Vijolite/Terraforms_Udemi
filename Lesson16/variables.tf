variable "access_key" {}
variable "secret_key" {}

variable "region" {
  description = "Please Enter AWS region to deploy server"
  type        = string
  default     = "ca-central-1"
}
