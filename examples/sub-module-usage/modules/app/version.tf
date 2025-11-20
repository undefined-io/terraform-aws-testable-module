terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
      # This sub-module accepts an AWS provider from the calling module
      # and passes it through to the testable-module
      configuration_aliases = [aws]
    }
  }
}
