<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or https://cdn.docbook.org/release/xsl/current/ for
     and other information.

     ******************************************************************** -->

<xsl:import href="../highlighting/common.xsl"/>

<xsl:attribute-set name="highlight.keyword.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.string.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.comment.properties">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.tag.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.attribute.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.value.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.number.properties" />

<xsl:attribute-set name="highlight.annotation.properties">
  <xsl:attribute name="color">gray</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.directive.properties" />

<xsl:attribute-set name="highlight.doccomment.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>


<xsl:template match='xslthl:keyword' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.keyword.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:string' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.string.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:comment' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.comment.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:tag' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.tag.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:attribute' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.attribute.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:value' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.value.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<!--
<xsl:template match='xslthl:html'>
  <span style='background:#AFF'><font color='blue'><xsl:apply-templates/></font></span>
</xsl:template>

<xsl:template match='xslthl:xslt'>
  <span style='background:#AAA'><font color='blue'><xsl:apply-templates/></font></span>
</xsl:template>

<xsl:template match='xslthl:section'>
  <span style='background:yellow'><xsl:apply-templates/></span>
</xsl:template>
-->

<xsl:template match='xslthl:number' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.number.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:annotation' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.annotation.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<xsl:template match='xslthl:directive' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.directive.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>

<!-- Not sure which element will be in final XSLTHL 2.0 -->
<xsl:template match='xslthl:doccomment|xslthl:doctype' mode="xslthl">
  <fo:inline xsl:use-attribute-sets="highlight.doccomment.properties">
    <xsl:apply-templates mode="xslthl"/>
  </fo:inline>
</xsl:template>


</xsl:stylesheet>
