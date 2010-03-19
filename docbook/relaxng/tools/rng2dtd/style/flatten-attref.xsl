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

<xsl:import href="common.xsl"/>

<!-- Flatten chains of attrefs -->

<xsl:key name="name" match="dtx:pe" use="@name"/>
<xsl:key name="use" match="dtx:ref|dtx:attref" use="@name"/>

<xsl:template match="dtx:pe">
  <xsl:choose>
    <xsl:when test="key('use',@name)">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
<!--
      <xsl:message>Unused pattern: <xsl:value-of select="@name"/></xsl:message>
-->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:attref">
  <xsl:variable name="target" select="key('name',@name)"/>

  <xsl:choose>
    <xsl:when test="$target/dtx:attref and count($target/dtx:attref) = 1">
<!--
      <xsl:message>
        <xsl:value-of select="@name"/>
        <xsl:text> is just another name for </xsl:text>
        <xsl:value-of select="$target/dtx:attref/@name"/>
      </xsl:message>
-->
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name" select="$target/dtx:attref/@name"/>
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
