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

  <xsl:template match="rng:define[count(*) &gt; 1]
		       |rng:zeroOrMore[count(*) &gt; 1]
		       |rng:oneOrMore[count(*) &gt; 1]">
    <xsl:variable name="refs">
      <xsl:text>0</xsl:text>
      <xsl:for-each select=".//rng:ref">
	<xsl:if test="key('defs',@name)/rng:element">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!--
    <xsl:if test="$refs &gt; 0">
      <xsl:message>
	<xsl:value-of select="@name"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$refs"/>
      </xsl:message>
    </xsl:if>
    -->

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:choose>
	<xsl:when test="$refs &gt; 0">
	  <rng:group>
	    <xsl:apply-templates/>
	  </rng:group>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
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
