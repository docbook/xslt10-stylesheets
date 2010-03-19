<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:dtx="http://nwalsh.com/ns/dtd-xml"
                xmlns="http://nwalsh.com/ns/dtd-xml"
                exclude-result-prefixes="rng s a dtx"
                version="2.0">

<xsl:include href="common.xsl"/>

<!-- apply the rules in the specified overrride file -->

<xsl:param name="override.xml" required="yes"/>

<xsl:variable name="overrides" select="doc($override.xml)/dtx:dtd"/>

<xsl:key name="name" match="dtx:pe|dtx:element" use="@name"/>

<xsl:template match="dtx:pe">
  <xsl:variable name="name" select="@name"/>

  <xsl:choose>
    <xsl:when test="$overrides/dtx:del-pe[@name = $name]"/>
    <xsl:when test="$overrides/dtx:pe[@name = $name]">
      <xsl:variable name="pe" select="$overrides/dtx:pe[@name = $name]"/>
      <xsl:if test="$pe/*">
        <xsl:copy-of select="$pe"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:element">
  <xsl:variable name="name" select="@name"/>

  <xsl:choose>
    <xsl:when test="$overrides/dtx:del-element[@name = $name]"/>
    <xsl:when test="$overrides/dtx:element[@name = $name]">
      <xsl:sequence select="$overrides/dtx:element[@name = $name]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:ref">
  <xsl:variable name="name" select="@name"/>

  <xsl:choose>
    <xsl:when test="$overrides/dtx:del-ref[@name = $name]"/>
    <xsl:when test="$overrides/dtx:ref-rename[@name = $name]">
      <xsl:variable name="rename" select="$overrides/dtx:ref-rename[@name = $name]"/>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name" select="$rename/@rename"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
