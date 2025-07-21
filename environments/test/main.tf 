locals {  
    resource_group_name = "${var.project_name}-${var.resource_group_suffix}-rg"  
    static_web_app_name = "${var.project_name}-${var.environment}-swa"  
    storage_account_name = "${replace(lower(var.project_name), "-", "")}${var.environment}st"  
    common_tags = {    
        Environment = var.environment    
        Project     = var.project_name    
        CostCenter  = "DevOps"    
        Owner       = "QATeam"    
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
    name                = local.static_web_app_name  
    resource_group_name = module.resource_group.name  
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
    account_replication_type = var.storage_account_replication_type # ZRS for Test  
    tags                     = local.common_tags
}

module "monitor_diagnostic_setting" {  
    source                       = "../../modules/monitor-diagnostic-setting"  
    log_analytics_workspace_name = "${var.project_name}-${var.environment}-law"  
    resource_group_name          = module.resource_group.name  
    location                     = module.resource_group.location  
    name_prefix                  = "${var.project_name}-${var.environment}"  
    target_resource_ids = {    
        static_web_app  = module.static_web_app.id    s
        torage_account = module.storage_account.id  
    }  
    enabled_log_categories =  
    log_retention_days     = 14 # Longer retention for Test  
    metric_retention_days  = 14  
    subscription_id        = var.subscription_id  
    tags                   = local.common_tags
}

module "test_budget" {  
    source            = "../../modules/cost-budget"  
    name              = "${var.project_name}-${var.environment}-budget"  
    resource_group_id = module.resource_group.id  
    amount            = var.budget_amount  
    start_date        = formatdate("YYYY-MM-01Z", timestamp())  
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

# Example of an alert rule for Test (e.g., availability test for Static Web App)
resource "azurerm_application_insights_web_test" "test_swa_availability" {  
    name                     = "${var.project_name}-${var.environment}-swa-availability"  
    resource_group_name      = module.resource_group.name  
    location                 = module.resource_group.location  
    # Note: Application Insights resource is usually separate or part of a larger monitoring deployment.  
    # For this example, we'll link to the Log Analytics Workspace ID for conceptual purposes,  
    # but a dedicated Application Insights resource would be preferred for full web tests.  
    application_insights_id  = module.monitor_diagnostic_setting.log_analytics_workspace_id # Link to Log Analytics for metrics  
    kind                     = "ping" # [13]  
    frequency                = 5      # minutes  
    timeout                  = 30     # seconds  
    geo_locations            = ["us-tx-sn1-azr", "us-il-ch1-azr"] # Example locations  
    enabled                  = true  
    # web_app_id is not a direct argument for azurerm_application_insights_web_test,  
    # the URL is used in the request block.  
    tags                     = local.common_tags  
    
    request {    
        url = "https://${module.static_web_app.default_host_name}"  
    }
}

resource "azurerm_monitor_metric_alert" "test_swa_unavailability_alert" {  
    name                = "${var.project_name}-${var.environment}-swa-unavailability-alert"  
    resource_group_name = module.resource_group.name  
    scopes              = [azurerm_application_insights_web_test.test_swa_availability.id] # [37] (conceptually applies)  
    description         = "Alert when Test Static Web App becomes unavailable based on availability test."  
    severity            = 2 # Warning severity  
    enabled             = true  
    
    criteria {    
        metric_namespace = "microsoft.insights/webtests"    
        metric_name      = "AvailabilityResults/AvailabilityPercentage"    
        aggregation      = "Average"    
        operator         = "LessThan"    
        threshold        = 100    
        dimension {      
            name     = "TestName"      
            operator = "Include"      
            values   = [azurerm_application_insights_web_test.test_swa_availability.name]    
        }  
    }  
    action {    
        action_group_id = "" # Replace with actual Action Group ID for notifications  
    }  
    tags = local.common_tags
}