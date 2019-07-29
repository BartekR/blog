<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gl="clr-namespace:Microsoft.SqlServer.IntegrationServices.Designer.Model.Serialization;assembly=Microsoft.SqlServer.IntegrationServices.Graph"
  xmlns:mssgle="clr-namespace:Microsoft.SqlServer.Graph.LayoutEngine;assembly=Microsoft.SqlServer.Graph"
  xmlns:mssgm="clr-namespace:Microsoft.SqlServer.Graph.Model;assembly=Microsoft.SqlServer.Graph"
  xmlns:DTS="www.microsoft.com/SqlServer/Dts"
>

  <!-- passed form commandline, like: %SAXONPATH%\Transform -s:Package.Diagram.xml -xsl:package2svg.xsl -o:Package.Diagram.svg packagePath=DTSX2SVG\Package.dtsx -->
  <xsl:param name="packagePath" as="xs:string" required="yes" />
  <xsl:variable name="packageContent" select="document($packagePath)" ></xsl:variable>

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
      
  <xsl:template match="/Objects">
    
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox = "0 0 2100 600"
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
        <xsl:apply-templates select="gl:NodeLayout" />
        <xsl:apply-templates select="gl:EdgeLayout" />
        <xsl:apply-templates select="gl:AnnotationLayout" />
    </xsl:template>

  <xsl:template match="gl:ContainerLayout">

    <xsl:comment><xsl:value-of select="@Id" /></xsl:comment>
    <!-- <xsl:comment><xsl:value-of select="concat('TopLeft:', @TopLeft)" /></xsl:comment> -->

    <xsl:variable name="IdTokens" select="tokenize(@Id, '\\')" />
    <!-- get all possible @Id combinations for parent sequences -->
    <xsl:variable name="IdPaths" select="for $x in (2 to count($IdTokens)) return string-join(subsequence($IdTokens, 1, $x), '\')" />

    <xsl:comment><xsl:value-of select="$IdPaths" separator=":" /></xsl:comment>

    <!-- select only nodes with @Id from the list -->
    <xsl:variable name="paths" as="node()*">
      <xsl:sequence select="following-sibling::gl:ContainerLayout[@Id=$IdPaths]" />
    </xsl:variable>

    <!-- <xsl:comment><xsl:value-of select="$paths/@TopLeft" separator="*"  /></xsl:comment> -->

    <xsl:comment>
      <xsl:value-of select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ',')))" />,<xsl:value-of select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ',')))" />
    </xsl:comment>

    <xsl:variable name="x0" select="number(substring-before(@TopLeft, ','))" />
    <xsl:variable name="y0" select="number(substring-after(@TopLeft, ','))" />

    <xsl:variable name="x" select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ','))) + $x0" />
    <xsl:variable name="y" select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ','))  + number($p/@HeaderHeight)) + $y0" />

    <g xmlns="http://www.w3.org/2000/svg">

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y)"/></xsl:attribute>
            <xsl:attribute name="rx">3</xsl:attribute>
            <xsl:attribute name="ry">3</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="fill">none</xsl:attribute>
            <xsl:attribute name="stroke">black</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y)"/></xsl:attribute>
            <xsl:attribute name="rx">3</xsl:attribute>
            <xsl:attribute name="ry">3</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="@HeaderHeight"/></xsl:attribute>
            <xsl:attribute name="fill">white</xsl:attribute>
            <xsl:attribute name="stroke">green</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

        <text>
            <xsl:attribute name="x"><xsl:value-of select="number($x) + 5"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y) + number(@HeaderHeight) div 2 +  6"/></xsl:attribute>
            <xsl:attribute name="fill">black</xsl:attribute>
            <xsl:attribute name="font-family">Verdana</xsl:attribute>
            <xsl:attribute name="font-size">12</xsl:attribute>
            <xsl:value-of select="$IdTokens[last()]"/>
        </text>

    </g>

  </xsl:template>

  <xsl:template match="gl:NodeLayout">

    <xsl:variable name="IdTokens" select="tokenize(@Id, '\\')" />
    <!-- get all possible @Id combinations for parent sequences -->
    <xsl:variable name="IdPaths" select="for $x in (2 to count($IdTokens)) return string-join(subsequence($IdTokens, 1, $x), '\')" />

    <xsl:comment><xsl:value-of select="$IdPaths" separator=":" /></xsl:comment>

    <!-- select only nodes with @Id from the list -->
    <xsl:variable name="paths" as="node()*">
      <xsl:sequence select="following-sibling::gl:ContainerLayout[@Id=$IdPaths]" />
    </xsl:variable>

    <xsl:variable name="x0" select="number(substring-before(@TopLeft, ','))" />
    <xsl:variable name="y0" select="number(substring-after(@TopLeft, ','))" />

    <xsl:variable name="x" select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ','))) + $x0" />
    <xsl:variable name="y" select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ','))  + number($p/@HeaderHeight)) + $y0" />


    <g xmlns="http://www.w3.org/2000/svg">

        <rect>
            <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y)"/></xsl:attribute>
            <xsl:attribute name="rx">5</xsl:attribute>
            <xsl:attribute name="ry">5</xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
            <xsl:attribute name="fill">white</xsl:attribute>
            <xsl:attribute name="stroke">black</xsl:attribute>
            <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

        <text>
            <xsl:attribute name="x"><xsl:value-of select="number($x) + 5"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="number($y) + (number(substring-after(@Size, ',')) div 2) + 7"/></xsl:attribute>
            <xsl:attribute name="fill">black</xsl:attribute>
            <xsl:attribute name="font-family">Verdana</xsl:attribute>
            <xsl:attribute name="font-size">12</xsl:attribute>
            <xsl:value-of select="$IdTokens[last()]"/>
        </text>

    </g>

  </xsl:template>

  <xsl:template match="gl:EdgeLayout">

    <!-- workaround - later I need to use @Id (an attribute) as a filter and it doesn't work; works when I use $localId (a variable); I don't know why-->
    <xsl:variable name="localId" select="@Id" />

    <!-- edges have information about PrecedenceConstraint in the @ID, so I remove it -->
    <xsl:variable name="ParsedId" select="substring-before(@Id, '.PrecedenceConstraints')" />
    <xsl:variable name="IdTokens" select="tokenize($ParsedId, '\\')" />
    <!-- get all possible @Id combinations for parent sequences -->
    <xsl:variable name="IdPaths" select="for $x in (2 to count($IdTokens)) return string-join(subsequence($IdTokens, 1, $x), '\')" />

    <xsl:comment><xsl:value-of select="$IdPaths" separator=":" /></xsl:comment>

    <!-- select only nodes with @Id from the list -->
    <xsl:variable name="paths" as="node()*">
      <xsl:sequence select="following-sibling::gl:ContainerLayout[@Id=$IdPaths]" />
    </xsl:variable>

    <xsl:comment><xsl:value-of select="$paths/@Id" separator="*"  /></xsl:comment>

    <xsl:variable name="x0" select="number(substring-before(@TopLeft, ','))" />
    <xsl:variable name="y0" select="number(substring-after(@TopLeft, ','))" />

    <xsl:variable name="x" select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ','))) + $x0" />
    <xsl:variable name="y" select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ','))  + number($p/@HeaderHeight)) + $y0" />

    
    <g xmlns="http://www.w3.org/2000/svg">

        <xsl:comment><xsl:value-of select="concat('element: ', @Id)" /></xsl:comment>
        <xsl:comment><xsl:value-of select="concat('offsetX: ', number($x) - number($x0))" /></xsl:comment>
        <xsl:comment><xsl:value-of select="concat('offsetY: ', number($y) - number($y0))" /></xsl:comment>

        <xsl:choose>
          <xsl:when test="count(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment) gt 0">
            <!-- arc option -->

            <line>
              <xsl:attribute name="x1"><xsl:value-of select="number($x)"/></xsl:attribute>
              <xsl:attribute name="y1"><xsl:value-of select="number($y)"/></xsl:attribute>
              <xsl:attribute name="style">stroke:#006600</xsl:attribute>
              <xsl:attribute name="x2"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[1]/@End, ','))"/></xsl:attribute>
              <xsl:attribute name="y2"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[1]/@End, ','))"/></xsl:attribute>
            </line>

            <path>
              <xsl:attribute name="d">
                  <xsl:value-of select="concat('M', number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point1, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point1, ',')))"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="concat('Q', number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point2, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point2, ',')))"/> 
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="concat(number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point3, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point3, ',')))"/> 
              </xsl:attribute>
              <xsl:attribute name="style">stroke:#006600; fill:none</xsl:attribute>
            </path>

            <line>
              <xsl:attribute name="x1"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point3, ','))"/></xsl:attribute>
              <xsl:attribute name="y1"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[1]/@Point3, ','))"/></xsl:attribute>
              <xsl:attribute name="style">stroke:#006600</xsl:attribute>
              <xsl:attribute name="x2"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[2]/@End, ','))"/></xsl:attribute>
              <xsl:attribute name="y2"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[2]/@End, ','))"/></xsl:attribute>
            </line>

            <path>
              <xsl:attribute name="d">
                  <xsl:value-of select="concat('M', number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point1, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point1, ',')))"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="concat('Q', number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point2, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point2, ',')))"/> 
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="concat(number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point3, ',')), ',', number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point3, ',')))"/> 
              </xsl:attribute>
              <xsl:attribute name="style">stroke:#006600; fill:none</xsl:attribute>
            </path>

            <line>
              <xsl:attribute name="x1"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point3, ','))"/></xsl:attribute>
              <xsl:attribute name="y1"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:CubicBezierSegment[2]/@Point3, ','))"/></xsl:attribute>
              <xsl:attribute name="style">stroke:#006600</xsl:attribute>
              <xsl:attribute name="x2"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[3]/@End, ','))"/></xsl:attribute>
              <xsl:attribute name="y2"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/mssgle:Curve.Segments/mssgle:SegmentCollection/mssgle:LineSegment[3]/@End, ','))"/></xsl:attribute>
            </line>
          </xsl:when>

          <xsl:otherwise>
            <!-- straight line option -->
            <line>
                <xsl:attribute name="x1"><xsl:value-of select="number($x)"/></xsl:attribute>
                <xsl:attribute name="y1"><xsl:value-of select="number($y)"/></xsl:attribute>
                <xsl:attribute name="style">stroke:#006600</xsl:attribute>
                <xsl:attribute name="x2"><xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/></xsl:attribute>
                <xsl:attribute name="y2"><xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/></xsl:attribute>
            </line>
          </xsl:otherwise>
        </xsl:choose>

        <polygon>
          <xsl:attribute name="points">
              <xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ',')) - 3"/>,<xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@End, ',')) + 3"/>,<xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@End, ','))"/> 
              <xsl:text> </xsl:text>
              <xsl:value-of select="number($x) + number(substring-before(gl:EdgeLayout.Curve/mssgle:Curve/@EndConnector, ','))"/>,<xsl:value-of select="number($y) + number(substring-after(gl:EdgeLayout.Curve/mssgle:Curve/@EndConnector, ','))"/>
          </xsl:attribute>
          <xsl:attribute name="style">stroke:#006600; fill:#006600</xsl:attribute>
        </polygon>

        <!-- rectangle with precedence constraint's text (for testing) -->
        <xsl:variable name="BoundingBox" select="tokenize(gl:EdgeLayout.Labels/mssgm:EdgeLabel/@BoundingBox, ',')" />

        <!-- text for the precedence constraint -->
        <xsl:variable name="annotationType" select="/Objects/PrecedenceConstraint[@design-time-name=$localId]/ShowAnnotation" />

        <xsl:variable name="precedenceConstraintValue">
          <xsl:choose>
            <xsl:when test="$annotationType eq 'ConstraintOptions'">
              <xsl:value-of select="concat(
                                      $packageContent//DTS:PrecedenceConstraint[@DTS:refId=$localId]/@DTS:EvalOp,
                                      ' and ',
                                      $packageContent//DTS:PrecedenceConstraint[@DTS:refId=$localId]/@DTS:Expression
                                    )
              " />
            </xsl:when>
            <xsl:when test="$annotationType eq 'ConstraintDescription'"><xsl:value-of select="$packageContent//DTS:PrecedenceConstraint[@DTS:refId=$localId]/@DTS:Description" /></xsl:when>
            <xsl:when test="$annotationType eq 'ConstraintName'"><xsl:value-of select="$packageContent//DTS:PrecedenceConstraint[@DTS:refId=$localId]/@DTS:ObjectName" /></xsl:when>
            <!-- <xsl:when test="$annotationType -eq 'AsNeeded'"></xsl:when> -->
          </xsl:choose>
        </xsl:variable>
        <xsl:comment><xsl:value-of select="concat('$annotationType: ', $annotationType, ' | $precedenceConstraintValue: ', $precedenceConstraintValue)" /></xsl:comment>

        <rect>
          <xsl:attribute name="x"><xsl:value-of select="number($x) + number($BoundingBox[1])"/></xsl:attribute>
          <xsl:attribute name="y"><xsl:value-of select="number($y) + number($BoundingBox[2])"/></xsl:attribute>
          <xsl:attribute name="width"><xsl:value-of select="number($BoundingBox[3])"/></xsl:attribute>
          <xsl:attribute name="height"><xsl:value-of select="number($BoundingBox[4])"/></xsl:attribute>
          <xsl:attribute name="fill">none</xsl:attribute>
          <xsl:attribute name="stroke">red</xsl:attribute>
          <xsl:attribute name="stroke-width">1</xsl:attribute>
        </rect>

    </g>

  </xsl:template>

  <xsl:template match="gl:AnnotationLayout">

    <xsl:variable name="IdTokens" select="tokenize(@ParentId, '\\')" />
    <!-- get all possible @Id combinations for parent sequences -->
    <xsl:variable name="IdPaths" select="for $x in (2 to count($IdTokens)) return string-join(subsequence($IdTokens, 1, $x), '\')" />

    <xsl:comment><xsl:value-of select="$IdPaths" separator=":" /></xsl:comment>

    <!-- select only nodes with @Id from the list -->
    <xsl:variable name="paths" as="node()*">
      <xsl:sequence select="following-sibling::gl:ContainerLayout[@Id=$IdPaths]" />
    </xsl:variable>

    <xsl:variable name="x0" select="number(substring-before(@TopLeft, ','))" />
    <xsl:variable name="y0" select="number(substring-after(@TopLeft, ','))" />

    <xsl:variable name="x" select="sum(for $p in $paths return number(substring-before($p/@TopLeft, ','))) + $x0" />
    <xsl:variable name="y" select="sum(for $p in $paths return number(substring-after($p/@TopLeft, ','))  + number($p/@HeaderHeight)) + $y0" />

    <g xmlns="http://www.w3.org/2000/svg">
      <text>
        <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
        <xsl:attribute name="y"><xsl:value-of select="number($y) + (number(substring-after(@Size, ',')) div 2)"/></xsl:attribute>
        <xsl:attribute name="fill">black</xsl:attribute>
        <xsl:attribute name="font-family">Verdana</xsl:attribute>
        <xsl:attribute name="font-size">12</xsl:attribute>
        <xsl:value-of select="@Text"/>
      </text>

      <rect>
        <xsl:attribute name="x"><xsl:value-of select="number($x)"/></xsl:attribute>
        <xsl:attribute name="y"><xsl:value-of select="number($y)"/></xsl:attribute>
        <xsl:attribute name="width"><xsl:value-of select="substring-before(@Size, ',')"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="substring-after(@Size, ',')"/></xsl:attribute>
        <xsl:attribute name="fill">none</xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
        <xsl:attribute name="stroke-width">1</xsl:attribute>
      </rect>
    </g>
  </xsl:template>

</xsl:stylesheet>