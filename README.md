# Terraform module google-nocode-webserver

Provisions an Google Compute VPC network containing a webserver with a sample HashiCafe website.

Enabled for Terraform Cloud [no-code provisioning](https://developer.hashicorp.com/terraform/cloud-docs/no-code-provisioning/module-design).

## Prerequisites

For no-code provisioning, Google credentials must be supplied to the workspace via the `GOOGLE_CREDENTIALS` environment variable (ssee [docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#using-terraform-cloud)) or using [dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.http-server](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.hashicafe](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.hashicafe](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.hashicafe](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [null_resource.configure-web-app](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.product](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [tls_private_key.ssh-key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | This prefix will be included in the name of most resources. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | ID of your GCP project. | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Specifies the GCP instance type. | `string` | `"g1-small"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources are created. | `string` | `"us-central1"` | no |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | The address prefix to use for the subnet. | `string` | `"10.0.10.0/24"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone where the resources are created. | `string` | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | URL of the deployed webapp. |
| <a name="output_product"></a> [product](#output\_product) | The product which was randomly selected. |
<!-- END_TF_DOCS -->