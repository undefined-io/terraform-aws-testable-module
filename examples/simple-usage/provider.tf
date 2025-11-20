terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

locals {
  default_tags = {
    "ManagedBy"   = "Terraform"
    "Environment" = "UnitTest"
  }
}

provider "aws" {
  max_retries = 2 # default is 25
  region      = "us-east-1"

  # IMPORTANT: Change this to your actual AWS account ID(s) when using this module
  # This example uses a placeholder account ID for unit testing purposes
  # Since unit tests use validation only (no actual AWS API calls), this value
  # isn't validated, but you MUST update it for real usage
  allowed_account_ids = ["123456789012"] # CHANGE THIS to your AWS account ID

  default_tags {
    tags = local.default_tags
  }

  # Use this if your workflow supports roles
  #assume_role {
  #  role_arn = "arn:aws:iam::000000000000:role/adequate-permission-role"
  #}
}
