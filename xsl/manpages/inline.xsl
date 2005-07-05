<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
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

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<xsl:template name="do-citerefentry">
  <xsl:param name="refentrytitle" select="''"/>
  <xsl:param name="manvolnum" select="''"/>
  <xsl:variable name="title">
    <bold><xsl:value-of select="$refentrytitle"/></bold>
  </xsl:variable>
  <xsl:apply-templates mode="bold" select="exsl:node-set($title)"/>
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

<!-- * handle ulink here instead of in xref.xsl, because xref.xsl is -->
<!-- * auto-generated from html/xref.xsl, and we need to do something -->
<!-- * a little different for ulink in manpages output -->
<xsl:template match="ulink">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="url" select="@url"/>
  <xsl:if test="$url != $content and $content != ''">
    <xsl:value-of select="$content"/>
    <xsl:text>: </xsl:text>
  </xsl:if>
  <xsl:variable name="url.wrapper">
    <italic><xsl:value-of select="@url"/></italic>
  </xsl:variable>
  <xsl:apply-templates mode="italic" select="exsl:node-set($url.wrapper)"/>
</xsl:template>

<xsl:template match="trademark|productname">
  <xsl:apply-templates/>
  <xsl:choose>
    <!-- * Just use true Unicode chars for copyright and registered -->
    <!-- * symbols (by default, we later automatically translate them -->
    <!-- * with the apply-string-subst-map template, or with the -->
    <!-- * default character map, if man.charmap.enabled is true). -->
    <xsl:when test="@class = 'copyright'">
      <xsl:text>&#x00a9;</xsl:text>
    </xsl:when>
    <xsl:when test="@class = 'registered'">
      <xsl:text>&#x00ae;</xsl:text>
    </xsl:when>
    <!-- * There is no groff equivalent for the servicemark symbol. -->
    <xsl:when test="@class = 'service'">
      <xsl:text>(SM)</xsl:text>
    </xsl:when>
    <xsl:when test="self::trademark" >
      <!-- * by default, render trademark symbol for <trademark> -->
      <!-- * -->
      <!-- * We don't do "\(tm" for &#x2122; because for console -->
      <!-- * output, groff just renders that as "tm", without any -->
      <!-- * preceding space, parens, or anything. So it just gets -->
      <!-- * run into the preceding word; i.e.: -->
      <!-- * -->
      <!-- *  Product&#x2122; -> Producttm -->
      <!-- * -->
      <!-- * That it probably not what most people would want. So -->
      <!-- * we just render it as (TM) instead, Thus: -->
      <!-- * -->
      <!-- *  Product&#x2122; -> Product(TM) -->
      <!-- * -->
      <xsl:text>(TM)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- * don't render any default symbol after productname -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
