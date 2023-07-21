# Resources will go here

#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:encryption-customer-key
resource "aws_s3_bucket" "jchung_s3_bucket" {
  bucket = var.bucket_name

  logging {
    target_bucket = aws_s3_bucket.jchung_logging_bucket.id
  }
}

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
  acl    = "public-read"
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
#tfsec:ignore:encryption-customer-key
resource "aws_s3_bucket" "jchung_logging_bucket" {
  bucket = var.logging_bucket_name

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "jchung_logging_server_side_encryption" {
  bucket = aws_s3_bucket.jchung_logging_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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