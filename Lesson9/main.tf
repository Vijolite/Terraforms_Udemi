
provider "aws" {
  region     = "eu-central-1"
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current_region" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "my_vpc" {
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.1.0/24" //this does not work, should be replaced
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current_region.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.2.0/24" //this does not work, should be replaced
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current_region.description
  }
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current_region.name
}

output "data_aws_region_description" {
  value = data.aws_region.current_region.description
}

output "data_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "prod_vpc_id" {
  value = data.aws_vpc.my_vpc.id
}
