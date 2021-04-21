resource "aws_s3_bucket" "website" {
  bucket        = "${lower(var.hostname)}${var.hostname == "" ? "" : "."}${lower(var.domain)}"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    service-name = var.service_name
    environment  = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket_public_access_block.website.bucket
  policy = data.aws_iam_policy_document.website_bucket.json
}

data "aws_iam_policy_document" "website_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website.arn]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

