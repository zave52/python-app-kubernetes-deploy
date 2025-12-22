output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.sa.email
}

output "service_account_name" {
  description = "Resource name of the created service account"
  value       = google_service_account.sa.name
}

output "service_account_unique_id" {
  description = "Unique id of the created service account"
  value       = google_service_account.sa.unique_id
}
