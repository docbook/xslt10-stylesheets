<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="/sourceforge/docbook/xsl/fo/docbook.xsl"/>
<xsl:include href="titlepage-fo-plain.xsl"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
    <l:context name="title">
      <l:template name="slides" text="%t"/>
      <l:template name="foilgroup" text="%t"/>
      <l:template name="foil" text="%t"/>
    </l:context>
  </l:l10n>
</i18n>

<xsl:param name="page.orientation" select="'landscape'"/>

<xsl:param name="slide.title.font.family" select="'Helvetica'"/>
<xsl:param name="slide.font.family" select="'Helvetica'"/>

<xsl:param name="body.font.master" select="18"/>

<xsl:attribute-set name="slides.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="foilgroup.properties">
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
<xsl:attribute-set name="foilgroup.titlepage.recto.style"/>
<xsl:attribute-set name="foilgroup.titlepage.verso.style"/>
<xsl:attribute-set name="foil.titlepage.recto.style"/>
<xsl:attribute-set name="foil.titlepage.verso.style"/>

<!-- ============================================================ -->

<xsl:template name="user.pagemasters">
  <fo:page-sequence-master master-name="twoside1-with-titlepage">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="titlepage-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="body-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference master-reference="body-even"
                                            odd-or-even="even"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="oneside1-with-titlepage">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="titlepage-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="body-odd"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="titlepage1">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="titlepage-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="body-odd"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>
</xsl:template>

<xsl:template match="*" mode="running.head.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <!-- use the foilgroup title if there is one -->
  <fo:static-content flow-name="xsl-region-before">
    <fo:block text-align="center" font-size="14pt">
      <xsl:apply-templates select="ancestor-or-self::foilgroup"
                           mode="object.title.markup"/>
    </fo:block>
  </fo:static-content>
</xsl:template>

<xsl:template match="*" mode="running.foot.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <xsl:variable name="foot">
    <fo:page-number/>
  </xsl:variable>
  <!-- by default, the page number -->
  <xsl:choose>
    <xsl:when test="$master-reference='titlepage1'"></xsl:when>
    <xsl:when test="$master-reference='oneside1-with-titlepage'">
      <fo:static-content flow-name="xsl-region-after">
        <fo:block text-align="center" font-size="14pt">
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
    </xsl:when>
    <xsl:when test="$master-reference='twoside1-with-titlepage'">
      <fo:static-content flow-name="xsl-region-after-left">
        <fo:block text-align="left" font-size="14pt">
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-right">
        <fo:block text-align="right" font-size="14pt">
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected master-reference (</xsl:text>
        <xsl:value-of select="$master-reference"/>
        <xsl:text>) in running.foot.mode for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>. No footer generated.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="select.user.pagemaster">
  <xsl:param name="element"/>
  <xsl:param name="pageclass"/>
  <xsl:param name="default-pagemaster"/>

  <xsl:choose>
    <xsl:when test="$element = 'slides'">titlepage1</xsl:when>
    <xsl:when test="$double.sided != 0">twoside1-with-titlepage</xsl:when>
    <xsl:otherwise>oneside1-with-titlepage</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="slides">
  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <fo:flow flow-name="xsl-region-body"
             xsl:use-attribute-sets="slides.properties">
      <xsl:call-template name="slides.titlepage"/>
      <xsl:apply-templates select="speakernotes"/>
      <xsl:apply-templates select="foil"/>
    </fo:flow>
  </fo:page-sequence>
  <xsl:apply-templates select="foilgroup"/>
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

<xsl:template match="foilgroup">
  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <fo:flow flow-name="xsl-region-body"
             xsl:use-attribute-sets="foilgroup.properties">
      <xsl:call-template name="foilgroup.titlepage"/>
      <xsl:apply-templates select="speakernotes"/>
      <xsl:apply-templates select="foil"/>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="foilgroup/title">
  <!-- suppress -->
</xsl:template>

<xsl:template match="slides/foilgroup/title" mode="titlepage.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="title" mode="foilgroup.titlepage.recto.mode">
  <fo:block>
    <fo:inline color="white">.</fo:inline>
    <fo:block space-before="2in">
      <xsl:apply-templates select="." mode="titlepage.mode"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="foilgroupinfo"/>

<!-- ============================================================ -->

<xsl:template match="foil">
  <fo:block break-before="page"
            xsl:use-attribute-sets="foil.properties">
    <xsl:call-template name="foil.titlepage"/>

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
