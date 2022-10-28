# #############################################################################
# Azure Active Directory App Registration configuration...
#
# Note that in the AzureAD terraform provider, an app registration is actually an `azuread_application` resource
# see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application
# #############################################################################

resource "random_uuid" "app_role_application_manage_id" {}
resource "random_uuid" "app_role_passport_status_read_id" {}
resource "random_uuid" "app_role_passport_status_read_all_id" {}
resource "random_uuid" "app_role_passport_status_write_id" {}
resource "random_uuid" "app_role_passport_status_write_all_id" {}
resource "random_uuid" "spn_application_id" {}

data "azuread_users" "service_principal_owners" {
  # Enterprise application owners have the ability to manage all aspects of an enterprise application.
  # see: https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/overview-assign-app-owners
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.resource_owners
}

resource "azuread_service_principal" "passport_status" {
  # AAD enterprise applications are just specialized service principals
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal

  application_id               = azuread_application.passport_status.application_id
  app_role_assignment_required = true
  owners                       = data.azuread_users.service_principal_owners.object_ids

  feature_tags {
    enterprise = true
    hide       = true
  }
}

data "azuread_users" "application_owners" {
  # Application registraion owners have the ability to view and edit an application registration.
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.resource_owners
}

resource "azuread_application" "passport_status" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application

  display_name          = var.application_display_name
  identifier_uris       = var.application_identifier_uris
  logo_image            = filebase64("assets/logo.png")
  owners                = data.azuread_users.application_owners.object_ids
  privacy_statement_url = "https://www.canada.ca/en/transparency/privacy.html"
  terms_of_service_url  = "https://www.canada.ca/en/transparency/terms.html"

  api {
    requested_access_token_version = 2
  }

  app_role {
    id                   = random_uuid.app_role_application_manage_id.result
    allowed_member_types = ["Application", "User"]
    description          = "Application managers have the ability to manage the Passport Status application via it's various actuator and management endpoints."
    display_name         = "Application managers"
    value                = "Application.Manage"
  }

  app_role {
    id                   = random_uuid.app_role_passport_status_read_id.result
    allowed_member_types = ["Application", "User"]
    description          = "Passport status readers have the ability to read their own passport statuses."
    display_name         = "Passport status readers"
    value                = "PassportStatus.Read"
  }

  app_role {
    id                   = random_uuid.app_role_passport_status_read_all_id.result
    allowed_member_types = ["Application", "User"]
    description          = "Admin passport status readers have the ability to read all passport statuses."
    display_name         = "Admin passport status readers"
    value                = "PassportStatus.Read.All"
  }

  app_role {
    id                   = random_uuid.app_role_passport_status_write_id.result
    allowed_member_types = ["Application", "User"]
    description          = "Passport status writers have the ability to create, read, update, and delete their own passport statuses."
    display_name         = "Passport status writers"
    value                = "PassportStatus.Write"
  }

  app_role {
    id                   = random_uuid.app_role_passport_status_write_all_id.result
    allowed_member_types = ["Application", "User"]
    description          = "Admin passport status writers have the ability to create, read, update, and delete all passport statuses."
    display_name         = "Admin passport status writers"
    value                = "PassportStatus.Write.All"
  }

  single_page_application {
    redirect_uris = var.application_spa_redirect_uris
  }

  web {
    homepage_url = "https://www.canada.ca/en.html"
  }

  lifecycle {
    ignore_changes = [
      # TODO :: GjB :: figure out how to get this working
      #
      # Explanation: we typically configure the main Passport Status OAuth client
      # in Swagger to allow developers to authenticate to access protected endpoints.
      # For that to work, we have to add all of the app_roles above to the azuread_application,
      # but since that requires knowing the application id (client id), we can't do it here.
      # That mapping is done afterwards in the Azure portal, which ultimately alterst he
      # required_resource_access attribute, triggering terraform.
      required_resource_access
    ]
  }
}

resource "azuread_application_password" "passport_status" {
  application_object_id = azuread_application.passport_status.object_id
  display_name          = "Default secret"
  end_date_relative     = "876000h"
}

# #############################################################################
# Passport Status SPN app role assignments...
# #############################################################################

resource "azuread_app_role_assignment" "app_role_application_manage_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_application_manage_id.result
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_read_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_passport_status_read_id.result
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_read_all_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_passport_status_read_all_id.result
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_write_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_passport_status_write_id.result
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_write_all_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_passport_status_write_all_id.result
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

# #############################################################################
# 3rd party SPN app role assignments...
# #############################################################################

data "azuread_service_principal" "interop" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal
  display_name = var.interop_service_principal_name
}

resource "azuread_app_role_assignment" "app_role_interop_write_all_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = random_uuid.app_role_passport_status_write_all_id.result
  principal_object_id = data.azuread_service_principal.interop.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

# #############################################################################
# User/group app role assignments...
# #############################################################################

data "azuread_users" "app_role_application_manage_users" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.application_managers
}

resource "azuread_app_role_assignment" "app_role_application_manage" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  for_each = { for user in data.azuread_users.app_role_application_manage_users.users : user.user_principal_name => user }

  app_role_id         = random_uuid.app_role_application_manage_id.result
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

data "azuread_users" "app_role_passport_status_read_users" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.passport_status_readers
}

resource "azuread_app_role_assignment" "app_role_passport_status_read" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  for_each = { for user in data.azuread_users.app_role_passport_status_read_users.users : user.user_principal_name => user }

  app_role_id         = random_uuid.app_role_passport_status_read_id.result
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

data "azuread_users" "app_role_admin_passport_status_read_users" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.admin_passport_status_readers
}

resource "azuread_app_role_assignment" "app_role_admin_passport_status_read" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  for_each = { for user in data.azuread_users.app_role_admin_passport_status_read_users.users : user.user_principal_name => user }

  app_role_id         = random_uuid.app_role_passport_status_read_all_id.result
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

data "azuread_users" "app_role_passport_status_write_users" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.passport_status_writers
}

resource "azuread_app_role_assignment" "app_role_passport_status_write" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  for_each = { for user in data.azuread_users.app_role_passport_status_write_users.users : user.user_principal_name => user }

  app_role_id         = random_uuid.app_role_passport_status_write_id.result
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

data "azuread_users" "app_role_admin_passport_status_write_users" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.admin_passport_status_writers
}

resource "azuread_app_role_assignment" "app_role_admin_passport_status_write" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  for_each = { for user in data.azuread_users.app_role_admin_passport_status_write_users.users : user.user_principal_name => user }

  app_role_id         = random_uuid.app_role_passport_status_write_all_id.result
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}