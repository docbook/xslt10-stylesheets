<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:set="http://exslt.org/sets"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl s"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:element">
    <xsl:variable name="attr"
		  select="*[self::rng:ref[key('defs',@name)/rng:attribute]
		            |self::rng:attribute
		            |.//rng:ref[key('defs',@name)/rng:attribute]
		            |.//rng:attribute]"/>
    <xsl:variable name="rules" select="s:*"/>
    <xsl:variable name="cmod" select="set:difference(*,$attr|rng:notAllowed|$rules)"/>

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <rng:attributes>
	<xsl:copy-of select="$attr"/>
      </rng:attributes>

      <rng:content-model>
	<xsl:choose>
	  <xsl:when test="count($cmod) &gt; 1">
	    <rng:group>
	      <xsl:copy-of select="$cmod"/>
	    </rng:group>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="$cmod"/>
	  </xsl:otherwise>
	</xsl:choose>
      </rng:content-model>

      <xsl:if test="$rules">
	<rng:rules>
	  <xsl:copy-of select="$rules"/>
	</rng:rules>
      </xsl:if>
    </xsl:copy>
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
