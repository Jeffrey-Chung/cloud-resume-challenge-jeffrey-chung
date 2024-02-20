provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_acm_certificate" "acm_cert" {
  provider = aws.virginia

  domain_name       = data.aws_route53_zone.route53_zone.name
  validation_method = "DNS"

  subject_alternative_names = ["*.${data.aws_route53_zone.route53_zone.name}"]

  key_algorithm = "RSA_2048"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "r53_record" {
  for_each = {
    for entry in aws_acm_certificate.acm_cert.domain_validation_options : entry.domain_name => {
      name   = entry.resource_record_name
      record = entry.resource_record_value
      type   = entry.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}