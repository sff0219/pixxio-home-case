locals {
  common_tags = {
    environment = "homecase"
    company     = "pixxio"
  }
}

# S3 provider (us-east-1)
provider "aws" {
  alias  = "use1"
  region = "us-east-1"

  default_tags {
    tags = merge(local.common_tags, {
      cdnbucket = "false"
    })
  }
}

# EC2 provider (eu-central-1) as default
provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = local.common_tags
  }
}
