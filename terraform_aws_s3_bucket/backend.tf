terraform {
  backend "s3" {
    bucket         = "pravgterraformstate"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    }
}
