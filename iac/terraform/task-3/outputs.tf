output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}


output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "role_name" {
  value = aws_iam_role.roles.name
}

output "role_arn" {
  value = aws_iam_role.roles.arn
}