# Create Azure Functions; requires Azure CLI and Azure Functions Core Tools

Link: <https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#prerequisites>

I use PowerShell (currently: 7.0.3) as a default shell

```powershell
Set-Location AzureFunctions
func init --worker-runtime powershell --managed-dependencies
```
