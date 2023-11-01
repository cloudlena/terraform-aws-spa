resource "aws_cloudfront_distribution" "main" {
  comment = "The ${aws_s3_bucket.website.bucket} website"

  origin {
    origin_id                = "S3-${aws_s3_bucket.website.bucket}"
    domain_name              = aws_s3_bucket_website_configuration.website.website_endpoint
    custom_origin_config {
      http_port  = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  aliases = concat([aws_s3_bucket.website.bucket], local.aliases)

  enabled             = true
  price_class         = "PriceClass_100"
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  default_root_object = "index.html"

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.website.bucket}"
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern               = "*.html"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = "S3-${aws_s3_bucket.website.bucket}"
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_disabled.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
    viewer_protocol_policy     = "redirect-to-https"
    compress                   = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.main.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    service-name = var.service_name
    environment  = var.environment
  }
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "Managed-SecurityHeadersPolicy"
}
