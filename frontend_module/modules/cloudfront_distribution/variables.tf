# modules/cloudfront_distribution/variables.tf
variable "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "The unique identifier for the origin"
  type        = string
}

variable "origin_path" {
  description = "The path to the content in the S3 bucket"
  type        = string
}

variable "default_root_object" {
  description = "The default root object for the CloudFront distribution"
  type        = string
}

variable "aliases" {
  description = "List of aliases (domain names) for the CloudFront distribution"
  type        = list(string)
}

variable "oai_path" {
  description = "The CloudFront Origin Access Identity path"
  type        = string
}