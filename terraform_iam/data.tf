data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "policy" {
    name = "${random_pet.s3_name.id}-policy"
    description = "s3 bucket policy"
    policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_group_policy_attachment" "attach" {
group    = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "team" {
  name = "devops-membership"
  users = [
    aws_iam_user.user.name,
  ]
  group = aws_iam_group.group.name
}