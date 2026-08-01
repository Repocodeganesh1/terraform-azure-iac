output "resource_group_name" {
  description = "Bootstrap resource group name."
  value       = azurerm_resource_group.bootstrap_new.name
}

output "storage_account_name" {
  description = "Terraform state storage account name."
  value       = azurerm_storage_account.tfstate_new.name
}

output "storage_container_name" {
  description = "Terraform state container name."
  value       = azurerm_storage_container.tfstate_new.name
}

output "key_vault_name" {
  description = "Bootstrap Key Vault name."
  value       = module.key_vault_new.name
}

output "key_vault_uri" {
  description = "Bootstrap Key Vault URI."
  value       = module.key_vault_new.vault_uri
}