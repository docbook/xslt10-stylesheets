<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:dtx="http://nwalsh.com/ns/dtd-xml"
                xmlns:f="http://nwalsh.com/functions/dtd-xml"
                xmlns="http://nwalsh.com/ns/dtd-xml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="s a dtx xs f"
                version="2.0">

<xsl:include href="common.xsl"/>

<!-- replace a ref to a pe that contains text with the content of the pe -->

<xsl:key name="pe" match="dtx:pe" use="@name"/>

<xsl:template match="dtx:ref">
  <xsl:variable name="target" select="key('pe', @name)"/>

  <xsl:choose>
    <xsl:when test="$target//dtx:text">
      <xsl:copy-of select="$target/*"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:next-match/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
