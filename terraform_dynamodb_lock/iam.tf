terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
}

resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)
  name     = each.value
}

resource "aws_iam_access_key" "this" {
  for_each = aws_iam_user.users
  user     = each.value.name
  pgp_key  = var.pgp_key
}

resource "random_pet" "pet_name" {
  length    = 1
  separator = "-"
}

resource "aws_s3_bucket" "this_bucket" {
  bucket = "${random_pet.pet_name.id}-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

data "aws_iam_policy_document" "s3_policy" {
    statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:DeleteObject", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.this_bucket.arn]
    effect    = "Allow"
  }
  # statement {
  #   actions    = ["s3:ListAllMyBuckets"]
  #   resources = ["arn:aws:s3:::*"]
  #   effect    = "Allow"
  # }
}

resource "aws_iam_policy" "this_policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_group" "this" {
  name = "thisadmin"
}

resource "aws_iam_group_membership" "team" {
  name       = "tf-testing-group-membership"
  users      = var.user_names
  group      = aws_iam_group.this.name
  depends_on = [aws_iam_user.users]
}

resource "aws_iam_group_policy_attachment" "custom_policy" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this_policy.arn
}
output "rendered_policy" {
  value = data.aws_iam_policy_document.s3_policy.json
}



resource "aws_iam_user_login_profile" "u" {
  for_each = aws_iam_user.users
  user     = each.value.name
  pgp_key  = var.pgp_key
}


# output "password" {
#   value = {for k in aws_iam_user_login_profile.u[*]:}
 
# }