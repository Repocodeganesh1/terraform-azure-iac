output "id" {
  description = "Resource ID of the Linux Function App."
  value       = module.function_app.resource_id
}

output "name" {
  description = "Name of the Linux Function App."
  value       = module.function_app.resource.name
}

output "default_hostname" {
  description = "Default hostname of the Function App."
  value       = module.function_app.resource.properties.defaultHostName
}

output "principal_id" {
  description = "System-Assigned Managed Identity Principal ID (if enabled)."
  value       = var.identity_type == "SystemAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? module.function_app.resource.identity.principalId : null
}

output "storage_account_name" {
  description = "Backend Storage Account name."
  value       = azurerm_storage_account.this.name
}

output "app_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key."
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}
