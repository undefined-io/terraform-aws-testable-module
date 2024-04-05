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
Project = "TestProject"
    Ticket         = "https://github.com/sample-org-00/issues/xxx" # Optional
    FollowUpDate       = "1970-01-01"                                  # Optional
    FollowUpReason = "https://github.com/sample-org-00/issues/xxx" # Optional
  }
}

module "target" {
  source = "../../"

  # - This is an example as to how you would work with multiple providers in a module
  # - Providers don't have to be named primary or secondary, any name that makes
  #   sense works here.
  providers = {
    aws.primary = aws
  }

  name = "test-${local.id}"
  # Module spefic tags, not convered by default_tags
  tags = merge(local.tags, {
    "Hello" = "World"
  })
  required_list = []
  #optional_list = ["if you un-comment this * you'll see the validation in effect"]
}

output "all" {
  value = module.target
}
