# terraform {
#   backend "remote" {
   
#     config = {
#       bucket = "pravgterraformstate"
#       key    = "terraform.tfstate"
#       region = "us-west-1"
#     }
#   }
# }

# data "aws_s3_bucket" "my_bucket" {
#   bucket = "pravgterraformstate"
#   region = "us-west-1"
#   key    = "terraform.tfstate"
#   backend = "s3"
# }


terraform {
  backend "s3" {
    bucket         = "pravgterraformstate"
    key            = "dynamodb.statetf"
    region         = "us-west-1"
    dynamodb_table = "pravterraforklocks"
  }
}
