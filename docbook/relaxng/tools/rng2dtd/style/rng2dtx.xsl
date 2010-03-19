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

<!-- Rough conversion of rng:* to dtx:* -->

<xsl:template match="rng:grammar">
  <dtd>
    <xsl:apply-templates/>
  </dtd>
</xsl:template>

<xsl:template match="s:ns"/>
<xsl:template match="s:pattern"/>
<xsl:template match="rng:start"/>
<xsl:template match="a:documentation"/>

<xsl:template match="rng:div">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="rng:interleave">
  <choice>
    <xsl:apply-templates/>
  </choice>
</xsl:template>

<xsl:template match="rng:optional[rng:ref and count(*) = 1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="rng:choice[parent::rng:choice]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="rng:choice|rng:zeroOrMore|rng:oneOrMore|rng:optional
                     |rng:empty|rng:text|rng:group|rng:value|rng:data">
  <xsl:element name="{local-name(.)}" namespace="http://nwalsh.com/ns/dtd-xml">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="rng:define[@name='db._any']" priority="500">
  <element name="db._any"/>
</xsl:template>

<xsl:template match="rng:define[rng:element and count(*) = 1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="rng:define">
  <pe name="{@name}">
    <xsl:apply-templates/>
  </pe>
</xsl:template>

<xsl:template match="rng:attribute">
  <attdecl name="{@name}">
    <xsl:apply-templates select="rng:value|rng:data|rng:ref"/>
  </attdecl>
</xsl:template>

<xsl:template match="rng:element">
  <element name="{../@name}">
    <xsl:if test="@name">
      <xsl:attribute name="gi" select="@name"/>
    </xsl:if>
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:ref">
  <ref name="{@name}">
    <xsl:if test="parent::rng:optional">
      <xsl:attribute name="optional" select="'true'"/>
    </xsl:if>
  </ref>
</xsl:template>

<xsl:template match="rng:notAllowed">
  <!-- nop -->
</xsl:template>

<xsl:template match="rng:param">
  <!-- nop -->
</xsl:template>

<xsl:template match="*">
  <xsl:message>
    <xsl:text>Failed to handle element: </xsl:text>
    <xsl:value-of select="node-name(.)"/>
  </xsl:message>
</xsl:template>

</xsl:stylesheet>
