<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                version="1.0">

<!-- This stylesheet is just used for debugging, it reports what definitions
     are referenced but undefined or defined but unused in a particular grammar
     module. For the final grammar, it shouldn't print anything. -->

<xsl:output method="text"/>

<xsl:key name="defines" match="rng:define" use="@name"/>
<xsl:key name="refs" match="rng:ref" use="@name"/>

<xsl:template match="/">
  <xsl:for-each select="//rng:ref">
    <xsl:variable name="name" select="@name"/>
    <xsl:if test="not(preceding::rng:ref[@name=$name])">
      <xsl:if test="not(key('defines', $name))">
        <xsl:text>Missing define: </xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <xsl:for-each select="//rng:define">
    <xsl:variable name="name" select="@name"/>
    <xsl:if test="not(preceding::rng:define[@name=$name])">
      <xsl:if test="not(key('refs', $name)) and not(rng:element)">
        <xsl:text>Unreferenced: </xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
