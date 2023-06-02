variable "access_key" {}
variable "secret_key" {}

variable "region" {
  description = "Please Enter AWS region to deploy server"
  type        = string
  default     = "ca-central-1"
}

variable "instance_type" {
  description = "Please Enter instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ports" {
  description = "List of ports to open for server"
  type        = list(any)
  default     = ["80", "443", "22", "88"]
}

variable "enable_detailed_monitoring" {
  default = false
  type    = bool
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Ija S"
    Project     = "Udemi Course"
    Environment = "Development"
  }

}
