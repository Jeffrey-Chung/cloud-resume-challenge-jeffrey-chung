variable "bucket_name" {
  default = "tf-aws-jchung-cloud-resume-site-bucket"
}

variable "logging_bucket_name" {
  default = "tf-aws-jchung-cloud-resume-logging-bucket"
}

variable "region" {
  default = "ap-southeast-2"
}

locals {
  css_files      = flatten([for d in flatten(fileset("${path.module}/css", "*")) : trim(d, "../")])
  images_files   = flatten([for d in flatten(fileset("${path.module}/images", "*")) : trim(d, "../")])
  js_files       = flatten([for d in flatten(fileset("${path.module}/js", "*")) : trim(d, "../")])
  sass_files     = flatten([for d in flatten(fileset("${path.module}/sass", "*")) : trim(d, "../")])
  sections_files = flatten([for d in flatten(fileset("${path.module}/sections/blog", "*")) : trim(d, "../")])
  webfonts_files = flatten([for d in flatten(fileset("${path.module}/webfonts", "*")) : trim(d, "../")])
}
