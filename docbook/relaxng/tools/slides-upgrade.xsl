<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:db = "http://docbook.org/docbook-ng"
                exclude-result-prefixes="exsl db"
                version="1.0">

<xsl:import href="db4-upgrade.xsl"/>

<xsl:template match="slidesinfo"
              priority="200">
  <info>
    <xsl:call-template name="copy.attributes"/>

    <!-- titles can be inside or outside or both. fix that -->
    <xsl:choose>
      <xsl:when test="title and following-sibling::title">
        <xsl:if test="title != following-sibling::title">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> title.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="title" mode="copy"/>
      </xsl:when>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::title">
        <xsl:apply-templates select="following-sibling::title" mode="copy"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Check </xsl:text>
          <xsl:value-of select="name(..)"/>
          <xsl:text>: no title.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="titleabbrev and following-sibling::titleabbrev">
        <xsl:if test="titleabbrev != following-sibling::titleabbrev">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> titleabbrev.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
      </xsl:when>
      <xsl:when test="titleabbrev">
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::titleabbrev">
        <xsl:apply-templates select="following-sibling::titleabbrev" mode="copy"/>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="subtitle and following-sibling::subtitle">
        <xsl:if test="subtitle != following-sibling::subtitle">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> subtitle.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::subtitle">
        <xsl:apply-templates select="following-sibling::subtitle" mode="copy"/>
      </xsl:when>
    </xsl:choose>

    <xsl:apply-templates/>
  </info>
</xsl:template>

<xsl:template match="foil/title|foilgroup/title
	             |foil/subtitle|foilgroup/subtitle
		     |foil/titleabbrev|foilgroup/titleabbrev" priority="200">
  <xsl:apply-templates select="." mode="copy"/>
</xsl:template>

</xsl:stylesheet>
