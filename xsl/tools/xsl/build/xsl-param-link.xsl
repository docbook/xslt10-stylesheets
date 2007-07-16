<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:include href="xsl-params.xsl"/>

  <!-- * doc-baseuri is relative path to parent dir by default, so that -->
  <!-- * links in docs point to local dirs; but for release-notes build, -->
  <!-- * we feed this stylesheet the URL of the current XSL docs at the -->
  <!-- * project website at Sourceforge -->
  <xsl:param name="doc-baseuri">../</xsl:param>
  <xsl:param name="html-baseuri" select="concat($doc-baseuri,'html/')"/>
  <xsl:param name="fo-baseuri" select="concat($doc-baseuri,'fo/')"/>
  <xsl:param name="manpages-baseuri" select="concat($doc-baseuri,'manpages/')"/>
  <xsl:param name="roundtrip-baseuri" select="concat($doc-baseuri,'roundtrip/')"/>
  <xsl:param name="slides-html-baseuri" select="concat($doc-baseuri,'slides/')"/>
  <xsl:param name="slides-fo-baseuri" select="concat($doc-baseuri,'slides/')"/>
  <xsl:param name="website-baseuri" select="concat($doc-baseuri,'website/')"/>

  <!-- ====================================================================== -->

  <xsl:template match="parameter">
    <xsl:variable name="markup">
      <xsl:apply-imports/>
    </xsl:variable>
    <xsl:variable name="ishtml">
      <xsl:call-template name="is-html-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isfo">
      <xsl:call-template name="is-fo-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ismanpages">
      <xsl:call-template name="is-manpages-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isroundtrip">
      <xsl:call-template name="is-roundtrip-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isslideshtml">
      <xsl:call-template name="is-slides-html-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isslidesfo">
      <xsl:call-template name="is-slides-fo-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="iswebsite">
      <xsl:call-template name="is-website-parameter">
        <xsl:with-param name="param" select="normalize-space(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ishtml != 0">
        <a href="{concat($html-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$isfo != 0">
        <a href="{concat($fo-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$ismanpages != 0">
        <a href="{concat($manpages-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$isroundtrip != 0">
        <a href="{concat($roundtrip-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$isslideshtml != 0">
        <a href="{concat($slides-html-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$isslidesfo != 0">
        <a href="{concat($slides-fo-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:when test="$iswebsite != 0">
        <a href="{concat($website-baseuri, normalize-space(.))}.html">
          <xsl:copy-of select="$markup"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$markup"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
