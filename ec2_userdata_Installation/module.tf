provider "aws" {
  region = "us-east-1"
}

module "ec2" {
    source = "./modules"
    type = "t2.large" #t2.large
}
