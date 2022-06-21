data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
locals {
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_dns_suffix = data.aws_partition.current.dns_suffix
  aws_partition  = data.aws_partition.current.partition
}
