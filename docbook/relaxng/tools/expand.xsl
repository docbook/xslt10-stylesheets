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

  <xsl:template match="rng:ref" priority="2">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="ref" select="key('defs', @name)"/>

    <xsl:choose>
      <xsl:when test="$ref and ancestor::rng:define[@name=$name]">
	<!-- don't expand it recursively... -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and ($ref/rng:element or $ref/rng:attribute)">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and ($ref/rng:empty)">
	<!-- just discard it -->
      </xsl:when>
      <xsl:when test="$ref">
	<xsl:copy-of select="$ref/*"/>
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
