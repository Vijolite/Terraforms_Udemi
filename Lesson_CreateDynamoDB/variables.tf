variable "access_key" {}
variable "secret_key" {}

/* variable "body1" {
  default = {
    "Details" : "close to the sea",
    "Rate" : "100",
    "Sqft" : "50",
    "Occupancy" : "4",
    "ImageUrl" : "https://www.shutterstock.com/image-photo/front-modern-villa-lawn-blue-260nw-472956442.jpg",
    "Amenity" : "freezer"
  }
} */

# variable "body1" {
#   default = jsoncode({
#     "Details" : "close to the sea",
#     "Rate" : "100",
#     "Sqft" : "50",
#     "Occupancy" : "4",
#     "ImageUrl" : "https://www.shutterstock.com/image-photo/front-modern-villa-lawn-blue-260nw-472956442.jpg",
#     "Amenity" : "freezer"
#   })
# }
