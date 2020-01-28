# Terraform SPA

A [Terraform](https://www.terraform.io/) module for a single page application (e.g. [React](https://reactjs.org/), [Vue.js](https://vuejs.org/) or [Angular](https://angular.io/)) to be hosted on [AWS S3](https://aws.amazon.com/s3/).

## Usage

```terraform
module "spa" {
  source = "github.com/mastertinner/terraform-spa"

  service_name       = "website"
  domain             = "example.com"
  asset_path_pattern = ["js/*", "css/*"]
}
```
