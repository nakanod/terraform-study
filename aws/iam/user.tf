data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user" "readonly-user" {
  name = "readonly-user"
}

resource "aws_iam_user_policy_attachment" "readonly-user-attach" {
  user       = aws_iam_user.readonly-user.name
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}
