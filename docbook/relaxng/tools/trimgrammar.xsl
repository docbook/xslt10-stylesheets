<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:div" priority="100">
    <xsl:if test="rng:*[not(@unused)]">
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:*" priority="50">
    <xsl:if test="not(@unused)">
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
