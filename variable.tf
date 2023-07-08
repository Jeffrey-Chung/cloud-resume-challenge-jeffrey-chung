variable "bucket_name" {
  default = "tf-aws-jchung-cloud-resume-challenge-bucket"
}

variable "region" {
  default = "ap-southeast-2"
}

locals{
  css_files = flatten([for d in flatten(fileset("${path.module}/css", "*")) : trim( d, "../") ])
}
