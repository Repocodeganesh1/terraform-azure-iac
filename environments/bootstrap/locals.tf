locals {
  region_code = "cin"
  resource_group_name = "rg-ht-${var.environment}-platform-${local.region_code}-${var.instance}"
  storage_account_name = lower(replace("stht${var.environment}tfstate${local.region_code}${var.instance}", "-", ""))
  tags = {
    Company     = "ht"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }
}
