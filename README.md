# Module Repository for Terraform
Currently works and tested against terraform 0.13 and terraform 0.14 modules currently undergoing and upgrade to support terraform 1.x.x

### Contributing
Please install the following
 * [terraform-docs](https://github.com/terraform-docs/terraform-docs) `brew install terraform-docs`
 * [pre-commit](https://github.com/pre-commit/pre-commit) `brew install pre-commit`
 * [tf-lint](https://github.com/terraform-linters/tflint) `brew install tflint`
 * To generate documentation, run: `./generate_docs.sh`



### Usage
In the module block you can set the source as such and inputs can be seen in the module's individual README.md
```hcl
module "falco" {
  source = "github.com/doc-ai/terraform-modules//cloud-native//falco?ref=<release_tag>"
}
```
