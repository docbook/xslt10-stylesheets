<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:content-model//rng:choice/rng:choice
		       |rng:content-model//rng:zeroOrMore/rng:choice
		       |rng:content-model//rng:oneOrMore/rng:choice
		       |rng:content-model//rng:zeroOrMore/rng:zeroOrMore
		       |rng:content-model//rng:oneOrMore/rng:oneOrMore">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:ref">
    <xsl:variable name="name" select="@name"/>
    <xsl:choose>
      <xsl:when test="preceding-sibling::rng:ref[@name = $name]">
	<!-- suppress -->
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
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
