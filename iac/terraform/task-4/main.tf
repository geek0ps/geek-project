resource "aws_iam_role_policy_attachment" "lambda_s3_policy" {
  role       = var.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       =  var.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# package the lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code" 
  output_path = "${path.module}/lambda_packaged_code.zip"
}

# Lambda Function to move files within the S3 bucket
resource "aws_lambda_function" "s3_lambda" {
  function_name = "s3_upload_mover"
  filename      = data.archive_file.lambda_zip.output_path
  role          = var.role_arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 10
}

# Add S3 event trigger for Lambda on upload to "uploads/" dirctory
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.allow_s3_lambda]
}

# Lambda permission to allow invocation by S3
resource "aws_lambda_permission" "allow_s3_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

