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

<!-- If a pe is empty, remove it and references to it -->

<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:key name="pe" match="dtx:pe" use="@name"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dtx:pe[not(*)]">
  <!-- nop -->
  <!--
  <xsl:message>Remove empty PE: <xsl:value-of select="@name"/></xsl:message>
  -->
</xsl:template>

<xsl:template match="dtx:ref">
  <xsl:variable name="target" select="key('pe', @name)"/>

  <xsl:choose>
    <xsl:when test="$target and not($target/*)">
      <!-- nop -->
      <!--
      <xsl:message>Remove ref to PE: <xsl:value-of select="@name"/></xsl:message>
      -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:next-match/>
    </xsl:otherwise>
  </xsl:choose>
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

</xsl:stylesheet>
