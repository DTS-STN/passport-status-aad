# #############################################################################
# Azure Active Directory Enterprise Application configuration...
# #############################################################################

locals {
  # This application ID is hardcoded (as opposed to using something like random_uuid)
  # because changing it would result in new resources being created
  spn_application_id    = "de3625ec-c6e6-46a6-b761-7b1039ab546a"
}

data "azuread_users" "spn_owners" {
  # Enterprise application owners have the ability to manage all aspects of an enterprise application.
  # see: https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/overview-assign-app-owners
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.resource_owners
}

resource "azuread_service_principal" "passport_status" {
  # AAD enterprise applications are just specialized service principals
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal

  # Note: application_id is a random UUID, but hardcoded
  # because changing this would result in a new resource being created
  application_id = local.spn_application_id

  app_role_assignment_required = true
  owners                       = data.azuread_users.spn_owners.object_ids

  feature_tags {
    enterprise = true
    hide       = true
  }
}