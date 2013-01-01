<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kml="http://www.opengis.net/kml/2.2"
>
<!-- ***NOT USED FILE *** KML to KML conversion      -->
<!-- ***To Simplify KML file Perl script is used now -->

<xsl:output method="xml" indent='yes'/>

<xsl:param name='FileName' select="'??????'"/>

<xsl:template match="/">

<!-- ;; http://www.jonmiles.co.uk/2007/07/using-xpaths-text-function/ ;; -->

<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
<Document>
<Folder>
  <name>Waypoints</name>
  <xsl:for-each select="//kml:Folder[kml:name/text()='Waypoints']/kml:Placemark//kml:Point">
     <Placemark>
        <name><xsl:value-of select='../kml:name'/></name>
        <description>&lt;![CDATA[
	<xsl:value-of disable-output-escaping='yes' select='../kml:description/text()'/>
	]]&gt;</description>
        <Point><coordinates>
            <xsl:value-of select="kml:coordinates"/>
	  </coordinates>
        </Point>
     </Placemark>
  </xsl:for-each>
</Folder>

 <Folder> <name>Tracks</name> <Folder>
  <Placemark>
   <name>Path</name>

   <MultiGeometry><LineString>
   <tessellate>1</tessellate>
   <coordinates>

    <xsl:for-each select="//kml:Placemark//kml:LineString">
      <xsl:value-of select="kml:coordinates"/>

    </xsl:for-each>

   </coordinates>
</LineString></MultiGeometry></Placemark>

</Folder> </Folder>

</Document>
</kml>

</xsl:template>
</xsl:stylesheet>
