<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		xmlns:s="http://www.ascc.net/xml/schematron"
		xmlns:db="http://docbook.org/docbook-ng"
                exclude-result-prefixes="exsl ctrl rng s db"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:variable name="exclusionsNS">
    <exclusions>
      <xsl:apply-templates select="//ctrl:exclude" mode="exclusions"/>
    </exclusions>
  </xsl:variable>

  <xsl:variable name="exclusions" select="exsl:node-set($exclusionsNS)/*"/>

  <xsl:variable name="startNS">
    <xsl:apply-templates select="//rng:start" mode="names"/>
  </xsl:variable>

  <xsl:variable name="start" select="exsl:node-set($startNS)/*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:grammar" priority="2">
    <xsl:copy>
      <!-- Make sure the datatypeLibrary is specified -->
      <xsl:attribute name="datatypeLibrary">
	<xsl:value-of select="'http://www.w3.org/2001/XMLSchema-datatypes'"/>
      </xsl:attribute>

      <!-- Make sure the ns is specified -->
      <xsl:attribute name="ns">
	<xsl:value-of select="'http://docbook.org/docbook-ng'"/>
      </xsl:attribute>

      <xsl:copy-of select="@*"/>

      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment> DocBook NG: The "Cachaça" Release </xsl:comment>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment> See http://docbook.org/docbook-ng/ </xsl:comment>
      <xsl:text>&#10;</xsl:text>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rng:element[@name]" priority="2">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="basename">
      <xsl:choose>
        <xsl:when test="starts-with(../@name, 'db.')">
          <xsl:value-of select="substring-after(../@name, 'db.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:for-each select="$exclusions/ctrl:exclusion[ctrl:from[*[name(.)=$name]]]">
	<xsl:for-each select="ctrl:exclude/*">
	  <!--
	  <xsl:message>
	    <xsl:value-of select="name(.)"/>
	    <xsl:text> is excluded from </xsl:text>
	    <xsl:value-of select="$name"/>
	  </xsl:message>
	  -->

	  <s:rule context="db:{$name}">
	    <s:assert test="not(.//db:{name(.)})">
	      <xsl:value-of select="name(.)"/>
	      <xsl:text> must not occur in the descendants of </xsl:text>
	      <xsl:value-of select="$name"/>
	    </s:assert>
	  </s:rule>
	</xsl:for-each>
      </xsl:for-each>

      <xsl:variable name="isStart">
	<xsl:value-of select="0"/>
	<xsl:for-each select="$start">
	  <xsl:if test="local-name(.) = $name">1</xsl:if>
	</xsl:for-each>
      </xsl:variable>

      <xsl:if test="$isStart &gt; 0">
	<s:rule context="/db:{$name}">
	  <s:assert test="@version">
	    <xsl:text>The root element must have a version attribute.</xsl:text>
	  </s:assert>
	</s:rule>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ctrl:exclude" mode="exclusions">
    <ctrl:exclusion>
      <ctrl:from>
	<xsl:apply-templates select="key('defs', @from)" mode="names"/>
      </ctrl:from>
      <ctrl:exclude>
	<xsl:apply-templates select="key('defs', @exclude)" mode="names"/>
      </ctrl:exclude>
    </ctrl:exclusion>
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

  <!-- ====================================================================== -->
  <!-- Names -->

  <xsl:template match="rng:ref" mode="names">
    <xsl:apply-templates select="key('defs',@name)" mode="names"/>
  </xsl:template>

  <xsl:template match="rng:element" mode="names">
    <xsl:choose>
      <xsl:when test="contains(@name, ':')">
	<xsl:element name="{substring-after(@name,':')}"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="{@name}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="names">
    <xsl:apply-templates mode="names"/>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
