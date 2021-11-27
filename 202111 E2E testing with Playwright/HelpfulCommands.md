# Helpful commands

## Running tests

Run exactly this one test: `dotnet test --filter "FullyQualifiedName=BlazorApp.Tests.FetchDataPageTests.PageContains5RowsTable"`

Run exactly this one test, and skip the build phase: `dotnet test --no-build --filter "FullyQualifiedName=BlazorApp.Tests.FetchDataPageTests.PageContains5RowsTable"`

Run all tests from the test class: `dotnet test --filter "FullyQualifiedName~BlazorApp.Tests.FetchDataPageTests"`

## PowerShell

Set environment variable: `$env:VARIABLE = 1`

Unset environment variable: `[Environment]::SetEnvironmentVariable("VARIABLE", $null)`
