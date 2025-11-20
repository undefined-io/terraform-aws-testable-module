### OVERVIEW BEGIN
# Refer to the 'Module Versioning' section in the README for more information
### OVERVIEW END
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"

      # The module uses the default AWS provider. If you need to use explicit
      # provider aliases (for multi-region or multi-account scenarios):
      # 1. Uncomment the configuration_aliases below
      # 2. Update all data sources in main.tf to specify the provider
      # 3. Consider adding an invalid default provider in your example to prevent
      #    accidental use of the wrong provider:
      #    provider "aws" {
      #      region     = "invalid"
      #      access_key = "invalid"
      #      secret_key = "invalid"
      #    }
      # configuration_aliases = [
      #   aws.primary,
      # ]
    }
  }
}
