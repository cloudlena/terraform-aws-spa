variable "service_name" {
  description = "The name of the service"
  type        = string
  default     = "website"
}

variable "hostname" {
  description = "The hostname to use on the provided domain"
  type        = string
  default     = ""
}

variable "domain" {
  description = "The domain the website is to be hosted on"
  type        = string
}

variable "alternate_subdomains" {
  description = "Alternate domains your app should be reachable at"
  type        = set(string)
  default     = []
}

variable "environment" {
  description = "The name of the environment the resources are deployed to"
  type        = string
  default     = "production"
}

locals {
  fqdn    = "${lower(var.hostname)}${var.hostname == "" ? "" : "."}${lower(var.domain)}"
  aliases = formatlist("%s.${aws_s3_bucket.website.bucket}", var.alternate_subdomains)
}
