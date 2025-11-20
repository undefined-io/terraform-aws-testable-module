# This sub-module uses the testable-module template
# This demonstrates the common pattern of:
# root module -> app sub-module -> testable-module

module "testable" {
  source = "../../../../" # Points to the root of the template module

  # The module uses the default AWS provider, which is passed through
  # from the root module automatically

  name = "${var.name_prefix}-app"
  tags = {
    "Component" = "App"
    "Layer"     = "SubModule"
  }
}

# The app module can add additional resources and logic
# that use the testable-module's outputs
output "aws_info" {
  value       = module.testable.aws
  description = "AWS information from testable module"
}
