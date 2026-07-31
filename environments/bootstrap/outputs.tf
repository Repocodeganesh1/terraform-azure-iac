output "resource_group_name" {
  description = "Bootstrap resource group name."
  value       = azurerm_resource_group.bootstrap.name
}

output "storage_account_name" {
  description = "Terraform state storage account name."
  value       = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  description = "Terraform state container name."
  value       = azurerm_storage_container.tfstate.name
}

output "key_vault_name" {
  description = "Bootstrap Key Vault name."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Bootstrap Key Vault URI."
  value       = module.key_vault.vault_uri
}