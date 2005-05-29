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

  <xsl:template match="refnamediv">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'RefName'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
    <xsl:for-each select="refname">
      <xsl:if test="position()>1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:text> \- </xsl:text>
    <xsl:value-of select="normalize-space (refpurpose)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="refsynopsisdiv">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="refsect1|refentry/refsection">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="refsect2|refentry/refsection/refsection">
    <xsl:text>.SS "</xsl:text>
    <xsl:value-of select="title[1]"/>
    <xsl:text>"&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="refsect3|refsection">
    <xsl:call-template name="nested-section-title"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.RS 3&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>.RE&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
