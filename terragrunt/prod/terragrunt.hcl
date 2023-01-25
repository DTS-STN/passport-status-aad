terraform {
  source = "${get_path_to_repo_root()}/terraform//azure-ad"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  application_display_name       = "Passport Status (prod)"
  application_identifier_uris    = ["api://passport-status.esdc-edsc.gc.ca"]
  interop_service_principal_name = "interop-sa-esdc-backends"

  application_spa_redirect_uris = [
    "https://passport-status-api.prod-dp-internal.dts-stn.com/swagger-ui/oauth2-redirect.html"
  ]

  resource_owners = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]

  application_managers = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]

  passport_status_readers = []

  admin_passport_status_readers = []

  passport_status_writers = []

  admin_passport_status_writers = []
}
