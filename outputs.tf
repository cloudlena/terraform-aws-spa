output "fqdn" {
  description = "The FQDN of the website"
  value       = aws_route53_record.main.name
}
