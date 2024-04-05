<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws.primary | >= 4.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Common in most modules, 'name' should be assigned at least in-part to all resources | `string` | n/a | yes |
| optional\_list | An example of an optional list of strings, that doesn't allow * in any of its values. | `list(string)` | `[]` | no |
| required\_list | An example of a required list of strings. | `list(string)` | n/a | yes |
| tags | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws | Basic information about the primary provider |

<!-- END_TF_DOCS -->