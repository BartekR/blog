@echo off
rem Uses Saxon HE 9.9 .NET version
set SAXONPATH=D:\tools\SaxonHE9.9N\bin

rem extract the layout
powershell ./New-Diagram.ps1 -packagePath DTSX2SVG\Package.dtsx -outputPath Package.Diagram.xml

rem %SAXONPATH%\Transform -s:DTSX2SVG\Package.dtsx -xsl:PackageValues.xsl -o:Package.Values.xml
%SAXONPATH%\Transform -s:Package.Diagram.xml -xsl:package2svg.xsl -o:Package.Diagram.svg packagePath=DTSX2SVG\Package.dtsx
