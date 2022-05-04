# undefined-io/terraform-aws-testable-module

This repository is meant to be used as a template repository for new standalone terraform modules.

## Usage

- [Create a new repository](https://github.com/undefined-io/terraform-aws-testable-module/generate) from the template 

  > If this module requires access to other private repository modules in the via SSH, please add the **TF_TESTABLE_MODULE_SSH_KEY**  secret to your repository.

- (*Suggestion*) Add `terraform` and `module` as topics in the "About" section of the repository

- Configure proper versions in the `versions.tf` file

- Change the matrix to match what you plan on supporting in the `.github/workflows/module-test.yaml` file

- (Optional) If you plan on running the GitHub Action locally, install [nektos/act](https://github.com/nektos/act).  More information on that is [here]().

- Commit the initial changes to make sure the GitHub action succeeds with the new repo.

- (*Optional*) Setup option to easily merge template change later.  By doing this now, the later merges will be significantly easier.  This process can then later be repeated if you intend to update older versions of this template.

  ```bash
  git remote add template git@github.com:undefined-io/terraform-aws-testable-module.git
  git fetch --all
  git merge --no-commit --allow-unrelated-histories template/main
  # resolve the merge conflicts
  git add -A
  git commit
  ```

## Testing

[Test Documentation](.test/README.md): Please read this for running and configuring tests.

After reading that, the basic usage for `act` is:

```bash
act # if there are no private dependencies

export TF_TESTABLE_MODULE_SSH_KEY=$(</path/to/ssh/key/with/github/access)
act -s TF_TESTABLE_MODULE_SSH_KEY
```

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
