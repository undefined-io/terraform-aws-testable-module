---
title: Testing Terraform Modules
description: Testing Terraform Modules
author: Philip Hadviger
keywords: terraform,modules,testing
url: https://github.com/undefined-io/terraform-aws-testable-module/tree/main/slides.md
header: Testing Terraform Modules
---

# Testing Terraform (*reusable*) Modules

- Automated Integration Tests

- Automat(ed\|ic) Unit Tests

*In the template repo https://github.com/undefined-io/terraform-aws-testable-module* read:

- `MODULE-TEMPLATE-README.md`
- `.test/README.md`

*Also read: https://www.hashicorp.com/blog/testing-hashicorp-terraform* someday.

---

# Terminology (so we speak the same language)

**IaC** - Infrastructure as code

**TF** - Terraform

**Root Module** - Contains the provider, backend, and the infrastructure desired.  Tied to state.

**TF Module** - A potentially reusable piece of IaC, invoked from a root module, or another TF Module.  Not directly tied to state.

<!--

- deep nesting seems to be discouraged in the devops community these days. 

-->

**Unit Test** - In the Terraform world, a combination of linting, syntax checking initialization.

**Integration Test** - Actually applying the IaC using the defined providers (This could be in the cloud, but technically also something like localstack.)

---

# Root Modules

Versioning is usually very specific.

- `required_version = "= 0.12.31"`
- `required_version = "~> 1.0.0"`
- `aws = { source  = "hashicorp/aws" version = "= 3.27.0" }`

Tied to a state file.

Easier to test, since it is designed to be applied

---

# Modules

Versioning needs to be more lenient to allow it to be used until a re-factor is needed.

<!--

- Setting an upper bound is often undesirable since it could introduce mandatory refactors prior to use, even when the only change is a version number upgrade.
- Lower bounds should indicate minimum level that module will function, or that author is willing to support

-->

- `required_version >= "0.12.31"`
- `aws = { source  = "hashicorp/aws" version = ">= 3.27.0" }`

Not tied to state by design

No straight forward path to test without a root module

Needs to be tested with multiple Terraform providers, registry providers.

---

# Road to Testability - Today

- Automated / Automatic Unit Tests
  - Multiple versions of Terraform
  - Latest version of the registry provider
- Automated (mostly) Integration Tests
  - Lowest supported version of Terraform
  - Latest version of the registry provider
- Module template repo so we can upgrade the template as we upgrade the module
- All module repos have topics for discover-ability

---

# Road to Testability - Goal

- Automated / Automatic Unit Tests
  - Multiple versions of Terraform
  - At a minimum the lower and upper bounds of the supported providers
- Automated (mostly) Integration Tests
  - Multiple versions of Terraform
  - At a minimum the lower and upper bounds of the supported providers
  - ..., but hopefully also localstack like setups
- Clear visibility into module usage

---

# Motiviation

- ... pushing a PR for a module

- then pushing a PR referencing the new module
- discover that while you've tested it in TF 0.14, it doesn't work in the 0.12.31 workspace that also uses it
- repeat
- finding out that later that another module uses it, in a workspace that is running 0.13.7 and that broke

---

# The current approach

- Use tech we already know (make, github actions, terraform)
- Make it not too restrictive yet, so that we can work out kinks and discover what we want.
- An hopefully as part of this, use semver more how it's meant to be used for modules.
