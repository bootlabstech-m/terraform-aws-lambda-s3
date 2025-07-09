# Lambda execution role resource
resource "aws_iam_role" "lambda_role" {
  name               = "${var.name}-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}

# Lambda execution role policy resource
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.name}-iam-policy"
  path        = var.iam_policy_path
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}

# Lambda execution role policy attachment resource
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Lambda archive_file resource
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

#  Lambda function resource
resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  memory_size   = var.memory_size
  timeout       = var.timeout
  lifecycle {
    ignore_changes = [tags]
  }
}

# Creating Lambda permission resource
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.s3bucket.id}"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "s3.amazonaws.com"

}


# Creating s3 resource for invoking to lambda function
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.s3name
  force_destroy = var.s3_force_destroy
  object_lock_enabled = var.s3_object_lock_enabled
  lifecycle {
    ignore_changes = [tags]
  }
}

# Creation bucket versioning resource
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3bucket.id
  versioning_configuration {
    status = var.s3_versioning_status
    mfa_delete = var.mfa_delete
  }
}

# Creating bucket public access disable resource
resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.s3bucket.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.s3bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_func.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]

  }
  depends_on = [
    aws_lambda_permission.apigw_lambda
  ]
}
