locals {  
    resource_group_name = "${var.project_name}-${var.resource_group_suffix}-rg"  
    static_web_app_name = "${var.project_name}-${var.environment}-swa"  
    storage_account_name = "${replace(lower(var.project_name), "-", "")}${var.environment}st" # Storage account names must be globally unique and lowercase  
    common_tags = {    
        Environment = var.environment    
        Project     = var.project_name    
        CostCenter  = "DevOps"    
        Owner       = "DevTeam"    
        Region      = var.location  
    }
}

module "resource_group" {  
    source = "../../modules/resource-group"  
    name     = local.resource_group_name  
    location = var.location  
    tags     = local.common_tags
}

module "static_web_app" {  
    source              = "../../modules/static-web-app"  
    name                = local.static_web_app_name  resource_group_name = module.resource_group.name  
    location            = module.resource_group.location  
    sku_tier            = var.static_web_app_sku_tier  
    sku_size            = var.static_web_app_sku_size  
    tags                = local.common_tags
}

module "storage_account" {  
    source                   = "../../modules/storage-account"  
    name                     = local.storage_account_name  
    resource_group_name      = module.resource_group.name  
    location                 = module.resource_group.location  
    account_tier             = "Standard"  
    account_replication_type = var.storage_account_replication_type  
    tags                     = local.common_tags
}

module "monitor_diagnostic_setting" {  
    source                       = "../../modules/monitor-diagnostic-setting"  
    log_analytics_workspace_name = "${var.project_name}-${var.environment}-law"  
    resource_group_name          = module.resource_group.name  
    location                     = module.resource_group.location  
    name_prefix                  = "${var.project_name}-${var.environment}"  
    target_resource_ids = {    
        static_web_app  = module.static_web_app.id    
        storage_account = module.storage_account.id  
    }  
    enabled_log_categories = # Example categories  
    log_retention_days     = 7 # Shorter retention for Dev  
    metric_retention_days  = 7  
    subscription_id        = var.subscription_id  
    tags                   = local.common_tags
}

module "dev_budget" {  
    source            = "../../modules/cost-budget"  
    name              = "${var.project_name}-${var.environment}-budget"  
    resource_group_id = module.resource_group.id  
    amount            = var.budget_amount  
    start_date        = formatdate("YYYY-MM-01Z", timestamp()) # Start of current month  
    notifications =      
        contact_roles  = ["Owner"]      
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

# Example of an alert rule for Dev (e.g., high activity log errors)
resource "azurerm_monitor_scheduled_query_rules_alert" "dev_error_alert" {  
    name                = "${var.project_name}-${var.environment}-error-alert"  
    resource_group_name = module.resource_group.name  
    location            = module.resource_group.location  
    data_source_id      = module.monitor_diagnostic_setting.log_analytics_workspace_id  
    frequency           = 5 # minutes  
    time_window         = 5 # minutes  
    severity            = 3 # [11]  
    enabled             = true  
    description         = "Alert for high errors in Dev environment activity logs."  
    query               = <<-EOT    
        AzureActivity
    
    | where Level == "Error"
    | summarize AggregatedValue = count() by bin(TimeGenerated, 5m)
    | where AggregatedValue > 5  
        EOT  
        trigger {    
            operator  = "GreaterThan"    
            threshold = 5  
        }  
        action {    
            action_group = # Replace with actual Action Group ID for notifications  
        }  
        tags = local.common_tags
        }