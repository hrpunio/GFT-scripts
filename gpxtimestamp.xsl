<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gpx="http://www.topografix.com/GPX/1/0">
<!-- 
  
  Prints Date or time from the first/last 'trkpt' node of GPX document

  xsltproc --param Position '"First"' gpxtimestamp.xsl gpxfile # prints time from first node
  xsltproc --param Position '"First"' --param '"Date"'gpxtimestamp.xsl gpxfile # prints date from first node

  Tomasz Przechlewski, 2012
-->
<xsl:output method="text"/>

<xsl:param name='Position' select="'First'"/>
<xsl:param name='Mode' select="'Time'"/>

<xsl:template match="/" >

<!-- BAD: more than one node returned
  <xsl:for-each select='//gpx:trkpt[position() = $Position]'> -->
<!-- <xsl:for-each select='//gpx:trkpt'>  -->

<xsl:for-each select='//*[local-name()="trkpt"]'> 

  <xsl:if test="position()=1 and $Position='First'">

    <xsl:if test="$Mode='Time'">
       <xsl:value-of select='substring(*[local-name()="time"], 12, 8)'/>
    </xsl:if>
    <xsl:if test="$Mode='Date'">
       <xsl:value-of select='translate(substring(*[local-name()="time"], 1, 10), "-", "")'/>
    </xsl:if>

    <xsl:text>&#10;</xsl:text>

  </xsl:if>

  <xsl:if test="position()=last() and $Position='Last'">

    <!-- <xsl:value-of select='gpx:time'/> -->
    <!-- <xsl:value-of select='*[local-name()="time"]'/> -->
    <xsl:value-of select='substring(*[local-name()="time"], 12, 8)'/>

    <xsl:text>&#10;</xsl:text>

  </xsl:if>
  
</xsl:for-each>
  
</xsl:template>

</xsl:stylesheet>
