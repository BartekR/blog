# variable moved to secret.variables.tf (and secret.variables.tf is added to .gitignore)
# uncomment and set <your-subscription-id>
# variable azure_subscription_id {
#     type        = string
#     default     = "<your-subscription-id>"
#     description = "Azure Subscription Id"
# }

variable resource_group_name {
    type        = string
    default     = "AzureDevOps-RG"
    description = "The resource group holding all elements"
}

variable resource_group_location {
    type        = string
    default     = "North Europe"
    description = "The resource group location"
}