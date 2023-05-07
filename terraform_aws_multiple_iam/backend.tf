# terraform {
#   backend "s3" {
#     bucket         = "pravterraformstate"
#     key            = "terraform.tfstate"
#     region         = "us-west-1"
#     dynamodb_table = "pravterraforklocks"
#   }
# }
