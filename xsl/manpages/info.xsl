<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="date exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

  <!-- ================================================================== -->
  <!-- * Get user "refentry metadata" preferences -->
  <!-- ================================================================== -->

  <xsl:variable name="get.refentry.metadata.prefs">
    <xsl:call-template name="get.refentry.metadata.prefs"/>
  </xsl:variable>

  <xsl:variable name="refentry.metadata.prefs"
                select="exsl:node-set($get.refentry.metadata.prefs)"/>
  
  <!-- * =============================================================== -->

  <xsl:template name="author.names">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>
    <xsl:choose>
      <xsl:when test="$info//author">
        <xsl:apply-templates select="$info" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//author">
        <xsl:apply-templates select="$parentinfo" mode="author.names"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="info|refentryinfo|referenceinfo
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"
                mode="author.names">
    <xsl:for-each select="author">
      <xsl:apply-templates select="." mode="author.names"/>
      <xsl:choose>
        <xsl:when test="position() = last()"/> <!-- do nothing -->
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="author" mode="author.names">
    <xsl:call-template name="person.name"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select=".//email"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="author.section">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>
    <xsl:choose>
      <xsl:when test="$info//author">
        <xsl:apply-templates select="$info" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="$parentinfo//author">
        <xsl:apply-templates select="$parentinfo" mode="authorsect"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- * Match only the direct *info children of Refentry, along with -->
  <!-- * any *info for the valid direct parents of Refentry -->
  <xsl:template match="info|refentryinfo|referenceinfo
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"
                mode="authorsect">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Author'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>

    <xsl:for-each select="author|editor|othercredit">
      <xsl:apply-templates select="." mode="authorsect"/>
    </xsl:for-each>

  </xsl:template>
  
  <xsl:template match="author|editor|othercredit" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:call-template name="person.name"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select=".//email" mode="authorsect"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="contrib|personblurb|authorblurb">
      <xsl:apply-templates select="(contrib|personblurb|authorblurb)" mode="authorsect"/>
    <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="email" mode="authorsect">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="personblurb|authorblurb" mode="authorsect">
      <xsl:text>&#10;.IP&#10;</xsl:text>
      <xsl:for-each select="title">
        <xsl:apply-templates/>
        <xsl:text>.</xsl:text>
        <xsl:if test="following-sibling::*[name() != '']">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="*[name() != 'title']">
        <xsl:apply-templates/>
      </xsl:for-each>
  </xsl:template>

  <xsl:template match="contrib" mode="authorsect">
    <xsl:text>&#10;.IP&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- * ============================================================== -->

  <!-- * suppress refmeta and all *info (we grab what we need from them -->
  <!-- * elsewhere) -->

  <xsl:template match="refmeta"/>

  <xsl:template match="info|refentryinfo|referenceinfo|refsynopsisdivinfo
                       |refsectioninfo|refsect1info|refsect2info|refsect3info
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"/>

  <!-- ============================================================== -->
  
</xsl:stylesheet>
