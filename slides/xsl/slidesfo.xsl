<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/TR/REC-html"
		version="1.0">

<xsl:import href="/share/xsl/docbook/fo/docbook.xsl"/>

<xsl:output method="xml"/>

<xsl:param name="base-font-size">14pt</xsl:param>
<xsl:param name="base-font-family">Helvetica</xsl:param>
<xsl:param name="base-font-weight">medium</xsl:param>

<xsl:param name="title-font-size">18pt</xsl:param>
<xsl:param name="title-font-family">Helvetica</xsl:param>
<xsl:param name="title-font-weight">bold</xsl:param>

<!-- ============================================================ -->

<xsl:variable name="pageWidth">8.5in</xsl:variable>
<xsl:variable name="pageHeight">11in</xsl:variable>
<xsl:variable name="RegionAfterExtent">25pt</xsl:variable>
<xsl:variable name="RegionBeforeExtent">25pt</xsl:variable>
<xsl:variable name="BodyMarginBottom">24pt</xsl:variable>
<xsl:variable name="BodyMarginTop">24pt</xsl:variable>
<xsl:variable name="PageMarginTop">75pt</xsl:variable>
<xsl:variable name="PageMarginBottom">100pt</xsl:variable>
<xsl:variable name="PageMarginLeft">80pt</xsl:variable>
<xsl:variable name="PageMarginRight">150pt</xsl:variable>

<xsl:template match="/">
  <fo:root font-family="{$base-font-family}"
           font-size="{$base-font-size}"
           text-align="left">
    <fo:layout-master-set>
      <fo:simple-page-master
	page-width="{$pageWidth}"
	page-height="{$pageHeight}"
	page-master-name="left"
	margin-top="{$PageMarginTop}"
	margin-bottom="{$PageMarginBottom}"
	margin-left="{$PageMarginLeft}"
	margin-right="{$PageMarginRight}">
	<fo:region-body margin-bottom="{$BodyMarginBottom}"
		        margin-top="{$BodyMarginTop}"/>
	  <fo:region-after extent="{$RegionAfterExtent}"/>
	  <fo:region-before extent="{$RegionBeforeExtent}"/>
	</fo:simple-page-master>
      <fo:simple-page-master
	page-width="{$pageWidth}"
	page-height="{$pageHeight}"
	page-master-name="right"
	margin-top="{$PageMarginTop}"
	margin-bottom="{$PageMarginBottom}"
	margin-left="{$PageMarginLeft}"
	margin-right="{$PageMarginRight}">
	<fo:region-body margin-bottom="{$BodyMarginBottom}"
	  margin-top="{$BodyMarginTop}"/>
	  <fo:region-after extent="{$RegionAfterExtent}"/>
	  <fo:region-before extent="{$RegionBeforeExtent}"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
    <xsl:apply-templates/>
  </fo:root>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="inlinegraphic[@format='linespecific']">
  <html:a xml:link="simple" show="embed" actuate="auto" href="{@fileref}"/>
</xsl:template>

<xsl:template match="imagedata[@format='linespecific']">
  <html:a xml:link="simple" show="embed" actuate="auto" href="{@fileref}"/>
</xsl:template>

<xsl:template match="imagedata">
  <fo:external-graphic src="{@fileref}"
                       width="auto"
                       height="auto"
                       text-align="center"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slides">
  <xsl:choose>
    <xsl:when test="section">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <fo:page-sequence  initial-page-number="1">
	<fo:page-sequence-master>
	  <fo:repeatable-page-master-alternatives
	    page-master-odd="right"
	    page-master-even="left"/>
	</fo:page-sequence-master>
      
	<fo:static-content flow-name="xsl-after">
	  <fo:block text-align-last="centered" font-size="10pt">
	    <fo:page-number/>
	  </fo:block>
	</fo:static-content>

	<fo:flow font-weight="{$base-font-weight}"
	  font-size="{$base-font-size}"
	  font-family="{$base-font-family}">
	  <xsl:apply-templates/>
	</fo:flow>
      </fo:page-sequence>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo">
</xsl:template>

<xsl:template match="slidesinfo/title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo/authorgroup">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo/author|slidesinfo/authorgroup/author">
  <xsl:apply-imports/>
</xsl:template>

<xsl:template match="slidesinfo/releaseinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo/date">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo/copyright">
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="section">
  <fo:page-sequence  initial-page-number="1">
    <fo:page-sequence-master>
      <fo:repeatable-page-master-alternatives
	page-master-odd="right"
	page-master-even="left"/>
    </fo:page-sequence-master>
      
    <fo:static-content flow-name="xsl-after">
      <fo:block text-align-last="centered" font-size="10pt">
	<fo:page-number/>
      </fo:block>
    </fo:static-content>

    <fo:flow font-weight="{$base-font-weight}"
	     font-size="{$base-font-size}"
             font-family="{$base-font-family}">
      <xsl:apply-templates/>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="section/title">
</xsl:template>

<xsl:template match="section/title" mode="navheader">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slides/title" mode="navheader">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slides/slidesinfo/title" mode="navheader">
  <xsl:apply-templates/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="foil">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <fo:block break-before="page">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="foil/title">
  <fo:block font-weight="{$title-font-weight}"
            font-size="{$title-font-size}"
            font-family="{$title-font-family}"
            text-align="center">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>

