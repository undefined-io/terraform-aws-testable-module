# All of these variables and checks are meant as examples

variable "name" {
  type = string
  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The 'name' cannot be empty."
  }
  description = <<-DOC
  Common in most modules, 'name' should be assigned at least in-part to all resources
  DOC
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Example variables - uncomment and modify as needed for your module

# Example: Required list with null prevention
# variable "subnet_ids" {
#   type        = list(string)
#   nullable    = false
#   description = "List of subnet IDs where resources will be created"
#   validation {
#     condition     = length(var.subnet_ids) > 0
#     error_message = "At least one subnet ID must be provided."
#   }
# }

# Example: Optional list with validation
# variable "allowed_principals" {
#   type        = list(string)
#   default     = []
#   description = "List of AWS principals allowed to access the resource (no wildcards)"
#   validation {
#     condition     = !anytrue([for principal in var.allowed_principals : strcontains(principal, "*")])
#     error_message = "Wildcard principals (*) are not allowed for security reasons."
#   }
# }

# Example: VPC ID with format validation
# variable "vpc_id" {
#   type        = string
#   description = "VPC ID where resources will be created"
#   validation {
#     condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
#     error_message = "VPC ID must be in valid format (vpc-xxxxx)."
#   }
# }

# Example: Environment with restricted values
# variable "environment" {
#   type        = string
#   description = "Environment name (dev, staging, prod)"
#   validation {
#     condition     = contains(["dev", "staging", "prod"], var.environment)
#     error_message = "Environment must be one of: dev, staging, prod."
#   }
# }

# Example: CIDR blocks with validation
# variable "cidr_blocks" {
#   type        = list(string)
#   description = "CIDR blocks for network configuration"
#   validation {
#     condition     = alltrue([for cidr in var.cidr_blocks : can(cidrhost(cidr, 0))])
#     error_message = "All CIDR blocks must be valid IPv4 CIDR notation."
#   }
# }
