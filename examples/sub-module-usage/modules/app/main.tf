# This sub-module uses the testable-module template
# This demonstrates the common pattern of:
# root module -> app sub-module -> testable-module

module "testable" {
  source = "../../../../" # Points to the root of the template module

  # Pass the AWS provider through from the root module
  # This is required because the module uses configuration_aliases = [aws]
  providers = {
    aws = aws
  }

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
