resource "azurerm_log_analytics_workspace" "main" {  
    name                = var.log_analytics_workspace_name  resource_group_name = var.resource_group_name  
    location            = var.location  
    sku                 = "PerGB2018" # Cost-effective SKU for Log Analytics  
    tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "resource_logs" {  
    for_each           = var.target_resource_ids  
    name               = "${var.name_prefix}-${each.key}-diagnostic-setting"  
    target_resource_id = each.value  
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id  
    log_analytics_destination_type = "Dedicated" # [9]  
    
    dynamic "enabled_log" {    
        for_each = var.enabled_log_categories    
        content {      
            category = enabled_log.value      
            retention_policy {        
                enabled = true        
                days    = var.log_retention_days      
            } 
       }  
    }  
    
    metric {    
        category = "AllMetrics"    
        retention_policy {      
            enabled = true      
            days    = var.metric_retention_days    
        } 
     }
}
    
# Example for Activity Log export to the same Log Analytics workspace
resource "azurerm_monitor_diagnostic_setting" "activity_log" {  
    name                       = "${var.name_prefix}-activity-log-diagnostic-setting"  
    scope                      = "/subscriptions/${var.subscription_id}"  
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id  
    log_analytics_destination_type = "Dedicated" # [9]  
        
    enabled_log {    
        category = "Administrative"    
        retention_policy {      
            enabled = true      
            days    = var.log_retention_days    
        } 
    }  
    enabled_log {    
        category = "Security"    
        retention_policy {      
            enabled = true      
            days    = var.log_retention_days    
        }  
    }  # Add other categories as needed: Alert, Autoscale, Audit, etc.  # [10, 36]
}
    
output "log_analytics_workspace_id" {  
    value       = azurerm_log_analytics_workspace.main.id  
    description = "The ID of the Log Analytics Workspace."
}