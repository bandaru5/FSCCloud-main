variable "name" {  
    description = "The name of the consumption budget."  
    type        = string
}

variable "resource_group_id" {  
    description = "The ID of the Resource Group to create the consumption budget for."  
    type        = string
}

variable "amount" {  
    description = "The total amount of cost to track with the budget."  
    type        = number
}

variable "time_grain" {  
    description = "The time covered by a budget (BillingAnnual, BillingMonth, BillingQuarter, Annually, Monthly, Quarterly)."  
    type        = string  default     = "Monthly" # [17]
}

variable "start_date" {  
    description = "The start date for the budget (YYYY-MM-DD)."  
    type        = string
}

variable "end_date" {  
    description = "The end date for the budget (YYYY-MM-DD)."  
    type        = string  default     = null # [17] (defaults to 10 years after start if not set)
}

variable "notifications" {  
    description = "A list of notification blocks for the budget."  
    type = list(object({    
        threshold      = number    
        operator       = string # EqualTo, GreaterThan, GreaterThanOrEqualTo    
        threshold_type = string # Actual, Forecasted    
        contact_emails = list(string)    
        contact_groups = list(string)    
        contact_roles  = list(string)    
        enabled        = bool  
    }))  
    default =
}

variable "filter_tags" {  
    description = "A map of tags to filter the budget on."  
    type        = map(list(string))  default     = {}
}