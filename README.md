# Passport Status AAD configuration

This Terraform project contains the various Azure Active Directory configurations
(ie: enterprise application and application registration) used by the Passport Status application.

## Requirements

This project has been tested with the following toolchain:

| Tool       | Version          |
| ---------- | ---------------- |
| Azure CLI  | ≥ 2.40.0         |
| Terraform  | ≥ 1.3.0, < 2.0.0 |

## Running

**Important:** to run this project, you must be assigned the *Application Administrator* role in Azure Active Directory.

``` sh
az login
terraform init
terraform plan
terraform apply
```

## Getting the application registration ID (also known as client ID)

The application registration ID is configured as an output variable, so it will render whenever you
perform a `terraform apply`. However, if you need to get the client id without
running `terraform apply`, you canter use the following command:

``` sh
terraform state pull | jq '.resources[] | select(.type == "azuread_application") | .instances[].attributes | { display_name, application_id }'
```

## Getting client secrets

For security reasons, the client secrets are not exposed as output variables.
If any client secrets are being managed by Terraform, you can get them using the following command:

``` sh
terraform state pull | jq '.resources[] | select(.type == "azuread_application_password") | .instances[].attributes | { display_name, value }'
```

## Authors

- [Greg Baker](https://github.com/gregory-j-baker)
