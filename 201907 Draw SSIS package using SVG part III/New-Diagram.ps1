param(
    [string] $packagePath,  # Package to draw
    [string] $outputPath    # Where to save the diagram XML
)

# Find <DesignTimeProperties>, CDATA section
$xpath = '/DTS:Executable/DTS:DesignTimeProperties/text()'

# We have a namespace, so add a declaration; just copy the values from the .dtsx file
$namespace = @{DTS = 'www.microsoft.com/SqlServer/Dts'}

# The Command
(Select-Xml -Path $packagePath -XPath $xpath -Namespace $namespace | Select-Object -ExpandProperty Node).Value | Out-File $outputPath

<#
The command explained:

(                                                                       <-- I will find a node, a nd then read its content
    Select-Xml -Path $packagePath -XPath $xpath -Namespace $namespace   <-- Find the element in the $Package using $xpath with $namespace
    | Select-Object -ExpandProperty Node                                <-- I have an object and I want the property 'Node'
).Value                                                                 <-- After I found the Node, I want its Value
| Out-File $outputPath                                                  <-- And save it to the file

#>