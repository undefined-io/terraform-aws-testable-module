resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

locals {
  id = random_string.sample.id
}

# This demonstrates using a sub-module that internally uses the testable-module
module "app" {
  source = "./modules/app"

  name_prefix = "test-${local.id}"
}

output "app_info" {
  value       = module.app
  description = "Information from the app sub-module"
}
