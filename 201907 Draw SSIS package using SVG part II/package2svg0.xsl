<!-- steps to draw a sketch of the sequence containers (no headers)  -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gl="clr-namespace:Microsoft.SqlServer.IntegrationServices.Designer.Model.Serialization;assembly=Microsoft.SqlServer.IntegrationServices.Graph"
  xmlns:mssgle="clr-namespace:Microsoft.SqlServer.Graph.LayoutEngine;assembly=Microsoft.SqlServer.Graph"
>

  <xsl:output
      method="xml"
      encoding="UTF-8"
      indent="yes" />
      
  <xsl:template match="/Objects">

    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox = "0 0 1600 1600"
    >
      <rect width="100%" height="100%" fill="lightgray"/>

      <xsl:apply-templates select="Package" />

    </svg>

  </xsl:template>

    <xsl:template match="Package">
        <xsl:apply-templates select="LayoutInfo" />
    </xsl:template>

    <xsl:template match="LayoutInfo">
        <xsl:apply-templates select="gl:GraphLayout" />
    </xsl:template>

    <xsl:template match="gl:GraphLayout">
        <xsl:apply-templates select="gl:ContainerLayout" />
        <!-- <xsl:apply-templates select="gl:NodeLayout" />
        <xsl:apply-templates select="gl:EdgeLayout" />
        <xsl:apply-templates select="gl:AnnotationLayout" /> -->
    </xsl:template>

  <xsl:template match="gl:ContainerLayout">

    <xsl:comment><xsl:value-of select="@Id" /></xsl:comment>
    <!-- <xsl:comment><xsl:value-of select="concat('TopLeft:', @TopLeft)" /></xsl:comment> -->

    <xsl:variable name="IdTokens" select="tokenize(@Id, '\\')" />
    <!-- get all possible @Id combinations for parent sequences -->
    <xsl:variable name="paths3" select="for $x in (1 to count($IdTokens)) return string-join(subsequence($IdTokens, 1, $x), '\')" />

    <xsl:comment><xsl:value-of select="$paths3" separator=":" /></xsl:comment>

    <!-- select only nodes with @Id from the list -->
    <xsl:variable name="paths" as="node()*">
      <xsl:sequence select="following-sibling::gl:ContainerLayout[@Id=$paths3]" />
    </xsl:variable>

    <!-- <xsl:comment><xsl:value-of select="$paths/@TopLeft" separator="*"  /></xsl:comment> -->

    <xsl:comment>
      <xsl:value-of select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ',')))" />,<xsl:value-of select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ',')))" />
    </xsl:comment>

    <xsl:variable name="x0" select="number(substring-before(@TopLeft, ','))" />
    <xsl:variable name="y0" select="number(substring-after(@TopLeft, ','))" />

    <xsl:variable name="x" select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ','))) + $x0" />
    <xsl:variable name="y" select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ','))) + $y0" />

    <g xmlns="http://www.w3.org/2000/svg">

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y)"/></xsl:attribute>
            <xsl:attribute name="rx">10</xsl:attribute>
            <xsl:attribute name="ry">10</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="fill">none</xsl:attribute>
            <xsl:attribute name="stroke">black</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

    </g>

  </xsl:template>

  <xsl:template match="gl:NodeLayout">

    <xsl:variable name="nodeNameTokens" select="tokenize(@Id, '\\')" />

    <g xmlns="http://www.w3.org/2000/svg">

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="substring-before(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="substring-after(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="rx">10</xsl:attribute>
            <xsl:attribute name="ry">10</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="fill">white</xsl:attribute>
            <xsl:attribute name="stroke">black</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

        <text>
            <xsl:attribute name="x"><xsl:value-of select="number(substring-before(@TopLeft, ',')) + 5"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number(substring-after(@TopLeft, ',')) + (number(substring-after(@Size, ',')) div 2) + 7"/></xsl:attribute>
            <xsl:attribute name="fill">black</xsl:attribute>
            <xsl:attribute name="font-family">Verdana</xsl:attribute>
            <xsl:attribute name="font-size">12</xsl:attribute>
            <xsl:value-of select="$nodeNameTokens[last()]"/>
        </text>

    </g>

  </xsl:template>

  <xsl:template match="gl:EdgeLayout">
    
    <g xmlns="http://www.w3.org/2000/svg">

        <line>
            <xsl:attribute name="x1"><xsl:value-of select="substring-before(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="y1"><xsl:value-of select="substring-after(@TopLeft, ',')"/></xsl:attribute>
            <xsl:attribute name="style">stroke:#006600</xsl:attribute>
            <xsl:attribute name="x2"><xsl:value-of select="number(substring-before(@TopLeft, ',')) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/></xsl:attribute>
            <xsl:attribute name="y2"><xsl:value-of select="number(substring-after(@TopLeft, ',')) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/></xsl:attribute>
        </line>

        <polygon>
            <xsl:attribute name="points">
                <xsl:value-of select="number(substring-before(@TopLeft, ',')) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ',')) - 3"/>,<xsl:value-of select="number(substring-after(@TopLeft, ',')) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="number(substring-before(@TopLeft, ',')) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ',')) + 3"/>,<xsl:value-of select="number(substring-after(@TopLeft, ',')) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/> 
                <xsl:text> </xsl:text>
                <xsl:value-of select="number(substring-before(@TopLeft, ',')) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@EndConnector, ','))"/>,<xsl:value-of select="number(substring-after(@TopLeft, ',')) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@EndConnector, ','))"/>
            </xsl:attribute>
            <xsl:attribute name="style">stroke:#006600; fill:#006600</xsl:attribute>
        </polygon>

    </g>

  </xsl:template>

  <xsl:template match="gl:AnnotationLayout">

    <g xmlns="http://www.w3.org/2000/svg">
      <text>
        <xsl:attribute name="x"><xsl:value-of select="number(substring-before(@TopLeft, ','))"/></xsl:attribute>
        <xsl:attribute name="y"><xsl:value-of select="number(substring-after(@TopLeft, ',')) + (number(substring-after(@Size, ',')) div 2)"/></xsl:attribute>
        <xsl:attribute name="fill">black</xsl:attribute>
        <xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="font-size">12</xsl:attribute>
        <xsl:value-of select="@Text"/>
      </text>

      <rect>
        <xsl:attribute name="x"><xsl:value-of select="substring-before(@TopLeft, ',')"/></xsl:attribute>
        <xsl:attribute name="y"><xsl:value-of select="substring-after(@TopLeft, ',')"/></xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
        <xsl:attribute name="fill">none</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
        <xsl:attribute name="stroke-width">1</xsl:attribute>
      </rect>
    </g>
  </xsl:template>

</xsl:stylesheet>