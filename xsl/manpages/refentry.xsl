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

  <!-- ==================================================================== -->

  <!-- * Use uppercase to render titles of all instances of Refsect1 or -->
  <!-- * top-level Refsection, including in cross-references -->
  <xsl:template match="refsect1|refentry/refsection"
                mode="title.markup">
    <xsl:param name="allow-anchors" select="0"/>
    <xsl:variable name="title" select="(info/title
                                       |refsectioninfo/title
                                       |refsect1info/title
                                       |title)[1]"/>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:apply-templates select="$title" mode="title.markup">
          <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- * Use uppercase to render titles of all instances of Refsynopsisdiv, -->
  <!-- * including in cross-references -->
  <xsl:template match="refsynopsisdiv" mode="title.markup">
    <xsl:param name="allow-anchors" select="0"/>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test="title">
            <xsl:apply-templates select="title" mode="title.markup">
              <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- * For cross-references to Refnamediv, use localized gentext Refnamediv -->
  <!-- * title (instead of using first Refname, as HTML and FO stylesheets do), -->
  <!-- * and make it uppercase -->
  <xsl:template match="refnamediv" mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose" select="1"/>

    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'RefName'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
