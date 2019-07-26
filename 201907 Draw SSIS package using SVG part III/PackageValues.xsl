<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:DTS="www.microsoft.com/SqlServer/Dts"
>

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">
    <xsl:apply-templates select="DTS:Executable/DTS:Executables/DTS:Executable" />
  </xsl:template>

  <xsl:template match="DTS:Executable">
    <PrecedenceConstraints>
      <xsl:for-each select="descendant::DTS:PrecedenceConstraint">
        <!-- <refId><xsl:value-of select="@DTS:refId" /></refId> -->
        <xsl:copy-of select="." />
      </xsl:for-each>
    </PrecedenceConstraints>
  </xsl:template>

</xsl:stylesheet>