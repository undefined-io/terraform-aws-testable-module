### OVERVIEW BEGIN
# Refer to the 'Module Versioning' section in the README for more information
### OVERVIEW END
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"

      # The module accepts an optional AWS provider configuration.
      # By default, it uses the provider from the calling module.
      # For multi-region or multi-account scenarios, you can:
      # 1. Add a named alias (e.g., aws.secondary) to the list below
      # 2. Update data sources in main.tf to specify which provider to use
      # 3. Pass providers explicitly when calling the module
      configuration_aliases = [aws]
    }
  }
}
