resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

locals {
  id = random_string.sample.id
  tags = {
    IsTerraformTest : "true"
  }
}

module "target" {
  source = "../"

  # Example tag block
  #tags = merge(local.tags, {
  #  "Hello" : "World"
  #})
}

output "all" {
  value = module.target
}
