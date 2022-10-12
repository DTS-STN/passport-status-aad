# #############################################################################
# Azure Active Directory App Registration configuration...
#
# Note that in the AzureAD terraform provider, an app registration is actually an `azuread_application` resource
# see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application
# #############################################################################

locals {
  # These app role IDs are hardcoded (as opposed to using something like random_uuid)
  # because changing them would result in new resources being created
  app_role_application_manage_id    = "397c5695-d01c-4089-8546-2b4a1ebdb493"
  app_role_passport_status_read_id  = "c8c40019-c97b-40e0-aaf2-86e529c15c62"
  app_role_passport_status_write_id = "7403810e-986d-49d1-9205-a8918af78e12"
}

data "azuread_users" "application_owners" {
  # Application registraion owners have the ability to view and edit an application registration.
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
  user_principal_names = var.resource_owners
}

resource "azuread_application" "passport_status" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application

  display_name          = "Passport Status"
  identifier_uris       = ["api://passport-status.esdc-edsc.gc.ca"]
  logo_image            = filebase64("assets/logo.png")
  owners                = data.azuread_users.application_owners.object_ids
  privacy_statement_url = "https://www.canada.ca/en/transparency/privacy.html"
  terms_of_service_url  = "https://www.canada.ca/en/transparency/terms.html"

  api {
    requested_access_token_version = 2
  }

  app_role {
    id                   = local.app_role_application_manage_id
    allowed_member_types = ["Application", "User"]
    description          = "Application managers have the ability to manage the Passport Status application via it's various actuator and management endpoints."
    display_name         = "Application managers"
    value                = "Application.Manage"
  }

  app_role {
    id                   = local.app_role_passport_status_read_id
    allowed_member_types = ["Application", "User"]
    description          = "Passport status readers have the ability to read passport statuses."
    display_name         = "Passport status readers"
    value                = "PassportStatus.Read"
  }

  app_role {
    id                   = local.app_role_passport_status_write_id
    allowed_member_types = ["Application", "User"]
    description          = "Passport status writers have the ability to create, read, update, and delete passport statuses."
    display_name         = "Passport status writers"
    value                = "PassportStatus.Write"
  }

  required_resource_access {
    resource_app_id = azuread_service_principal.passport_status.application_id

    resource_access {
      # Application.Manage
      id   = local.app_role_application_manage_id
      type = "Role"
    }

    resource_access {
      # PassportStatus.Read
      id   = local.app_role_passport_status_read_id
      type = "Role"
    }

    resource_access {
      # PassportStatus.Write
      id   = local.app_role_passport_status_write_id
      type = "Role"
    }
  }

  required_resource_access {
    # Microsoft Graph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      # User.Read
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = [
      "http://localhost:8080/swagger-ui/oauth2-redirect.html",
      "https://passport-status-api.localtest.me/swagger-ui/oauth2-redirect.html",
      "https://passport-status-api.dev.dev-rhp.dts-stn.com/swagger-ui/oauth2-redirect.html",
      "https://passport-status-api.staging.dev-rhp.dts-stn.com/swagger-ui/oauth2-redirect.html"
    ]
  }

  web {
    homepage_url = "https://www.canada.ca/en.html"
  }
}

# #############################################################################
# SPN app role assignments...
# #############################################################################

resource "azuread_app_role_assignment" "app_role_application_manage_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = local.app_role_application_manage_id
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_read_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = local.app_role_passport_status_read_id
  principal_object_id = azuread_service_principal.passport_status.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}

resource "azuread_app_role_assignment" "app_role_passport_status_write_admin_consent" {
  # see: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment
  app_role_id         = local.app_role_passport_status_write_id
  principal_object_id = azuread_service_principal.passport_status.object_id
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

  app_role_id         = local.app_role_application_manage_id
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

  app_role_id         = local.app_role_passport_status_read_id
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

  app_role_id         = local.app_role_passport_status_write_id
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.passport_status.object_id
}