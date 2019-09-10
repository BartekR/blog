# Uses Saxon HE 9.9 .NET version
$SAXONPATH = 'D:\tools\SaxonHE9.9N\bin'

# extract the layout
./New-Diagram.ps1 -packagePath DTSX2SVG\PackageWithDFT.dtsx -outputPath PackageWithDFT.Diagram.xml

& $SAXONPATH\Transform -s:PackageWithDFT.Diagram.xml -xsl:package2svg.xsl -o:PackageWithDFT.Diagram.svg packagePath=DTSX2SVG\PackageWithDFT.dtsx
& $SAXONPATH\Transform -s:PackageWithDFT.Diagram.xml -xsl:taskhost2svg.xsl -o:PackageWithDFT.TaskHost.Diagram.svg packagePath=DTSX2SVG\PackageWithDFT.dtsx
