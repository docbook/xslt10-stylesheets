<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or https://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:import href="../../../html/chunk.xsl"/>

<!-- * The following are stylesheets for auto-adding doc links to -->
<!-- * DocBook: The Definitive Guide and to the param and PI -->
<!-- * documentation in the docbook-xsl docs -->
<xsl:include href="tdg-link.xsl"/>
<xsl:include href="xsl-param-link.xsl"/>
<xsl:include href="xsl-pi-link.xsl"/>

<xsl:param name="tcg.base.url">http://www.sagehill.net/docbookxsl/</xsl:param>

<!-- * standard params -->
<xsl:param name="abstract.notitle.enabled" select="1"/>
<xsl:param name="admon.graphics" select="0"/>
<xsl:param name="admon.textlabel" select="1"></xsl:param>
<xsl:param name="chunk.append"><xsl:text>&#x0a;</xsl:text></xsl:param>
<xsl:param name="chunk.quietly" select="0"></xsl:param>
<xsl:param name="component.label.includes.part.label" select="1"/>
<xsl:param name="generate.legalnotice.link" select="1"></xsl:param>
<xsl:param name="generate.manifest" select="1"></xsl:param>
<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title
book      toc,title,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
</xsl:param>
<xsl:param name="graphicsize.extension" select="0"></xsl:param>
<xsl:param name="html.append"><xsl:text>&#x0a;</xsl:text></xsl:param>
<xsl:param name="html.longdesc" select="1"/>
<xsl:param name="html.stylesheet" select="'reference.css'"/>
<xsl:param name="index.on.type" select="1"/>
<xsl:param name="keep.relative.image.uris" select="1"/>
<xsl:param name="label.from.part" select="'1'"></xsl:param>
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="refentry.generate.name" select="0"/>
<xsl:param name="refentry.generate.title" select="1"/>
<xsl:param name="refentry.separator" select="0"/>
<xsl:param name="reference.autolabel">1</xsl:param>
<xsl:param name="toc.max.depth">2</xsl:param>
<xsl:param name="use.extensions" select="0"></xsl:param>
<xsl:param name="use.id.as.filename" select="1"></xsl:param>
<xsl:param name="variablelist.as.table" select="0"/>

<!-- ==================================================================== -->

<xsl:template match="olink[@type='title']">
  <xsl:variable name="xml"
    select="document(unparsed-entity-uri(@targetdocent),.)"/>
  <xsl:variable name="title" select="($xml/*/title[1]
    |$xml/*/bookinfo/title[1]
    |$xml/*/referenceinfo/title[1])[1]"/>
  <i>
    <a href="{@localinfo}">
      <xsl:apply-templates select="$title/*|$title/text()"/>
    </a>
  </i>
</xsl:template>

<xsl:template match="link[@role = 'tcg']|ulink[@role = 'tcg']">
  <!-- * Preface this TCG page link with a "DocBook XSL: TCG" direct link -->
  <!-- * - unless this link has an ancestor with @role=tcg, which means -->
  <!-- * it's in a section of the docbook-xsl docs that already has a -->
  <!-- * title indicating the links in it are to TCG. -->
  <xsl:if test="not(ancestor::*[@role = 'tcg'])">
    <a href="{$tcg.base.url}">DocBook XSL: TCG</a>
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@xlink:href">
      <xsl:call-template name="link">
        <xsl:with-param name="xhref" select="concat($tcg.base.url,@xlink:href)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="ulink">
        <xsl:with-param name="url" select="concat($tcg.base.url,@url)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
