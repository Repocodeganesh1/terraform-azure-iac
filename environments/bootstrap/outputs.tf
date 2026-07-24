output "resource_group_name" {
  description = "The bootstrap resource group name."
  value       = azurerm_resource_group.bootstrap.name
}

output "storage_account_name" {
  description = "The storage account used for Terraform state."
  value       = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  description = "The blob storage container used for Terraform state."
  value       = azurerm_storage_container.tfstate.name
}
