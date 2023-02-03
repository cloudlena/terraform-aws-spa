data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = aws_s3_bucket.website.bucket
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main_ipv6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = aws_s3_bucket.website.bucket
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "subdomains" {
  for_each = var.alternate_subdomains

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = 300

  records = [aws_route53_record.main.name]
}
