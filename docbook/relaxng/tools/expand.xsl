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
    <xsl:call-template name="expand">
      <xsl:with-param name="root" select="/"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="expand">
    <xsl:param name="root"/>

    <xsl:variable name="canExpand">
      <xsl:apply-templates select="$root" mode="expandTest"/>
    </xsl:variable>

    <xsl:message>Expand: <xsl:value-of select="string-length($canExpand)"/></xsl:message>

    <xsl:choose>
      <xsl:when test="contains($canExpand, '1')">
	<xsl:variable name="expanded">
	  <xsl:apply-templates select="$root" mode="expand"/>
	</xsl:variable>
	<xsl:call-template name="expand">
	  <xsl:with-param name="root" select="exsl:node-set($expanded)"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$root"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="/" mode="expandTest">
    <xsl:for-each select="//rng:ref">
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="ref" select="key('defs', @name)"/>

      <xsl:choose>
	<xsl:when test="ancestor::rng:define[@name=$name]">
	  <!-- don't expand recursively -->
	</xsl:when>
	<xsl:when test="$ref and $ref/rng:element">
	  <!-- don't expand element patterns -->
	</xsl:when>
	<xsl:when test="$ref and $ref/rng:empty">
	  <!-- don't expand empty patterns -->
	</xsl:when>
	<xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="/" mode="expand">
    <xsl:apply-templates mode="expand"/>
  </xsl:template>

  <xsl:template match="rng:ref" priority="2" mode="expand">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="ref" select="key('defs', @name)"/>

    <xsl:choose>
      <xsl:when test="$ref and ancestor::rng:define[@name=$name]">
	<!-- don't expand recursively -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and $ref/rng:element">
	<!-- don't expand element patterns -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and $ref/rng:empty">
	<!-- just discard it -->
      </xsl:when>
      <xsl:when test="$ref">
	<xsl:copy-of select="$ref/*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:element" mode="expand">
    <!--
    <xsl:message>Expanding <xsl:value-of select="@name"/></xsl:message>
    -->
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="expand">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
