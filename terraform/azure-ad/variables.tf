variable "resource_owners" {
  description = "Active Directory user principal names of users who own the app registration and enterprise application."
  type        = set(string)
  default     = []
}

#
# Application registration (OAuth client)
#

variable "application_display_name" {
  description = "The display name to use for the Azure application registration."
  type        = string
}

variable "application_identifier_uris" {
  description = "A set of user-defined URIs that uniquely identify an application within its Azure AD tenant."
  type        = set(string)
}

variable "application_notes" {
  description = "A free text field to capture information about the service principal, typically used for operational purposes."
  type        = string
  default     = null
}

variable "application_privacy_statement_url" {
  description = "URL of the application's privacy statement."
  type        = string
  default     = "https://www.canada.ca/en/transparency/privacy.html"
}

variable "application_spa_redirect_uris" {
  description = "A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent."
  type        = set(string)
  default     = []
}

variable "interop_service_principal_name" {
  description = "The service principal name used by the interop team to interface with this application."
  type        = string
}

variable "application_terms_of_service_url" {
  description = "URL of the application's terms of service statement."
  type        = string
  default     = "https://www.canada.ca/en/transparency/terms.html"
}

variable "application_web_homepage_url" {
  description = "Home page or landing page of the application."
  type        = string
  default     = "https://www.canada.ca/en.html"
}

#
# Application roles
#

variable "application_managers" {
  description = "Active Directory user principal names of users who should be assigned the Application.Manage role."
  type        = set(string)
  default     = []
}

variable "passport_status_readers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Read role."
  type        = set(string)
  default     = []
}

variable "admin_passport_status_readers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Read.All role."
  type        = set(string)
  default     = []
}

variable "passport_status_writers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Write role."
  type        = set(string)
  default     = []
}

variable "admin_passport_status_writers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Write.All role."
  type        = set(string)
  default     = []
}