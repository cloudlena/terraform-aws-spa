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

variable "environment" {
  description = "The name of the environment the resources are deployed to"
  type        = string
  default     = "production"
}

variable "resource_suffix" {
  description = "A suffix for all resource names to make them unique"
  type        = string
  default     = ""
}

locals {
  fqdn = "${lower(var.hostname)}${var.hostname == "" ? "" : "."}${lower(var.domain)}"
}
