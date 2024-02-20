variable "bucket_name" {
  default = "tf-aws-jchung-cloud-resume-site-bucket"
}

variable "logging_bucket_name" {
  default = "tf-aws-jchung-cloud-resume-logging-bucket"
}

variable "region" {
  default = "ap-southeast-2"
}

variable "route53_domain_name" {
  default = "jchung-resume.com"
}

data "aws_route53_zone" "route53_zone" {
  name = var.route53_domain_name
}

locals {
  css_files      = flatten([for d in flatten(fileset("${path.root}/css", "*")) : trim(d, "../")])
  images_files   = flatten([for d in flatten(fileset("${path.root}/images", "*")) : trim(d, "../")])
  js_files       = flatten([for d in flatten(fileset("${path.root}/js", "*")) : trim(d, "../")])
  sass_files     = flatten([for d in flatten(fileset("${path.root}/sass", "*")) : trim(d, "../")])
  sections_files = flatten([for d in flatten(fileset("${path.root}/sections/blog", "*")) : trim(d, "../")])
  webfonts_files = flatten([for d in flatten(fileset("${path.root}/webfonts", "*")) : trim(d, "../")])
}
