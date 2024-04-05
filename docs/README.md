[![unit-test](../../../actions/workflows/unit-test.yml/badge.svg)](../../../actions/workflows/unit-test.yml)

# `terraform-aws-testable-module`

A template repository for Terraform (TF) modules where AWS is the primary provider.

- Unit and integration tests
- Documentation helpers

## Getting Started (Do this before writing code)

### Things you must do:

- :page_with_curl: [Create a new repository](https://github.com/new?owner=glg&template_name=terraform-aws-testable-module&template_owner=glg) from the template repository.

- :mag: Add `terraform` and `module` as topics in the "About" section of the repository

  > *This conforms with the GLG standard, and makes the module easily discoverable in GitHub.*

- :heavy_exclamation_mark: Review all the default choices in the the `version.tf` file and adjust them as needed.

  > *The `version.tf` file directly impacts the tests in the `examples/` directory, and changes might be needed there before all the tests will pass.*

- :bookmark_tabs: Create a `/README.md` file in the root directory of the repository.

  > *By default, the README is sourced from `/docs/README.md` but the root `README.md` (which should be specific to your module) will automatically become the repo default README once you create it.*

- :floppy_disk: Commit the initial changes to make sure the GitHub action succeeds in the new repository.


### Optional tasks, depending on the module:

- If this module requires access to other private repository modules in the via SSH, please add the `TF_TESTABLE_MODULE_SSH_KEY`  secret to your repository secrets.
- Change the matrix to match what you plan on supporting in the `.github/workflows/module-test.yaml` file
- If you plan on running the GitHub Action locally, install [nektos/act](https://github.com/nektos/act).
- Create a `/CONTRIBUTING.md` based on the template in `/docs/CONTRIBUTING.md`.

---

## Testing Overview

> *To better understand some of the terminology, please read over [this blog post](https://www.hashicorp.com/blog/testing-hashicorp-terraform) explaining some of the basic terraform test concepts, such as what a **unit test** is.*

Our current system is focused on the following.

- Local **Unit Tests**

  These use the *currently installed version* of Terraform, and do a basic sanity on the module to make sure it would run at all.
- Automated **Unit Tests** via GitHub actions.

  These are fired automatically on commit to GitHub, but can also be executed locally.  They run against a matrix of Terraform versions to make establish that versions of Terraform this module could support.
- Locally initiated **Integration Tests**.

## 1. Local Unit Tests

- Uses locally installed `terraform` to validate `.tf` files.
- DOES NOT create any resources

### Requirements

- Terraform

### Steps

```bash
make unit-test
```

## 2. Local Automated Unit Tests

- Run the Unit Tests via the GitHub action locally.

### Requirements

- Terraform
- [nektos/act](https://github.com/nektos/act)

### Steps

```bash
# a module with only public or no dependencies on other modules
make action

# if you need to test a module with private dependencies
export TF_TESTABLE_MODULE_SSH_KEY=$(</path/to/ssh/key/with/github/access)
make action
```

## 3. Locally Initiated Integration Tests

### Full Test

The test is a basic `terraform init/apply/destroy` using local state.

```bash
# provide environment variables for the AWS provider
# , then run...
make full-test
```

### Partial Test

When iterating on code, it can sometimes be useful not to destroy.  In that case, just call the individual operations.

```bash
# if you want to just run a plan
make plan
# create/update the resources
make apply
# do more dev
make apply
# ... (repeat until done)

# destroy only
make destroy
```

## Adding the terraform Module documentation

We are utilizing the [terraform-docs](https://terraform-docs.io/user-guide/introduction/) utility to generate comprehensive documentation for our Terraform modules, which can be exported in various output formats. This utility streamlines the process of documenting our infrastructure code, enhancing its readability and facilitating collaboration.

With `terraform-docs`, we can automatically create documentation that includes details about module inputs, outputs, variables, and more. The generated documentation can be exported in formats such as Markdown, JSON, or reStructuredText. This versatility enables us to choose the format that best aligns with our team's preferences or our project's documentation standards.

```bash
make docs
```

## Notes

### Stay up to date with the terraform-aws-testable-module template

#### Initial Setup

(*Optional*) If you set this up right after creating your template repo, it makes updates to the latest version of the template easier later.

```bash
git remote add template git@github.com:glg/terraform-aws-testable-module.git
```

#### Updating the template

```bash
git fetch --all
git merge --no-commit --allow-unrelated-histories template/main
# resolve the merge conflicts
git add -A
git commit
```

## Module Version Requirements

This pertains to the **`version.tf`** file at the root of the module.  If you need guidance, reach out to the SRE team for advice.

### Upper Bounds (In General)

With modules, it's highly recommended not to set an upper bound for versions, as it leads to situations where a module can no longer be used, because the upper bound unnecessarily forces the module to be upgraded, even though it would still function in higher versions.

Historically, we've had more problems with modules that had a specific upper bound for no reason, than with modules that had no upper bounds.

### Terraform Version

Setting a proper lower bound, to make sure the module is safe and can function at all is essential.  In terms up upper bounds, support as many versions as possible here, so the module can actually get good use.  It's really up to the consumer to define these constraints more than the module.  To cover different versions of Terraform, matrix in the provided GitHub action will help you.
