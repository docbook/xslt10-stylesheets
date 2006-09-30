<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version="2.0">

<!--
xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
xmlns:u="http://nwalsh.com/xsl/unittests#"
-->

<xsl:import href="slides.xsl"/>

<!-- ============================================================ -->

<xsl:template name="t:head">
  <xsl:param name="notes" select="0" tunnel="yes"/>

  <title>
    <xsl:choose>
      <xsl:when test="db:info/db:title">
	<xsl:value-of select="db:info/db:title"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>???</xsl:text>
	<xsl:message>
	  <xsl:text>Warning: no title for root element: </xsl:text>
	  <xsl:value-of select="local-name(.)"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </title>

  <link rel="stylesheet" type="text/css" href="plain.css" />
</xsl:template>

<xsl:template name="t:foil-footer"/>

<xsl:template match="db:slides" mode="m:root">
  <xsl:if test="$save.normalized.xml != 0">
    <xsl:message>Saving normalized xml.</xsl:message>
    <xsl:result-document href="normalized.xml">
      <xsl:copy-of select="."/>
    </xsl:result-document>
  </xsl:if>

  <html>
    <head>
      <xsl:call-template name="t:head"/>
    </head>
    <body>
      <div class="titlepage">
	<h1>
	  <xsl:value-of select="db:info/db:title"/>
	</h1>
	<xsl:if test="db:info/db:subtitle">
	  <h2>
	    <xsl:value-of select="db:info/db:subtitle"/>
	  </h2>
	</xsl:if>
	<div class="author">
	  <xsl:apply-templates select="db:info/db:author"
			       mode="m:titlepage-mode"/>
	  <xsl:if test="db:info/db:author//db:orgname">
	    <h4>
	      <xsl:value-of select="(db:info/db:author//db:orgname)[1]"/>
	    </h4>
	  </xsl:if>
	</div>
      </div>

      <div class="toc">
	<h1>Contents</h1>
	<xsl:if test="db:foil">
	  <ul>
	    <xsl:apply-templates select="db:foil"
				 mode="m:slidetoc"/>
	  </ul>
	</xsl:if>
	<xsl:if test="db:foilgroup">
	  <ul>
	    <xsl:apply-templates select="db:foilgroup"
				 mode="m:slidetoc"/>
	  </ul>
	</xsl:if>
      </div>

      <xsl:apply-templates select="db:foil|db:foilgroup"/>
    </body>
  </html>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:foil|db:foilgroup">
  <div class="foil" id="{generate-id()}">
    <xsl:call-template name="t:foil-header"/>
    <xsl:call-template name="t:foil-body">
      <xsl:with-param name="notes" select="0" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="t:foil-footer"/>
  </div>

  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<xsl:template match="db:speakernotes"/>

<!-- ============================================================ -->

<xsl:template match="db:foilgroup" mode="m:slidetoc">
  <li>
    <a href="#{generate-id()}">
      <xsl:value-of select="db:info/db:title"/>
    </a>
    <ul>
      <xsl:apply-templates select="db:foil" mode="m:slidetoc"/>
    </ul>
  </li>
</xsl:template>

<xsl:template match="db:foil" mode="m:slidetoc">
  <li>
    <a href="#{generate-id()}">
      <xsl:value-of select="db:info/db:title"/>
    </a>
  </li>
</xsl:template>

</xsl:stylesheet>
