[![unit-test](../../actions/workflows/unit-test.yml/badge.svg)](../../actions/workflows/unit-test.yml)

# `terraform-aws-testable-module`

A template repository for Terraform modules.  Supports GitHub and Spacelift tests.

## Usage

### Setting up a new module repository

- [Create a new repository](https://github.com/undefined-io/terraform-aws-testable-module/generate) from the template 

  > If this module requires access to other private repository modules in the via SSH, please add the `TF_TESTABLE_MODULE_SSH_KEY`  secret to your repository.

- (*Suggestion*) Add `terraform` and `module` as topics in the "About" section of the repository

- Configure proper versions in the `versions.tf` file

- Change the matrix to match what you plan on supporting in the `.github/workflows/module-test.yaml` file

- (Optional) If you plan on running the GitHub Action locally, install [nektos/act](https://github.com/nektos/act).  More information on that is [here]().

- Commit the initial changes to make sure the GitHub action succeeds with the new repo.

### Updating to the latest version of the template

(*Optional*) This setup will allow you to easily merge updates to the template at a later point.  By doing this now, the later merges will be significantly easier.

```bash
git remote add template git@github.com:undefined-io/terraform-aws-testable-module.git
git fetch --all
git merge --no-commit --allow-unrelated-histories template/main
# resolve the merge conflicts
git add -A
git commit
```

## Testing Overview

To better understand some of the terminology, I highly recommend at least reading over [this blog post](https://www.hashicorp.com/blog/testing-hashicorp-terraform) explaining some of the basic terraform test concepts, such as what a **unit test** is.

Our current system is focused on the following.

- Local Unit Tests

  These use the currently installed version of terraform, and do a basic sanity on the module to make sure it would run at all.

- Automated **Unit Tests** via GitHub actions.

  These are fired automatically on commit to GitHub, but can also be executed locally.  They run against a matrix of Terraform versions to make establish that versions of Terraform this module could support.

- Locally initiated **Integration Tests**.

## 1. Local Unit Tests

- Uses locally installed `terraform` to validate `.tf` files.
- Does not create any resources

### Requirements

- Terraform

### Steps

```bash
make validate # to run the validation (faster)
make clean validate # to run the validation, but clear local cache first
```

## 2. Local Automated Unit Tests

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

## 3. Locally Initiated Integration Tests

### Full Test

The test is a basic `terraform init/apply/destroy` using local state.

```bash
# provide environment variables for the AWS provider
# , then run...
make integraton
```

### Partial Test

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

### A Note About `make setup`

`make setup` which is part of `make test` runs `terraform apply` twice.  This is intentional, to deal with cases in which some terraform code unintentionally alters resources that have already been successfully deployed and really should not be changing on a second apply.

## Notes

### Existing Module Usage Helper Script

```bash
# Run in the root of aws-infrastructure
grep -ire '[?]ref=' \
  --exclude-dir=.terraform \
  --no-filename . \
  | sed -e 's|git@github.com:||' -e 's|git::https://github.com/||' \
  | awk -F' = ' '{a[$2]++} END{for (i in a) print i, a[i]}' \
  | sort
```

