<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl"/>

<xsl:template match="pubdate" mode="titlepage.mode">
  <h2>
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
  </h2>
</xsl:template>

</xsl:stylesheet>
