<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="/sourceforge/docbook/xsl/fo/docbook.xsl"/>
<xsl:include href="titlepage-fo-plain.xsl"/>

<xsl:param name="page.orientation" select="'landscape'"/>

<xsl:param name="slide.title.font.family" select="'Helvetica'"/>
<xsl:param name="slide.font.family" select="'Helvetica'"/>

<xsl:attribute-set name="slides.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="foil.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">18pt</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="speakernote.properties">
  <xsl:attribute name="font-family">Times Roman</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="slides.titlepage.recto.style"/>
<xsl:attribute-set name="slides.titlepage.verso.style"/>
<xsl:attribute-set name="section.titlepage.recto.style"/>
<xsl:attribute-set name="section.titlepage.verso.style"/>
<xsl:attribute-set name="foil.titlepage.recto.style"/>
<xsl:attribute-set name="foil.titlepage.verso.style"/>

<!-- ============================================================ -->

<xsl:template match="slides">
  <xsl:variable name="master-name">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-name="{$master-name}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>
    <xsl:if test="$double.sided != 0">
      <xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
    </xsl:if>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-name" select="$master-name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-name" select="$master-name"/>
    </xsl:apply-templates>
    <fo:flow flow-name="xsl-region-body"
             xsl:use-attribute-sets="slides.properties">
      <xsl:call-template name="slides.titlepage"/>
      <xsl:apply-templates select="speakernotes"/>
      <xsl:apply-templates select="section|foil"/>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="slidesinfo"/>

<xsl:template match="slides" mode="title.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(slidesinfo/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="section">
  <fo:block break-before="page"
            xsl:use-attribute-sets="section.properties">
    <xsl:call-template name="section.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="title" mode="section.titlepage.recto.mode">
  <fo:block>
    <xsl:text>.</xsl:text>
    <fo:block space-before="2in">
      <xsl:apply-templates select="." mode="titlepage.mode"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="sectioninfo"/>

<!-- ============================================================ -->

<xsl:template match="foil">
  <fo:block break-before="page"
            xsl:use-attribute-sets="section.properties">
    <xsl:call-template name="foil.titlepage"/>

    <fo:block text-align="center">
      <fo:leader leader-length="2in"
                 alignment-baseline="middle" 
                 rule-thickness="0.5pt" color="black"/>
      <fo:inline font="16pt ZapfDingbats"
                 color="#E00000">&#x274B;</fo:inline> 
      <fo:leader leader-length="2in"
                 alignment-baseline="middle"
                 rule-thickness="0.5pt" color="black"/>
    </fo:block>

    <fo:block xsl:use-attribute-sets="foil.properties">
      <xsl:apply-templates/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="foilinfo"/>
<xsl:template match="foil/title"/>
<xsl:template match="foil/titleabbrev"/>

<!-- ============================================================ -->

<xsl:template match="speakernotes">
  <fo:block xsl:use-attribute-sets="speakernote.properties">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
