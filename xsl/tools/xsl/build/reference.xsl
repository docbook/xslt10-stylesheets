<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:import href="../../../html/chunk.xsl"/>
<xsl:include href="tdg-link.xsl"/>
<xsl:include href="xsl-param-link.xsl"/>
<!-- * params -->
<xsl:param name="admon.graphics" select="0"/>
<xsl:param name="admon.textlabel" select="0"></xsl:param>
<xsl:param name="chunk.append"><xsl:text>&#x0a;</xsl:text></xsl:param>
<xsl:param name="chunk.quietly" select="1"></xsl:param>
<xsl:param name="generate.legalnotice.link" select="1"></xsl:param>
<xsl:param name="generate.manifest" select="1"></xsl:param>
<xsl:param name="graphicsize.extension" select="0"></xsl:param>
<xsl:param name="html.append"><xsl:text>&#x0a;</xsl:text></xsl:param>
<xsl:param name="html.longdesc" select="1"/>
<xsl:param name="html.stylesheet" select="'reference.css'"/>
<xsl:param name="index.on.type" select="1"/>
<xsl:param name="keep.relative.image.uris" select="1"/>
<xsl:param name="label.from.part" select="'1'"></xsl:param>
<xsl:param name="part.autolabel" select="0"/>
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
</xsl:stylesheet>
