locals {  
    resource_group_name = "${var.project_name}-${var.resource_group_suffix}-rg"  
    static_web_app_name = "${var.project_name}-${var.environment}-swa"  
    storage_account_name = "${replace(lower(var.project_name), "-", "")}${var.environment}st"  
    common_tags = {   
        Environment = var.environment    
        Project     = var.project_name    
        CostCenter  = "Production"    
        Owner       = "ProdOps"    
        Region      = var.location  
    }  
    secondary_tags = {    
        Environment = var.environment    
        Project     = var.project_name    
        CostCenter  = "ProductionDR"    
        Owner       = "ProdOps"    
        Region      = var.secondary_location  
    }
}

# Primary Region Resources
module "resource_group_primary" {  
    source = "../../modules/resource-group"  
    name     = local.resource_group_name  
    location = var.location  
    tags     = local.common_tags
}

module "static_web_app_primary" {  
    source              = "../../modules/static-web-app"  
    name                = local.static_web_app_name  
    resource_group_name = module.resource_group_primary.name  
    location            = module.resource_group_primary.location  
    sku_tier            = var.static_web_app_sku_tier  
    sku_size            = var.static_web_app_sku_size  
    tags                = local.common_tags
}

module "storage_account_primary" {  
    source                   = "../../modules/storage-account"  
    name                     = local.storage_account_name  
    resource_group_name      = module.resource_group_primary.name  
    location                 = module.resource_group_primary.location  
    account_tier             = "Standard"  account_replication_type = var.storage_account_replication_type # GZRS for Prod  
    tags                     = local.common_tags
}

# Secondary Region Resources (for Active-Passive DR example)
# In a full active-active setup, these would be identical to primary and Front Door would balance.
# For simplicity, this example shows a "cold" secondary for Static Web App,
# relying on Storage Account GZRS for data replication.
module "resource_group_secondary" {  
    source = "../../modules/resource-group"  
    name     = "${var.project_name}-${var.resource_group_suffix}-dr-rg"  
    location = var.secondary_location  
    tags     = local.secondary_tags
}

# A minimal Static Web App in secondary region, or just the storage account for passive-cold.
# For a full active-passive, you'd deploy another SWA instance here.
# module "static_web_app_secondary" {
#   source              = "../../modules/static-web-app"
#   name                = "${local.static_web_app_name}-dr"
#   resource_group_name = module.resource_group_secondary.name
#   location            = module.resource_group_secondary.location
#   sku_tier            = "Free" # Potentially Free/lower tier for DR
#   sku_size            = "Free"
#   tags                = local.secondary_tags# 
}

module "monitor_diagnostic_setting_prod" {  
    source                       = "../../modules/monitor-diagnostic-setting"  
    log_analytics_workspace_name = "${var.project_name}-${var.environment}-law"  
    resource_group_name          = module.resource_group_primary.name  
    location                     = module.resource_group_primary.location  
    name_prefix                  = "${var.project_name}-${var.environment}"  
    target_resource_ids = {    
        static_web_app  = module.static_web_app_primary.id    
        storage_account = module.storage_account_primary.id  
    }  
    enabled_log_categories =  
    log_retention_days     = 90 # Longer retention for Prod  
    metric_retention_days  = 90  
    subscription_id        = var.subscription_id  
    tags                   = local.common_tags
}

module "prod_budget" {  
    source            = "../../modules/cost-budget"  
    name              = "${var.project_name}-${var.environment}-budget"  
    resource_group_id = module.resource_group_primary.id  
    amount            = var.budget_amount  
    start_date        = formatdate("YYYY-MM-01Z", timestamp())  
    notifications =      
        contact_roles  = ["Owner", "Contributor"]      
        enabled        = true    
    },    
    {      
        threshold      = 80      
        operator       = "GreaterThanOrEqualTo"      
        threshold_type = "Actual"      
        contact_emails = var.budget_contact_email      
        contact_groups =      contact_roles  = ["Owner", "Contributor"]      
        enabled        = true    
    },    
    {      
        threshold      = 100      
        operator       = "GreaterThanOrEqualTo"      
        threshold_type = "Actual"      
        contact_emails = var.budget_contact_email      
        contact_groups =      contact_roles  = ["Owner"]      
        enabled        = true    
    }  
]  

    filter_tags = {    
        Environment = [var.environment]    
        Project     = [var.project_name]  
    }
}

# Example of a critical alert rule for Prod (e.g., Static Web App HTTP 5xx errors)
resource "azurerm_monitor_scheduled_query_rules_alert" "prod_http_error_alert" {  
    name                = "${var.project_name}-${var.environment}-http-error-alert"  
    resource_group_name = module.resource_group_primary.name  
    location            = module.resource_group_primary.location  
    data_source_id      = module.monitor_diagnostic_setting_prod.log_analytics_workspace_id  
    frequency           = 1 # minutes  
    time_window         = 5 # minutes  
    severity            = 1 # Critical severity  
    enabled             = true  
    description         = "Alert for high HTTP 5xx errors on Production Static Web App."  
    query               = <<-EOT    
        AppServiceHTTPLogs
        
| where HttpStatus >= 500 and HttpStatus < 600
| summarize AggregatedValue = count() by bin(TimeGenerated, 1m)
| where AggregatedValue > 10  
    EOT  
    trigger {    
        operator  = "GreaterThan"    
        threshold = 10  
    }  
    action {    
        action_group = # Replace with actual Action Group ID for notifications  
    }  
    tags = local.common_tags
}