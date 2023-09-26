terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

variable "hostname" {
  type = string
}
variable "domain" {
  type = string
}

module "website" {
  source = "../.."
  providers = {
    aws.us_east = aws.us_east
  }

  hostname = var.hostname
  domain   = var.domain
}

output "fqdn" {
  value = module.website.fqdn
}
