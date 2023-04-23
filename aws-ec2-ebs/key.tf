resource "aws_key_pair" "deployer" {
  key_name   = "aws_ebs"
  public_key = file("mykey.pub")
}