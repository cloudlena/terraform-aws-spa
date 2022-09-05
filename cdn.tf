resource "aws_cloudfront_distribution" "main" {
  comment = "The ${aws_s3_bucket.website.bucket} website"

  origin {
    origin_id                = "S3-${aws_s3_bucket.website.bucket}"
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  aliases = [aws_s3_bucket.website.bucket]

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
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" // CachingOptimized
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern               = "index.html"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = "S3-${aws_s3_bucket.website.bucket}"
    cache_policy_id            = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // CachingDisabled
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" // SecurityHeadersPolicy
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

resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.service_name}${var.resource_suffix}"
  description                       = "The policy for the ${aws_s3_bucket.website.bucket} origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
