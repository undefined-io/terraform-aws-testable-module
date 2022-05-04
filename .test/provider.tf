### OVERVIEW BEGIN
# For providers other than AWS, think about way that you can reduce
# or completely eliminate impact on production in regards to tests.
### OVERVIEW END

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["000000000000"]
  max_retries         = 2 # default:25
}
