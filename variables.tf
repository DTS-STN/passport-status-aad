variable "resource_owners" {
  description = "Active Directory user principal names of users who own the app registration and enterprise application."
  type        = set(string)

  default = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]
}

variable "application_managers" {
  description = "Active Directory user principal names of users who should be assigned the Application.Manage role."
  type        = set(string)

  default = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]
}

variable "passport_status_readers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Read role."
  type        = set(string)

  default = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]
}

variable "passport_status_writers" {
  description = "Active Directory user principal names of users who should be assigned the PassportStatus.Write role."
  type        = set(string)

  default = [
    "gregory.j.baker@hrsdc-rhdcc.gc.ca",
    "sebastien.comeau@hrsdc-rhdcc.gc.ca",
    "stefan.oconnell@hrsdc-rhdcc.gc.ca"
  ]
}