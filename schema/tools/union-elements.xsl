<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://nwalsh.com/xmlns/docbook-grammar-structure"
                version="1.0">

<xsl:output method="xml"/>

<xsl:preserve-space elements="*"/>

<xsl:param name="union.xml" select="'union.xml'"/>

<xsl:template match="/">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="db:elements" priority="2">
  <xsl:variable name="union" select="document($union.xml, .)"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="$union/db:elements" mode="union"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:elements" mode="union">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
