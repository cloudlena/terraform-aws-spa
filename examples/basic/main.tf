terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

variable "hostname" {}
variable "domain" {}
variable "resource_suffix" {}

module "website" {
  source = "../.."
  providers = {
    aws.us_east = aws.us_east
  }

  hostname        = var.hostname
  domain          = var.domain
  resource_suffix = var.resource_suffix
}

output "fqdn" {
  value = module.website.fqdn
}
