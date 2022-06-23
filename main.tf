data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
locals {
  aws = {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
    dns_suffix = data.aws_partition.current.dns_suffix
    partition  = data.aws_partition.current.partition
  }
}
