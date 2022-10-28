# Passport Status AAD configuration

This Terraform/Terragrunt project contains the various Azure Active Directory
configurations (ie: enterprise application and application registration) used by
the Passport Status application.

## Requirements

This project has been tested with the following toolchain:

| Tool       | Version          |
| ---------- | ---------------- |
| Azure CLI  | ≥ 2.40.0         |
| Terraform  | ≥ 1.3.0, < 2.0.0 |
| Terragrunt | 0.37.x           |

## Running

**Important:** to run this project, you must be assigned the *Application
Administrator* role in Azure Active Directory.

**Important:** to run this project, you must be connected to the DTS VPN.

``` sh
az login
cd terragrunt/{target-environment}/canadacentral
terragrunt apply
```

## Getting the application registration ID (also known as client ID)

The application registration ID is configured as an output variable, so it will
render whenever you perform a `terragrunt apply`. However, if you need to get the
client id without running `terragrunt apply`, you canter use the following
command:

``` sh
az login
cd terragrunt/{target-environment}/canadacentral
terragrunt output client_id
```

## Getting client secrets

For security reasons, the default client secret is exposed as a sensitive output
variable. If you need the default client secret, you can get it using the
following command:

``` sh
az login
cd terragrunt/{target-environment}/canadacentral
terragrunt output client_secret
```

## Authors

- [Greg Baker](https://github.com/gregory-j-baker)
