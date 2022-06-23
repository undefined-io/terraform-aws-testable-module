terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.74.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
