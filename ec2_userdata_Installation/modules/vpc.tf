module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "prav-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Owning = "Managed by Terraform"
    Environment = "dev"
  }
}