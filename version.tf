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
      # provider aliases (for multi-region or multi-account scenarios), you can
      # uncomment the configuration_aliases below and update references in main.tf
      # configuration_aliases = [
      #   aws.primary,
      # ]
    }
  }
}
