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

# no public buckets will be un-ignored for cloudfront
#tfsec:ignore:no-public-buckets
resource "aws_s3_bucket_public_access_block" "jchung_s3_bucket_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.jchung_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "jchung_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "jchung_s3_bucket_policy" {
  depends_on = [
    aws_s3_bucket_ownership_controls.jchung_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.jchung_s3_bucket_bucket_public_access_block,
  ]
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::tf-aws-jchung-cloud-resume-site-bucket/*"
        }
    ]
}
EOF
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "jchung_logging_bucket" {
  bucket = var.logging_bucket_name
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

resource "aws_s3_bucket_public_access_block" "jchung_logging_bucket_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.jchung_logging_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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