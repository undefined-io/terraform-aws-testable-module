resource "random_uuid" "sample" {}

locals {
  id = random_uuid.sample.id
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
