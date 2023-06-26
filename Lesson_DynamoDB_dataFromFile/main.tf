provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_dynamodb_table" "villa_table" {
  name           = "Villas_terraform"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "villa_item" {
  for_each   = local.tf_data
  table_name = aws_dynamodb_table.villa_table.name
  hash_key   = aws_dynamodb_table.villa_table.hash_key
  item       = jsonencode(each.value)
}
