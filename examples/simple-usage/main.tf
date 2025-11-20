resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

locals {
  id = random_string.sample.id
  tags = {
    # Use any tags that are applicable and not already covered by default_tags
    Owner          = "Test"
    App            = "TestApp"
    Project        = "TestProject"
    Ticket         = "https://github.com/sample-org-00/issues/xxx" # Optional
    FollowUpDate   = "1970-01-01"                                  # Optional
    FollowUpReason = "https://github.com/sample-org-00/issues/xxx" # Optional
  }
}

module "target" {
  source = "../../"

  # Pass the default AWS provider from provider.tf
  # This is required because the module uses configuration_aliases = [aws]
  providers = {
    aws = aws
  }

  name = "test-${local.id}"
  # Module spefic tags, not convered by default_tags
  tags = merge(local.tags, {
    "Hello" = "World"
  })
}

output "all" {
  value = module.target
}
