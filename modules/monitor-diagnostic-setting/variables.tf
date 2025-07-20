variable "log_analytics_workspace_name" {  
    description = "The name of the Log Analytics Workspace."  
    type        = string
}

variable "resource_group_name" {  
    description = "The resource group for the Log Analytics Workspace."  
    type        = string
}variable "location" {  
    description = "The Azure region for the Log Analytics Workspace."  
    type        = string    
}

variable "name_prefix" {  
    description = "A prefix for diagnostic settings names."  
    type        = string
}

variable "target_resource_ids" {  
    description = "A map of resource names to their IDs for which to enable diagnostic settings."  
    type        = map(string)  default     = {}
}

variable "enabled_log_categories" {  
    description = "A list of log categories to enable for diagnostic settings."  
    type        = list(string)  
    default     = # Common for AAD, adjust per resource type
}

variable "log_retention_days" {  
    description = "Number of days to retain logs."  
    type        = number  
    default     = 30 # [10]
}

variable "metric_retention_days" {  
    description = "Number of days to retain metrics."  
    type        = number  
    default     = 30
}

variable "subscription_id" {  
    description = "The Azure Subscription ID to export activity logs from."  
    type        = string
}

variable "tags" {  
    description = "A map of tags to apply to resources."  
    type        = map(string)  default     = {}
}