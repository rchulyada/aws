# local value to reuse in here
locals {
  s3_origin_id = "test123.myapp"
}

# cloudfront distrubution configurations
resource "aws_cloudfront_distribution" "test123_s3_distribution" {
  enabled = true
  is_ipv6_enabled = true
  comment = "test123_cloudfront"
  default_root_object = "index.html"
  tags = {
    Environment = var.tag_environment
    Name = var.tag_name
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  origin {
    domain_name = aws_s3_bucket.test123_s3.bucket_regional_domain_name
    origin_id = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

# to get the Cloud front URL if doamin/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.test123_s3_distribution.domain_name
}