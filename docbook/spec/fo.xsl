<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="/projects/oasis/spectools/stylesheets/oasis-docbook-fo.xsl"/>

<xsl:param name="draft.watermark.image"
           select="'/sourceforge/docbook/xsl/images/draft.png'"/>

<!-- These get evaluated before stripping! -->

<xsl:variable name="tcProduct" 
	      select="//articleinfo/productname[1]"/>
<xsl:variable name="tcProductVersion"
	      select="//articleinfo/productnumber[1]"/>
<xsl:variable name="tcArtifactType" select="'spec'"/>
<xsl:variable name="tcStage"
	      select="//articleinfo/releaseinfo[@role='stage'][1]"/>
<xsl:variable name="tcRevision"
	      select="//articleinfo/pubsnumber[1]"/>
<xsl:variable name="tcLanguage" select="/@xml:lang"/>
<xsl:variable name="tcForm" select="'xml'"/>

<xsl:variable name="odnRoot">
  <xsl:value-of select="$tcProduct"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcProductVersion"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcArtifactType"/>
  <xsl:if test="$tcStage != 'os'">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$tcStage"/>
  </xsl:if>
  <xsl:if test="$tcRevision != ''">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$tcRevision"/>
  </xsl:if>
  <xsl:if test="$tcLanguage != 'en' and $tcLanguage != ''">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$tcLanguage"/>
  </xsl:if>
</xsl:variable>

<xsl:template match="productname" mode="titlepage.mode">
  <xsl:variable name="pn" select="../productnumber[1]"/>

  <fo:block>
    <fo:block font-family="{$title.font.family}"
              space-before="0.5em">Document identifier:</fo:block>
    <fo:block margin-left="2em">
      <xsl:value-of select="$odnRoot"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="legalnotice[@role='status']" mode="titlepage.mode">
  <fo:block>
    <fo:block font-family="{$title.font.family}"
              space-before="0.5em">
      <xsl:text>Status:</xsl:text>
    </fo:block>
    <fo:block margin-left="2em">
      <xsl:apply-templates mode="titlepage.mode"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="pubdate" mode="titlepage.mode">
  <fo:block keep-with-next="always"
            font-size="18pt"
            space-before="10pt"
            space-after="8pt"
            font-weight="bold"
            font-family="{$title.font.family}">
    <xsl:choose>
      <xsl:when test="/*/@status">
        <xsl:value-of select="/*/@status"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>???Unknown Status???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:text>&#160;</xsl:text>

    <xsl:if test="../productnumber">
      <xsl:text>V</xsl:text>
      <xsl:value-of select="../productnumber[1]"/>
      <xsl:text>,&#160;</xsl:text>
    </xsl:if>

    <xsl:call-template name="datetime.format">
      <xsl:with-param name="date" select="."/>
      <xsl:with-param name="format" select="'d B Y'"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
