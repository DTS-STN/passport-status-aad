output "application_id" {
  description = "The application registration ID (also called client ID)."
  value       = azuread_application.passport_status.application_id
}
