# CloudFront certificates must be in us-east-1
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-aws-region
resource "aws_acm_certificate" "main" {
  provider          = aws.us_east
  domain_name       = aws_s3_bucket.website.bucket
  validation_method = "DNS"

  tags = {
    service-name = var.service_name
    environment  = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.main.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.main.id
  records = [aws_acm_certificate.main.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  provider                = aws.us_east
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}
