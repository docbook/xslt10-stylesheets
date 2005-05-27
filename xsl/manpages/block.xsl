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

<xsl:template match="refsection|refsect1">
  <xsl:choose>
    <xsl:when test="ancestor::refsection">
      <xsl:text>.SS "</xsl:text>
      <xsl:value-of select="title[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.SH "</xsl:text>
      <xsl:value-of
          select="translate(title[1],
                  'abcdefghijklmnopqrstuvwxyz',
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>"&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect2">
  <xsl:text>.SS "</xsl:text>
  <xsl:value-of select="title[1]"/>
  <xsl:text>"&#10;</xsl:text>
  <xsl:apply-templates/>
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

<xsl:template match="refentry/refentryinfo"></xsl:template>

<xsl:template match="caution|important|note|tip|warning">
  <xsl:text>.RS&#10;.Sh "</xsl:text>
    <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
    <xsl:text>"&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>.RE&#10;</xsl:text>
</xsl:template> 

<xsl:template match="para">
  <xsl:text>.PP&#10;</xsl:text>
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="simpara">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="address|literallayout|programlisting|screen|synopsis">
  <!-- Yes, address and synopsis are verbatim environments. -->

  <xsl:choose>
    <!-- Check to see if this vertbatim item is within a parent element that -->
    <!-- allows mixed content. -->
    
    <!-- If it is within a mixed-content parent, then a line break is -->
    <!-- already added before it by the mixed-block template, so we don't -->
    <!-- need to add one here. -->
    
    <!-- If it is not within a mixed-content parent, then we need to add a -->
    <!-- line break before it. -->
    <xsl:when test="parent::caption|parent::entry|parent::para|
                    parent::td|parent::th" /> <!-- do nothing -->
    <xsl:otherwise>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.nf&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>.fi&#10;</xsl:text>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:text>.IP&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
