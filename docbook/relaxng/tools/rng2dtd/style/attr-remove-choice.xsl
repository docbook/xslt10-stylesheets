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

<!-- You can't have a choice of attributes, remove the choice wrapper -->

<xsl:key name="name" match="dtx:pe|dtx:element" use="@name"/>

<xsl:template match="dtx:choice">
  <xsl:variable name="refs" select="dtx:ref"/>
  <xsl:variable name="attdecls" select="dtx:attdecl"/>
  <xsl:variable name="attref" select="f:only-attributes(dtx:ref)"/>

  <xsl:choose>
    <xsl:when test="count($refs) + count($attdecls) = count(*)">
      <xsl:choose>
        <xsl:when test="$attref">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:optional[dtx:ref and count(dtx:ref) = count(*)]">
  <xsl:variable name="attref" select="f:only-attributes(dtx:ref)"/>

  <xsl:choose>
    <xsl:when test="$attref">
      <xsl:for-each select="*">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="optional" select="'true'"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <choice>
        <xsl:apply-templates/>
      </choice>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:optional[dtx:attdecl and count(*) = 1]">
  <xsl:apply-templates/>
</xsl:template>

<!--
<xsl:template match="dtx:optional[dtx:attdecl and count(dtx:attdecl) = count(*)]">
  <xsl:apply-templates/>
</xsl:template>
-->

<xsl:template match="dtx:attdecl[ancestor::dtx:optional]">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="optional" select="'true'"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="dtx:ref[ancestor::dtx:optional]">
  <xsl:variable name="target" select="key('name',@name)"/>

  <xsl:choose>
    <xsl:when test="$target/dtx:attdecl">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="optional" select="'true'"/>
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
