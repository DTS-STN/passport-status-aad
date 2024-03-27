output "application_id" {
  description = "The application registration ID (also called client ID)."
  value       = azuread_application.passport_status.client_id
}

output "client_id" {
  description = "The client ID (also called application registration ID)."
  value       = azuread_application.passport_status.client_id
}

output "client_secret" {
  description = "The default client secret."
  value       =  azuread_application_password.passport_status.value
  sensitive   = true
}