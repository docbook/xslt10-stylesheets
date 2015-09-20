<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rng="http://relaxng.org/ns/structure/1.0" 
                version="2.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:for-each-group select="//rng:element[@name]"
		      group-by="@name">
    <xsl:sort select="@name" order="ascending" data-type="text"/>
    <xsl:value-of select="current-grouping-key()"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each-group>
</xsl:template>

</xsl:stylesheet>
