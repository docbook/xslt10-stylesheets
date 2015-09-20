<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                version="1.0">

<!-- This stylesheet is just used for debugging, it prints all the patterns -->

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:for-each select="//rng:define">
    <xsl:value-of select="@name"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
