<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:output method="html" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="element" select="'*'"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Test</title>
        <link rel="stylesheet" type="text/css" href="html.css"/>
      </head>
      <body>
	<xsl:choose>
	  <xsl:when test="$element = '*'">
	    <xsl:apply-templates/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="//rng:define[rng:element[@name=$element]]"/>
	  </xsl:otherwise>
	</xsl:choose>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rng:start">
    <div class="start">
      <h1>
        <a name="start"/>
	<xsl:text>Start</xsl:text>
      </h1>

      <ul>
	<xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="rng:define[rng:element]" priority="2">
    <div class="define">
      <hr/>
      <h1>
        <a name="{@name}"/>
        <xsl:value-of select="@name"/>
      </h1>

      <xsl:apply-templates/>

    </div>
  </xsl:template>

  <xsl:template match="rng:define">
    <div class="define">
      <hr/>
      <h1>
        <a name="{@name}"/>
        <xsl:value-of select="@name"/>
      </h1>

      <ul>
	<xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="rng:text">
    <li><em>text</em></li>
  </xsl:template>

  <xsl:template match="rng:element">
    <div class="element">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&gt; := </xsl:text>

      <xsl:choose>
	<xsl:when test="count(rng:optional|rng:group|rng:zeroOrMore|rng:oneOrMore
		              |rng:choice|rng:interleave) &gt; 1">
	  <ul>
	    <li>Sequence of:</li>
	    <ul>
	      <xsl:apply-templates/>
	    </ul>
	  </ul>
	</xsl:when>
	<xsl:otherwise>
	  <ul>
	    <xsl:apply-templates/>
	  </ul>
	</xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="rng:attribute">
    <div class="attribute">
      <xsl:text>@</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="rng:value">
    <xsl:if test="position() &gt; 1"> | </xsl:if>
    <span class="{local-name()}">
      <xsl:text>“</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>”</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="rng:ref">
    <xsl:if test="not(contains(@name,'attrib'))">
      <li>
	<xsl:choose>
	  <xsl:when test="key('defs', @name)/rng:element">
	    <xsl:text>&lt;</xsl:text>
	    <a href="#{@name}">
	      <xsl:value-of select="key('defs', @name)/rng:element/@name"/>
	    </a>
	    <xsl:text>&gt;</xsl:text>
	    <xsl:if test="parent::rng:optional">*</xsl:if>
	  </xsl:when>
	  <xsl:otherwise>
	    <a href="#{@name}">
	      <xsl:value-of select="@name"/>
	    </a>
	    <xsl:if test="parent::rng:optional">*</xsl:if>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:optional">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore">
    <li><xsl:text>Zero or more of:</xsl:text></li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:oneOrMore">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional one or more of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One or more of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="rng:group">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional sequence of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Sequence of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:interleave">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional interleave of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Interleave of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:choice">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optionally one of: </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One of: </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

</xsl:stylesheet>
