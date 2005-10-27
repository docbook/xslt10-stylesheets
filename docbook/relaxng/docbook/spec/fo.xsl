<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="/projects/oasis/spectools/stylesheets/oasis-docbook-fo.xsl"/>

<xsl:param name="draft.watermark.image"
           select="'/sourceforge/docbook/xsl/images/draft.png'"/>

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
