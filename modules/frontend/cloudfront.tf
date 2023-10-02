/*
All the Configuration for CloudFront goes here
*/

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
