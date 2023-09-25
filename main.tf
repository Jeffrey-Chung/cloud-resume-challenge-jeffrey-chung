# Resources will go here

#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "jchung_s3_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_logging" "jchung_s3_logging" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id

  target_bucket = aws_s3_bucket.jchung_logging_bucket.id
  target_prefix = "log/"
}

#tfsec:ignore:encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "jchung_s3_server_side_encryption" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "jchung_s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "jchung_s3_bucket_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.jchung_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "jchung_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  acl    = "private"
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "jchung_logging_bucket" {
  bucket        = var.logging_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "jchung_logging_bucket_versioning" {
  bucket = aws_s3_bucket.jchung_logging_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#tfsec:ignore:encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "jchung_logging_server_side_encryption" {
  bucket = aws_s3_bucket.jchung_logging_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "jchung_log_bucket_ownership_controls" {
  bucket = aws_s3_bucket.jchung_logging_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "jchung_logging_bucket_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.jchung_logging_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "jchung_log_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_log_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_logging_bucket_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.jchung_logging_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_object" "html_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}
resource "aws_s3_object" "error_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/error.html")
}
resource "aws_s3_object" "css_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each     = { for idx, file in local.css_files : idx => file }
  key          = "/css/${each.value}"
  source       = "${path.module}/css/${each.value}"
  content_type = "text/css"
  etag         = filemd5("${path.module}/css/${each.value}")
}
resource "aws_s3_object" "js_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each     = { for idx, file in local.js_files : idx => file }
  key          = "/js/${each.value}"
  source       = "${path.module}/js/${each.value}"
  content_type = "text/javascript"
  etag         = filemd5("${path.module}/js/${each.value}")
}
resource "aws_s3_object" "images_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each     = { for idx, file in local.images_files : idx => file }
  key          = "/images/${each.value}"
  source       = "${path.module}/images/${each.value}"
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/${each.value}")
}
resource "aws_s3_object" "sass_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each = { for idx, file in local.sass_files : idx => file }
  key      = "/sass/${each.value}"
  source   = "${path.module}/sass/${each.value}"
  etag     = filemd5("${path.module}/sass/${each.value}")
}
resource "aws_s3_object" "sections_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each = { for idx, file in local.sections_files : idx => file }
  key      = "/sections/${each.value}"
  source   = "${path.module}/sections/${each.value}"
  etag     = filemd5("${path.module}/sections/${each.value}")
}
resource "aws_s3_object" "webfonts_s3_object" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  for_each = { for idx, file in local.webfonts_files : idx => file }
  key      = "/webfonts/${each.value}"
  source   = "${path.module}/webfonts/${each.value}"
  etag     = filemd5("${path.module}/webfonts/${each.value}")
}
resource "aws_s3_bucket_website_configuration" "jchung_s3_bucket_website_config" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = aws_s3_bucket.jchung_s3_bucket.bucket_regional_domain_name
}

# no need to enable security encryption (WAF) to host this static website since no sensitive information is in the site and would incur
# additional cost without much gain. 
# Using default cloudfront certificate for now, may change later in development
#tfsec:ignore:enable-waf
#tfsec:ignore:use-secure-tls-policy
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.jchung_s3_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.jchung_s3_bucket.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "jchung-cloud-resume-challenge"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.jchung_logging_bucket.bucket_regional_domain_name
    prefix          = "cloud-resume-cf-logs"
  }

  default_cache_behavior {
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.jchung_s3_bucket.bucket_regional_domain_name

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "jchung_s3_bucket_policy" {
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  policy = data.aws_iam_policy_document.jchung_cloudfront_policy.json
}

data "aws_iam_policy_document" "jchung_cloudfront_policy" {
  statement {
    sid = "1"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.jchung_s3_bucket.arn}/*"
    ]
  }
}

#tfsec:ignore:table-customer-key
resource "aws_dynamodb_table" "jchung_dynamodb_table" {
  name           = "jchung_dynamodb_table"
  hash_key       = "count_id"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "count_id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table_item" "dynamodb_items" {
  table_name = aws_dynamodb_table.jchung_dynamodb_table.name
  hash_key   = aws_dynamodb_table.jchung_dynamodb_table.hash_key

  item = <<ITEM
{
  "count_id": {"S": "0"},
  "count_num": {"N": "0"}
}
ITEM
}

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
  source_dir  = "${path.module}/lambda_src/"
  output_path = "${path.module}/lambda_src/lambda_src.zip"
}

resource "aws_lambda_function" "jchung_lambda_function" {
  filename      = "${path.module}/lambda_src/lambda_src.zip"
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
  description = "Lambda Function URL to be added to main.js"
  value       = aws_lambda_function_url.lambda_function_url.function_url
}
