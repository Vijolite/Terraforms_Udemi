
#----------------------------------------------------------
# My Terraform
#
# local commands local-exec
#-----------------------------------------------------------

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(Get-Date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
  depends_on = [null_resource.command1]
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print ('Hello World!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $name1 $name2 $name3 >> names.txt"
    environment = {
      name1 = "Anna"
      name2 = "peter"
      name3 = "John"
    }
  }
}

resource "null_resource" "command5" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(Get-Date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4]
}
