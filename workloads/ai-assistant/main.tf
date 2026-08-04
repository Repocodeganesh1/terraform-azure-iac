data "azurerm_client_config" "current" {}

# Lookups for Hub VNet (for peering)
data "azurerm_resource_group" "hub" {
  provider = azurerm.hub
  name     = var.hub_resource_group_name
}

data "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.hub.name
}

# Lookups for Shared Services Resources (LAW, APIM)
data "azurerm_resource_group" "shared" {
  provider = azurerm.shared
  name     = var.shared_resource_group_name
}

data "azurerm_log_analytics_workspace" "shared" {
  provider            = azurerm.shared
  name                = var.shared_law_name
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_api_management" "shared" {
  provider            = azurerm.shared
  name                = var.shared_apim_name
  resource_group_name = data.azurerm_resource_group.shared.name
}

# Naming modules
module "aiast_rg_name" {
  source = "../../modules/naming"

  resource_type  = "rg"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_vnet_name" {
  source = "../../modules/naming"

  resource_type  = "vnet"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_oai_name" {
  source = "../../modules/naming"

  resource_type  = "oai"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.openai_location_short
  instance       = var.instance
}

module "aiast_asp_name" {
  source = "../../modules/naming"

  resource_type  = "asp"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_st_name" {
  source = "../../modules/naming"

  resource_type  = "st"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_func_name" {
  source = "../../modules/naming"

  resource_type  = "func"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_appi_name" {
  source = "../../modules/naming"

  resource_type  = "appi"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

module "aiast_cosmos_name" {
  source = "../../modules/naming"

  resource_type  = "cosmos"
  project        = var.project
  workload       = var.workload
  environment    = var.environment
  location_short = var.location_short
  instance       = var.instance
}

# Resource Group for DevOnboard AI workload
resource "azurerm_resource_group" "ai_assistant" {
  name     = module.aiast_rg_name.name
  location = var.location
  tags     = local.tags
}

# Spoke Virtual Network using network wrapper module
module "aiast_vnet" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.ai_assistant.name
  location            = azurerm_resource_group.ai_assistant.location
  vnet_name           = module.aiast_vnet_name.name
  address_space       = var.vnet_address_space

  subnet_names = [
    "snet-app-integration",
    "PrivateEndpoints"
  ]

  subnet_prefixes = [
    var.app_subnet_prefix,
    var.private_endpoints_subnet_prefix
  ]

  tags = local.tags
}

# Bi-directional VNet Peering to Hub
module "aiast_to_hub_peering" {
  source = "../../modules/vnet_peering"

  providers = {
    azurerm.vnet_1 = azurerm
    azurerm.vnet_2 = azurerm.hub
  }

  vnet_1_name = module.aiast_vnet.vnet_name
  vnet_1_rg   = azurerm_resource_group.ai_assistant.name
  vnet_1_id   = module.aiast_vnet.vnet_id

  vnet_2_name = data.azurerm_virtual_network.hub.name
  vnet_2_rg   = data.azurerm_resource_group.hub.name
  vnet_2_id   = data.azurerm_virtual_network.hub.id

  depends_on = [
    module.aiast_vnet
  ]
}

# Azure OpenAI via Cognitive Account Wrapper Module
module "openai" {
  source = "../../modules/cognitive_account"

  name                       = module.aiast_oai_name.name
  location                   = var.openai_location
  resource_group_id          = azurerm_resource_group.ai_assistant.id
  sku_name                   = "S0"
  custom_subdomain_name      = module.aiast_oai_name.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.shared.id

  deployments = {
    "gpt-4o-mini" = {
      model_format  = "OpenAI"
      model_name    = "gpt-4o-mini"
      model_version = "2024-07-18"
      sku_name      = "GlobalStandard"
      sku_capacity  = 10 # 10k tokens/min cap – keeps cost near $0 idle
    }
  }

  tags = local.tags
}

# Cosmos DB (NoSQL) Free Tier for AI chat memory and session history
module "cosmos_db" {
  source = "../../modules/cosmos_db"

  name                = module.aiast_cosmos_name.name
  location            = azurerm_resource_group.ai_assistant.location
  resource_group_name = azurerm_resource_group.ai_assistant.name
  enable_free_tier    = true

  tags = local.tags
}

# App Service Plan for the workload Function App.
module "aiast_service_plan" {
  source = "../../modules/service_plan"

  name                = module.aiast_asp_name.name
  location            = azurerm_resource_group.ai_assistant.location
  resource_group_name = azurerm_resource_group.ai_assistant.name
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.tags
}

# Serverless Function App via Function App Wrapper Module
module "function_app" {
  source = "../../modules/function_app"

  name                       = module.aiast_func_name.name
  location                   = azurerm_resource_group.ai_assistant.location
  resource_group_id          = azurerm_resource_group.ai_assistant.id
  resource_group_name        = azurerm_resource_group.ai_assistant.name
  storage_account_name       = module.aiast_st_name.name
  service_plan_id            = module.aiast_service_plan.id
  app_insights_name          = module.aiast_appi_name.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.shared.id
  python_version             = "3.11"
  identity_type              = "SystemAssigned"

  app_settings = {
    "AZURE_OPENAI_ENDPOINT" = module.openai.endpoint
    "AZURE_OPENAI_MODEL"    = "gpt-4o-mini"
    "COSMOS_DB_ENDPOINT"    = module.cosmos_db.endpoint
    "COSMOS_DB_DATABASE"    = module.cosmos_db.database_name
    "COSMOS_DB_CONTAINER"   = module.cosmos_db.container_name
    "APP_NAME"              = "DevOnboard AI"
    "APP_VERSION"           = "1.0.0"
  }

  tags = local.tags
}

# Role Assignment: Grant "Cognitive Services OpenAI User" to Function App System-Assigned Identity
# Solution 2: Explicit depends_on handles ordering
resource "azurerm_role_assignment" "func_openai_user" {
  scope                = module.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.function_app.principal_id

  depends_on = [
    module.function_app,
    module.openai
  ]
}

# Register OpenAI Backend in Shared APIM
resource "azurerm_api_management_backend" "openai_backend" {
  provider            = azurerm.shared
  name                = "openai-backend-${var.workload}"
  resource_group_name = data.azurerm_resource_group.shared.name
  api_management_name = data.azurerm_api_management.shared.name
  protocol            = "http"
  url                 = "${module.openai.endpoint}openai"

  description = "APIM backend for Azure OpenAI (gpt-4o-mini)"
}
