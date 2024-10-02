
resource "aws_s3_bucket" "this" {
  bucket   = "${var.prefix}-bucket"
}

resource "aws_s3_bucket_object" "uploads_dir" {
  bucket = aws_s3_bucket.this.id
  key    = "uploads/"  # Creates a 'folder' by adding a trailing slash in S3
}

resource "aws_s3_bucket_object" "processed_dir" {
  bucket = aws_s3_bucket.this.id
  key    = "processed/"  # Creates a 'folder' by adding a trailing slash in S3
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket   = aws_s3_bucket.this.id

  rule {
    id = "delete-old-files-${var.prefix}"
    expiration {
      days = 7
    }
    status = "Enabled"
  }
}

resource "aws_iam_policy" "s3_policies" {

  name        = "${var.prefix}-s3-policy"
  description = "Policy to allow push/delete access to S3 bucket ${var.prefix}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:DeleteObject"],
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}

resource "aws_iam_group" "groups" {
  name     = "${var.prefix}-group"
}

resource "aws_iam_group_policy_attachment" "group_policy_attachments" {
  group      = aws_iam_group.groups.name
  policy_arn = aws_iam_policy.s3_policies.arn
}

resource "aws_iam_user" "users" {
  name     = "${var.prefix}-user"
}

resource "aws_iam_group_membership" "group_memberships" {
  name  = "user-group-membership-${var.prefix}"
  users = [aws_iam_user.users.name]
  group = aws_iam_group.groups.name
}

resource "aws_iam_role" "roles" {

  name = "${var.prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "role_policies" {

  role = aws_iam_role.roles.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:DeleteObject"],
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
