<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************
     (c) Stephane Bline Peregrine Systems 2001
     Implementation of xep extensions:
       * Pdf bookmarks (based on the XEP 2.5 implementation)
       * Document information (XEP 2.5 meta information extensions)
     ******************************************************************** -->

<!-- ********************************************************************
     Document information
     ******************************************************************** -->

<xsl:template name="document-information">
  <xsl:param name="document-title" select="//title[1]"/>
  <rx:meta-info>
    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">author</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:choose>
          <xsl:when test="bookinfo/author">
            <xsl:value-of select="bookinfo/author"/>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">title</xsl:attribute>
        <xsl:attribute name="value">
            <xsl:value-of select="$document-title"/>
        </xsl:attribute>
    </xsl:element>
  </rx:meta-info>
</xsl:template>

<!-- ********************************************************************
     Pdf bookmarks
     ******************************************************************** -->
<xsl:template match="set" mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>
  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>

  <xsl:if test="book">
      <xsl:apply-templates select="book"
                           mode="xep.outline"/>
  </xsl:if>
  </rx:bookmark>
</xsl:template>

<xsl:template match="book" mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>

  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>

  <xsl:if test="part|preface|chapter|appendix">
      <xsl:apply-templates select="part|preface|chapter|appendix"
                           mode="xep.outline"/>
  </xsl:if>
  </rx:bookmark>
</xsl:template>


<xsl:template match="part" mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>

  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>

  <xsl:if test="chapter|appendix|preface|reference">
      <xsl:apply-templates select="chapter|appendix|preface|reference"
                           mode="xep.outline"/>
  </xsl:if>
  </rx:bookmark>
</xsl:template>

<xsl:template match="preface|chapter|appendix"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>

  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>

  <xsl:if test="section|sect1">
      <xsl:apply-templates select="section|sect1"
                           mode="xep.outline"/>
  </xsl:if>
  </rx:bookmark>
</xsl:template>

<xsl:template match="section|sect1|sect2|sect3|sect4|sect5"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>

  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>

  <xsl:if test="section|sect2|sect3|sect4|sect5">
      <xsl:apply-templates select="section|sect2|sect3|sect4|sect5"
                           mode="xep.outline"/>
  </xsl:if>
  </rx:bookmark>
</xsl:template>

<xsl:template match="bibliography|glossary|index"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="label.content"/>
    <xsl:apply-templates select="." mode="title.content"/>
  </xsl:variable>

  <rx:bookmark internal-destination="{$id}">
    <rx:bookmark-label>
      <xsl:value-of select="$bookmark-label"/>
    </rx:bookmark-label>
  </rx:bookmark>
</xsl:template>

<xsl:template match="title" mode="xep.outline">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
