# Uses Saxon HE 9.9 .NET version
$SAXONPATH = 'D:\tools\SaxonHE9.9N\bin'

# extract the layout
./New-Diagram.ps1 -packagePath DTSX2SVG\Package.dtsx -outputPath Package.Diagram.xml

& $SAXONPATH\Transform -s:Package.Diagram.xml -xsl:package2svg.xsl -o:Package.Diagram.svg packagePath=DTSX2SVG\Package.dtsx
