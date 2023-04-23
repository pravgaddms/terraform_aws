resource "aws_iam_user" "user" {
  name = "devops"
  path = "/system/"

  tags = {
    team = "devops"
  }
}

resource "aws_iam_access_key" "key" {
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
}

resource "aws_iam_group" "group" {
  name = "DevopsAdmin"
}

resource "random_pet" "s3_name" {
  length    = 2
  separator = "-"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_pet.s3_name.id}-bucket"
  tags = {
    environment = "devops"
    name        = "My-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [ aws_s3_bucket_ownership_controls.ownership ]
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}