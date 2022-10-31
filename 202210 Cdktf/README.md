# Example code for CDKTF

Goal: create CDKTF code that creates Virtual Machine with SQL Server 2019 on Windows (I need SSIS installed).

Additional goal: compare CDKTF and HCL.

## Requirements and installation

- terraform CLI 1.1+
- Node.js 16+ + npm

to check versions:

```powershell
node --version
terraform --version
```

Installation: `npm install --global cdktf-cli@latest`
Installation validation: `cdktf --version`

## Preparing the code (using PowerShell), as of 14.10.2022

```powershell
mkdir vm-ssis
cdktf init --template=csharp --local
# after running above it forces to provide project name, project description and whether to send crash telemetry
```

As the result there is a dotnet project created with:

- `netcoreapp3.1` as target framework version (while version 6 and version 7 are available)
- package references
  - `HashiCorp.Cdktf` 0.13.0
  - `Microsoft.NET.Test.Sdk` 17.2.0
  - `xunit` 2.4.1
  - `xunit.runner.visualstudio` 2.4.5

Adding AzureRm provider: `dotnet add package HashiCorp.Cdktf.Providers.Azurerm`

As a result it adds `HashiCorp.Cdktf.Providers.Azurerm` version 3.0.12 to the package references.

## Directories

- `vm-ssis` - the code to prepare Virtual Machine in Azure using CDKTF
  - `bin`, `cdktf.out`, `obj` folders are excluded in `.gitignore`
  - `*.tfstate` and `*.tfstate.backup` files are excluded in `.gitignore`
  - `vm.create.json` and `vm.json` are files extracted from Azure Portal to check for the syntax Azure uses to create VM, and the JSON configuration for the VM - they are not part of CDKTF
- `vm2` - initial code created using `cdktf init --template=csharp --local`
