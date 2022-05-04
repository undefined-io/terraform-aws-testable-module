### OVERVIEW BEGIN
# Please preserve this section for easier merges from the
# template repo.
#
# Lower Bounds:
#   Providers:
#     Focus on the target audience. For modules, compatibility is
#     more important that being completely up to date.  When writing a
#     module, it makes sense to really find a good middle ground for
#     provider lower bounds.
#   Terraform:
#     Similar to the above, support as much as possible here, so the
#     module can actually get good use.  It's really up to the consumer
#     to define these constraints more than the module, but set a good
#     lower bound that makes the module safe.  This is where the matrix
#     in the GitHub action will help you.
#
# Upper Bounds:
#   For modules, it's highly recommended not to set an uppper bound
#   for versions, as it leads to situations where a module can no
#   longer be used, because the upper bound unnecessarily forces the
#   module to be upgraded, even though it would still function in higher
#   versions.
#
# Make a sensible choice here based on what you plan on supporting.
### OVERVIEW END
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"
    }
  }
}
