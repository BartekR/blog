<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

  <xsl:output
      method="xml"
      encoding="UTF-8"
      indent="yes" />

  <xsl:template match="/Objects">

    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox = "0 0 1000 600"
    >

      <xsl:apply-templates select="Package" />

    </svg>

  </xsl:template>

    <xsl:template match="Package">
        <xsl:apply-templates select="LayoutInfo" />
    </xsl:template>

    <xsl:template match="LayoutInfo">
        <xsl:apply-templates select="GraphLayout" />
    </xsl:template>

    <xsl:template match="GraphLayout">
        <xsl:apply-templates select="NodeLayout" />
    </xsl:template>

  <xsl:template match="NodeLayout">

    <g xmlns="http://www.w3.org/2000/svg">

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="substring-before(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="substring-after(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="rx">10</xsl:attribute>
            <xsl:attribute name="ry">10</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="fill">lightgray</xsl:attribute>
            <xsl:attribute name="stroke">black</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

    </g>

  </xsl:template>

</xsl:stylesheet>