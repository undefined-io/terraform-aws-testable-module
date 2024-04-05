output "aws" {
  value       = local.aws_primary
  description = <<-DOC
  Basic information about the primary provider
  DOC
}
