/*
All the Configuration for Lambda goes here, the Lambda function is created in the lambda_src folder
*/

resource "aws_iam_role" "jchung_lambda_role" {
  name               = "jchung_lambda_role"
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
}

#tfsec:ignore:no-policy-wildcards
resource "aws_iam_policy" "jchung_lambda_iam_policy" {
  name   = "aws_iam_policy_for_terraform_aws_lambda_role"
  path   = "/"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
			"Effect": "Allow",
			"Action": [
				"dynamodb:BatchGetItem",
				"dynamodb:GetItem",
				"dynamodb:Query",
				"dynamodb:Scan",
				"dynamodb:BatchWriteItem",
				"dynamodb:PutItem",
				"dynamodb:UpdateItem"
			],
			"Resource": "arn:aws:dynamodb:ap-southeast-2:663790350014:table/jchung_dynamodb_table"
	 },
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:ap-southeast-2:663790350014:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.jchung_lambda_role.name
  policy_arn = aws_iam_policy.jchung_lambda_iam_policy.arn
}

data "archive_file" "lambda_source_code" {
  type        = "zip"
  source_dir  = "${path.root}/lambda_src/"
  output_path = "${path.root}/lambda_src/lambda_src.zip"
}

resource "aws_lambda_function" "jchung_lambda_function" {
  filename      = "${path.root}/lambda_src/lambda_src.zip"
  function_name = "jchung_lambda_api"
  role          = aws_iam_role.jchung_lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.10"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.jchung_lambda_function.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
  }
}

output "LAMBDA_URL" {
  description = "Lambda Function URL to be added to frontend"
  value       = aws_lambda_function_url.lambda_function_url.function_url
}
