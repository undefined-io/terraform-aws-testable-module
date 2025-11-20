data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_organizations_organization" "primary" {}
locals {
  aws_primary = {
    region          = data.aws_region.current.name
    account_id      = data.aws_caller_identity.current.account_id
    dns_suffix      = data.aws_partition.current.dns_suffix
    partition       = data.aws_partition.current.partition
    organization_id = data.aws_organizations_organization.primary.id
  }
}
