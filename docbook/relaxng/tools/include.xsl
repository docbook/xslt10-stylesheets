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
  <xsl:key name="combines" match="rng:define[@combine='choice']" use="@name"/>

  <xsl:template match="/">
    <xsl:variable name="expanded">
      <xsl:apply-templates mode="include"/>
    </xsl:variable>
    <xsl:message>Combining...</xsl:message>
    <xsl:apply-templates select="exsl:node-set($expanded)/*" mode="combine"/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:include" mode="include">
    <xsl:message>Including <xsl:value-of select="@href"/></xsl:message>
    <xsl:variable name="doc" select="document(@href,.)"/>
    <xsl:apply-templates select="$doc/rng:grammar/*" mode="include"/>
  </xsl:template>

  <xsl:template match="*" mode="include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="include"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="include">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:define" mode="combine">
    <xsl:choose>
      <xsl:when test="@combine = 'choice'"/>
      <xsl:when test="@combine = 'interleave'">
	<!-- these are always attributes, right? -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="combine"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="@combine">
	<!-- what's this!? -->
	<xsl:message>
	  <xsl:text>Warning: unexpected combine on rng:define for </xsl:text>
	  <xsl:value-of select="@name"/>
	</xsl:message>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="combine"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="choices" select="key('combines', @name)"/>
	<xsl:choose>
	  <xsl:when test="$choices">
	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <rng:choice>
		<xsl:apply-templates mode="combine"/>
		<xsl:apply-templates select="$choices/*" mode="combine"/>
	      </rng:choice>
	    </xsl:copy>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <xsl:apply-templates mode="combine"/>
	    </xsl:copy>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="combine">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="combine"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="combine">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
