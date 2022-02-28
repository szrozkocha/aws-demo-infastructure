resource "aws_cloudfront_distribution" "main_cloudfront" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_domain_name
    origin_id   = var.frontend_bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main_cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.domain_cert_validation.certificate_arn
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code    = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code    = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  # Route53 requires Alias/CNAME to be setup
  aliases = [var.hosted_zone]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.frontend_bucket

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = var.cache_default_ttl
    max_ttl                = var.cache_max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.common_tags
}

resource "aws_cloudfront_origin_access_identity" "main_cloudfront_origin_access_identity" {
  comment = "Origin Access Identity for S3"
}