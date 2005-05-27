<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="filename|replaceable|varname">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="option|userinput|envar|errorcode|constant|type">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role = 'bold' or @role = 'strong'">
      <xsl:apply-templates mode="bold" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="italic" select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>``</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>''</xsl:text>
</xsl:template>

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<xsl:template name="do-citerefentry">
  <xsl:param name="refentrytitle" select="''"/>
  <xsl:param name="manvolnum" select="''"/>

  <xsl:apply-templates mode="bold" select="$refentrytitle"/>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$manvolnum"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:call-template name="do-citerefentry">
    <xsl:with-param name="refentrytitle" select="refentrytitle"/>
    <xsl:with-param name="manvolnum" select="manvolnum"/>
  </xsl:call-template>
</xsl:template>

<!-- handle ulink here instead of in xref.xsl, because xref.xsl is -->
<!-- auto-generated from html/xref.xsl, and we need to do something a -->
<!-- little different for ulink in manpages output -->
<xsl:template match="ulink">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="url" select="@url"/>
  <xsl:choose>
    <xsl:when test="$url=$content or $content=''">
      <xsl:text>\fI</xsl:text>
      <xsl:value-of select="$url"/>
      <xsl:text>\fR</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$content"/>
      <xsl:text>: \fI</xsl:text>
      <xsl:value-of select="$url"/>
      <xsl:text>\fR</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
