<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:template match="head" mode="head.mode">
  <xsl:variable name="nodes" select="*"/>
  <xsl:variable name="global"
                select="/website/homepage/head/*[@class='global']"/>
  <head>
    <meta name="generator" content="Website XSL Stylesheet V{$WSVERSION}"/>
    <xsl:if test="$html.stylesheet != ''">
      <link rel="stylesheet" href="{$html.stylesheet}" type="text/css">
	<xsl:if test="$html.stylesheet.type != ''">
	  <xsl:attribute name="type">
	    <xsl:value-of select="$html.stylesheet.type"/>
	  </xsl:attribute>
	</xsl:if>
      </link>
    </xsl:if>
    <xsl:apply-templates select="$nodes" mode="head.mode"/>
    <xsl:if test="not(.=/website/homepage/head)">
      <xsl:call-template name="process.globals">
        <xsl:with-param name="nodelist" select="$global"/>
      </xsl:call-template>
    </xsl:if>
    <!-- this is potentially slow -->
    <xsl:if test="..//xlink[@role='dynamic']">
      <script src="dynxbel.js" language="JavaScript"/>
    </xsl:if>
  </head>
</xsl:template>

<xsl:template name="process.globals">
  <xsl:param name="nodelist"></xsl:param>
  <xsl:if test="count($nodelist)>0">
    <xsl:variable name="node" select="$nodelist[1]"/>
    <xsl:variable name="rest" select="$nodelist[position()>1]"/>
    <xsl:apply-templates select="$node" mode="head.mode">
      <xsl:with-param name="current.page" select="ancestor-or-self::webpage"/>
    </xsl:apply-templates>
    <xsl:call-template name="process.globals">
      <xsl:with-param name="nodelist" select="$rest"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="title" mode="head.mode">
  <title><xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="titleabbrev" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="subtitle" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="summary" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="keywords" mode="head.mode">
  <meta name="keyword" content="{.}"/>
</xsl:template>

<xsl:template match="copyright" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="author" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="edition" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="meta" mode="head.mode">
  <meta name="{@name}" content="{@content}"/>
</xsl:template>

<xsl:template match="script" mode="head.mode">
  <script>
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:attribute name="language">
	  <xsl:value-of select="@language"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="language">JavaScript</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates/>

  </script>
</xsl:template>

<xsl:template match="script[@src]" mode="head.mode">
  <xsl:param name="current.page" select="ancestor-or-self::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$current.page"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="language">
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>JavaScript</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <script src="{$relpath}{@src}" language="{$language}"></script>
</xsl:template>

<xsl:template match="style" mode="head.mode">
  <style>
    <xsl:if test="@type">
      <xsl:attribute name="type">
	<xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates/>

  </style>
</xsl:template>

<xsl:template match="style[@src]" mode="head.mode">
  <xsl:param name="current.page" select="ancestor-or-self::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$current.page"/>
    </xsl:call-template>
  </xsl:variable>
  <link rel="stylesheet" href="{$relpath}{@src}" type="text/css">
    <xsl:if test="@type">
      <xsl:attribute name="type">
	<xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>
  </link>
</xsl:template>

<xsl:template match="abstract" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="revhistory" mode="head.mode">
  <!--nop-->
</xsl:template>

</xsl:stylesheet>