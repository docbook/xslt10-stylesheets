<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		version="2.0">

<xsl:key name="defs" match="rng:define" use="@name"/>
<xsl:key name="elems" match="rng:element" use="@name"/>

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:for-each-group select="//rng:element[@name]" group-by="@name">
    <xsl:sort data-type="text" select="current-grouping-key()"/>
    <xsl:value-of select="current-grouping-key()"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each-group>
</xsl:template>

</xsl:stylesheet>
