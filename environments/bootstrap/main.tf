terraform {
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "bootstrap" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                            = local.storage_account_name
  resource_group_name             = azurerm_resource_group.bootstrap.name
  location                        = azurerm_resource_group.bootstrap.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = true
  tags                            = local.tags

  blob_properties {
    delete_retention_policy {
      days = 1
    }
    container_delete_retention_policy {
      days = 1
    }
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tfstate_container_name
  storage_account_id   = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

module "key_vault" {
  source = "../../modules/key_vault"
  name                        = var.key_vault_name
  resource_group_name         = azurerm_resource_group.bootstrap.name
  location                    = azurerm_resource_group.bootstrap.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.key_vault_sku_name
  enable_rbac_authorization   = true
  public_network_access_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled    = var.key_vault_purge_protection_enabled
  tags                        = local.tags
}

