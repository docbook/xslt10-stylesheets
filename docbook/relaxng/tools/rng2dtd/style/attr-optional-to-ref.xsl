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

<!-- Normalize optionality of attributes: move to ref -->

<xsl:key name="name" match="dtx:pe|dtx:element" use="@name"/>

<xsl:template match="dtx:optional[parent::dtx:pe and dtx:attdecl]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dtx:ref">
  <xsl:variable name="target" select="key('name',@name)"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>

    <xsl:if test="$target[dtx:optional/dtx:attdecl]">
      <xsl:attribute name="optional" select="'true'"/>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
