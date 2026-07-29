variable "subscription_id" {
  description = "Azure subscription ID for the bootstrap subscription."
  type        = string
}

variable "location" {
  description = "Azure region for bootstrap resources."
  type        = string
  default     = "centralindia"
}

variable "environment" {
  description = "Environment suffix."
  type        = string
  default     = "boot"
}

variable "project" {
  description = "Project name used in tags."
  type        = string
  default     = "happytechies"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "platform-team"
}

variable "cost_center" {
  description = "Cost center tag value."
  type        = string
  default     = "shared-services"
}

variable "instance" {
  description = "Instance number."
  type        = string
  default     = "01"
}

variable "tfstate_container_name" {
  description = "Name of the blob container that will hold Terraform state."
  type        = string
  default     = "tfstate"
}

variable "key_vault_name" {
  description = "Name of the Key Vault to create in the bootstrap resource group."
  type        = string
  default     = "kv-ht-boot-cin-01"
}

variable "key_vault_name2" {
  description = "Name of the Key Vault to create in the bootstrap resource group."
  type        = string
  default     = "kv-ht-boot-cin-02"
}

variable "key_vault_sku_name" {
  description = "SKU to use for the Key Vault."
  type        = string
  default     = "standard"
}

variable "key_vault_purge_protection_enabled" {
  description = "Whether purge protection is enabled on the Key Vault."
  type        = bool
  default     = false
}
