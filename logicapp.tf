resource "azurerm_resource_group" "rsg" {
  name     = var.rsgname
  location = var.location
}

resource "azurerm_storage_account" "stg" {
  name                     = var.stgacnt
  resource_group_name      = var.rsgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "serplan" {
  name                = var.serviceplan
  location            = var.location
  resource_group_name = var.rsgname
  kind                = "elastic"


  sku {
    tier = "WorkflowConsumption"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "logicapp" {
  name                       = var.laname
  location                   = var.location
  resource_group_name        = var.rsgname
  app_service_plan_id        = azurerm_app_service_plan.serplan.id
  storage_account_name       = azurerm_storage_account.stg.name
  storage_account_access_key = azurerm_storage_account.stg.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
}
