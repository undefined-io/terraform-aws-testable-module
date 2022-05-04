# Testing

To better understand some of the terminology, I highly recommend at least reading over [this blog post](https://www.hashicorp.com/blog/testing-hashicorp-terraform) explaining some of the basic terraform test concepts, such as what a **unit test** is.

Our current system is focused on the following.

- Local Unit Tests

  These use the currently installed version of terraform, and do a basic sanity on the module to make sure it would run at all.

- Automated **Unit Tests** via GitHub actions.

  These are fired automatically on commit to GitHub, but can also be executed locally.  They run against a matrix of Terraform versions to make establish that versions of Terraform this module could support.

- Locally initiated **Integration Tests** against the prototype account.

## Local Unit Tests

This tests the module with whatever version of terraform is currently installed on your system.

### Requirements

- Terraform

### Steps

```bash
make validate # to run the validation (faster)
make clean validate # to run the validation, but clear local cache first
```

## Local Automated Unit Tests

### Requirements

- Terraform
- [nektos/act](https://github.com/nektos/act)

### Steps

```bash
# a module with only public or no dependencies on other modules
act -C ../

# if you need to test a module with private dependencies
export TF_TESTABLE_MODULE_SSH_KEY=$(</path/to/ssh/key/with/github/access)
act -C ../ -s TF_TESTABLE_MODULE_SSH_KEY
```

## Full Test

***Note**: This uses local state and the prototype account only.*

The test is a basic `terraform init/apply/destroy` that is only allowed to run in prototype and uses random resource names.

Paste credentials and run `make test`

```bash
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
make test
```

## Partial Test

When iterating on code, it can sometimes be useful not to destroy.  In that case, just call the individual operations.

```bash
# create/update the resources
make setup
# do more dev
make setup
# ... (repeat until done)

# destroy only
make teardown
```

## A Note About `make setup`

`make setup` which is part of `make test` runs `terraform apply` twice.  This is intentional, to deal with cases in which some terraform code unintentionally alters resources that have already been successfully deployed and really should not be changing on a second apply.
