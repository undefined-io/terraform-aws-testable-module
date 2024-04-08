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

variable "required_list" {
  type        = list(string)
  description = <<-DOC
  An example of a required list of strings.
  DOC
  validation {
    condition     = length(var.required_list) >= 0
    error_message = "The 'required_list' cannot be null."
  }
}

variable "optional_list" {
  type        = list(string)
  default     = []
  description = <<-DOC
  An example of an optional list of strings, that doesn't allow * in any of its values.
  DOC
  validation {
    condition     = !anytrue([for item in var.optional_list : strcontains(item, "*")])
    error_message = "The 'optional_list' cannot contain '*' entries."
  }
}
