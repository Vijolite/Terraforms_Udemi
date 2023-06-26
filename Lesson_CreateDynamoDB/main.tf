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
    type = "N"
  }
  attribute {
    name = "Name"
    type = "S"
  }

  global_secondary_index {
    name               = "VillaName-Index"
    hash_key           = "Name"
    read_capacity      = 1
    write_capacity     = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["Body", "CreatedDate", "UpdatedDate"]
  }

  tags = {
    Terraform = "true"
  }
}

resource "aws_dynamodb_table_item" "villa_item" {
  table_name = aws_dynamodb_table.villa_table.name
  hash_key   = aws_dynamodb_table.villa_table.hash_key
  item       = <<ITEM
  {
    "id": {"N": "1"},
    "Name": {"S": "Villa Nr1"},
    "Body": {"S": "{\"Details\":\"close to the sea\",\"Rate\":100,\"Sqft\":50,\"Occupancy\":4,\"ImageUrl\":\"https://www.shutterstock.com/image-photo/front-modern-villa-lawn-blue-260nw-472956442.jpg\",\"Amenity\":\"freezer\"}"},
    "CreatedDate": {"S": "2023/06/03"},
    "UpdatedDate": {"S": "2023/06/03"}
  }
  ITEM

}

resource "aws_dynamodb_table_item" "villa_item2" {
  table_name = aws_dynamodb_table.villa_table.name
  hash_key   = aws_dynamodb_table.villa_table.hash_key
  item       = <<ITEM
  {
    "id": {"N": "2"},
    "Name": {"S": "Villa Nr2"},
    "Body": {"S": "{\"Details\":\"close to shops\",\"Rate\":130.00,\"Sqrt\":40,\"Occupancy\":3,\"Amenity\":\"dish washer\", \"ImageUrl\":\"https://www.shutterstock.com/image-photo/front-modern-villa-lawn-blue-260nw-472956442.jpghttps://cdn.trendir.com/wp-content/uploads/old/house-design/small-villa-design-3.jpg\"}"},
    "CreatedDate": {"S": "2023/06/04"},
    "UpdatedDate": {"S": "2023/06/05"}
  }
  ITEM
}

resource "aws_dynamodb_table_item" "villa_item3" {
  table_name = aws_dynamodb_table.villa_table.name
  hash_key   = aws_dynamodb_table.villa_table.hash_key
  item       = <<ITEM
  {
    "id": {"N": "3"},
    "Name": {"S": "Villa Nr3"},
    "Body": {"S": "{\"Details\":\"inside a forest\",\"Rate\":110.00,\"Sqrt\":50,\"Occupancy\":4,\"ImageUrl\":\"https://www.contemporist.com/wp-content/uploads/2020/08/small-cabin-modern-wood-house-110820-1030-01-800x626.jpg\",\"Amenity\":\"outside light\"}"},
    "CreatedDate": {"S": "2023/06/04"},
    "UpdatedDate": {"S": "2023/06/06"}
  }
  ITEM
}

# resource "aws_dynamodb_table_item" "villa_item" {
#   table_name = aws_dynamodb_table.villa_table.name
#   hash_key   = aws_dynamodb_table.villa_table.hash_key

#   for_each = {
#     "1" = {
#       name = "Villa Nr1"
#       body         = "{\"Details\":\"close to shops\",\"Rate\":130.00,\"Sqrt\":40}"
#       created_date = "2023/06/03"
#       updated_date = "2023/06/03"
#     }
#     "2" = {
#       name         = "Villa Nr2"
#       body         = "bbb" //"{\"Details\":\"close to shops\",\"Rate\":130.00,\"Sqrt\":40,\"Occupancy\":3,\"ImageUrl\":\"https://www.shutterstock.com/image-photo/front-modern-villa-lawn-blue-260nw-472956442.jpghttps://cdn.trendir.com/wp-content/uploads/old/house-design/small-villa-design-3.jpg\",\"Amenity\":\"dish washer\"}"
#       created_date = "2023/06/05"
#       updated_date = "2023/06/09"
#     }
#   }

#   item = <<ITEM
#   {
#     "id": {"N": "${each.key}"},
#     "Name": {"S": "${each.value.name}"},
#     "Body": {"S": "${each.value.body}"},
#     "CreatedDate": {"S": "${each.value.created_date}"},
#     "UpdatedDate": {"S": "${each.value.updated_date}"}
#   }
#   ITEM
# }
