# Resources will go here

resource "aws_s3_bucket" "jchung_s3_bucket" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_ownership_controls" "jchung_s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "jchung_s3_bucket_bucket_public_access_block" {
  bucket = aws_s3_bucket.jchung_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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
            "Action": ["s3:GetObject"],
            "Resource": ["arn:aws:s3:::tf-aws-jchung-cloud-resume-challenge-bucket/*"]
        }
    ]
}
EOF
}


resource "aws_s3_object" "static_s3_object" {
  bucket       = aws_s3_bucket.jchung_s3_bucket.id
  for_each     = fileset(".", "*")
  key          = each.value
  source       = "${each.value}"
  content_type = "text/html"
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