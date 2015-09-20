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

<!-- Detect multiple platterns that define the same GI -->

<xsl:key name="gi" match="dtx:element" use="@gi"/>

<xsl:template match="dtx:element[@gi]">
  <xsl:variable name="gi" select="@gi"/>
  <xsl:variable name="gis" select="key('gi', @gi)"/>

  <xsl:choose>
    <xsl:when test="count($gis) = 1">
      <xsl:next-match/>
    </xsl:when>
    <xsl:when test="preceding-sibling::dtx:element[@gi = $gi]">
      <xsl:next-match/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Duplicate patterns for <xsl:value-of select="$gi"/></xsl:message>
      <xsl:next-match/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
