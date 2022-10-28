# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for
# working with multiple Terraform modules, remote state, and locking: https://github.com/gruntwork-io/terragrunt
#
# See also: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example
# ---------------------------------------------------------------------------------------------------------------------

locals {
  env_config    = read_terragrunt_config("env.hcl")
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are
# automatically merged into the child `terragrunt.hcl` config via the include
# block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is
# especially helpful with multi-account configs where terraform_remote_state
# data sources are placed directly into the modules.
inputs = merge({
  # add global inputs here
})

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL RESOURCES
# These resources are used by all environments in this project.
# ---------------------------------------------------------------------------------------------------------------------

remote_state {
 backend = "azurerm"
 generate = {
   path      = "backend.tf"
   if_exists = "overwrite_terragrunt"
 }
 config  = {
   container_name       = "terraform-state"
   key                  = "${path_relative_to_include("root")}.tfstate"
   resource_group_name  = "${local.env_config.locals.backend_resource_group_name}"
   storage_account_name = "${local.env_config.locals.backend_storage_account_name}"
   subscription_id      = "${local.env_config.locals.backend_subscription_id}"
 }
}
