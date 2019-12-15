resource "aws_s3_bucket" "website" {
  bucket        = "${lower(var.hostname)}${var.hostname == "" ? "" : "."}${lower(var.domain)}"
  acl           = "public-read"
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

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":["${aws_s3_bucket.website.arn}/*"]
    }
  ]
}
EOF
}
