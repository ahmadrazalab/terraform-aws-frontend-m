# modules/cloudfront_distribution/main.tf
resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = var.oai_path
    }
    origin_path = var.origin_path
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for ${var.origin_id}"
  default_root_object = var.default_root_object

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = "Production"
  }
}