terraform {
  source = "${get_path_to_repo_root()}/terraform//azure-ad"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  application_display_name       = "Passport Status: API (nonprod)"
  application_identifier_uris    = ["api://passport-status-nonprod.esdc-edsc.gc.ca"]
  interop_service_principal_name = "interop-sa-esdc-backends-dev"

  application_spa_redirect_uris = [
    "http://localhost:8080/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api.localtest.me/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api-dev.dev-dp-internal.dts-stn.com/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api-test.dev-dp-internal.dts-stn.com/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api-staging.dev-dp-internal.dts-stn.com/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api-staging.dev-dp.dts-stn.com/swagger-ui/oauth2-redirect.html",
    "https://passport-status-api-nightly.dev-dp-internal.dts-stn.com/swagger-ui/oauth2-redirect.html",
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

  passport_status_readers = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]

  admin_passport_status_readers = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]

  passport_status_writers = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]

  admin_passport_status_writers = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "ken.blanchard@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]
}