<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../../../../../xsl/html/docbook.xsl"/>

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>

  <link rel="stylesheet" type="text/css"
	href="http://docbook.org/docs/howto/howto.css" />
</xsl:template>

<xsl:template name="article.titlepage">
  <div class="titlepage">
    <xsl:apply-templates select="info" mode="howto-titlepage"/>
    <hr/>
  </div>
</xsl:template>

<xsl:template match="info" mode="howto-titlepage">
  <xsl:apply-templates select="title" mode="howto-titlepage"/>
  <xsl:apply-templates select="subtitle" mode="howto-titlepage"/>
  <xsl:apply-templates select="bibliocoverage[@temporal][1]"
		       mode="howto-titlepage"/>
  <div class="metadata">
    <xsl:apply-templates select="bibliocoverage[@temporal][1]"
			 mode="version-list"/>
    <xsl:apply-templates select="authorgroup" mode="howto-titlepage"/>
  </div>
</xsl:template>

<xsl:template match="title" mode="howto-titlepage">
  <h1>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="subtitle" mode="howto-titlepage">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="bibliocoverage[@temporal]" mode="howto-titlepage">
  <h3>
    <xsl:call-template name="datetime.format">
      <xsl:with-param name="date" select="."/>
      <xsl:with-param name="format" select="'d B Y'"/>
    </xsl:call-template>
  </h3>
</xsl:template>

<xsl:template match="bibliocoverage[1]" priority="10"
	      mode="version-list">
  <h4>This version:</h4>
  <dl class="urilist">
    <dt>
      <xsl:apply-templates select="." mode="datedURI"/>
    </dt>
  </dl>

  <h4>Latest version:</h4>
  <dl class="urilist">
    <dt>
      <span>http://docbook.org/docs/howto/</span>
      <xsl:text> (</xsl:text>
      <a href="http://docbook.org/docs/howto/">HTML</a>
      <xsl:text>, </xsl:text>
      <a href="http://docbook.org/docs/howto/howto.xml">XML</a>
      <xsl:text>, </xsl:text>
      <a href="http://docbook.org/docs/howto/howto.pdf">PDF</a>
      <xsl:text>)</xsl:text>
    </dt>
  </dl>

  <xsl:if test="following-sibling::bibliocoverage[@temporal]">
    <h4>
      <xsl:text>Previous version</xsl:text>
      <xsl:if test="count(following-sibling::bibliocoverage[@temporal]) &gt; 1">
	<xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </h4>
    <dl class="urilist">
      <xsl:apply-templates
	  select="following-sibling::bibliocoverage[@temporal]"
	  mode="version-list"/>
    </dl>
  </xsl:if>
</xsl:template>

<xsl:template match="bibliocoverage" mode="version-list">
  <xsl:if test="count(preceding-sibling::bibliocoverage[@temporal]) &lt; 4">
    <dt>
      <xsl:apply-templates select="." mode="datedURI"/>
    </dt>
  </xsl:if>
</xsl:template>

<xsl:template match="bibliocoverage" mode="datedURI">
  <xsl:variable name="uri">
    <xsl:text>http://docbook.org/docs/howto/</xsl:text>
    <xsl:value-of select="substring(.,1,4)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring(.,6,2)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring(.,9,2)"/>
    <xsl:text>/</xsl:text>
  </xsl:variable>

  <span>
    <xsl:value-of select="$uri"/>
  </span>
  <xsl:text> (</xsl:text>
  <a href="{$uri}">HTML</a>
  <xsl:text>, </xsl:text>
  <a href="{$uri}howto.xml">XML</a>
  <xsl:text>, </xsl:text>
  <a href="{$uri}howto.pdf">PDF</a>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="authorgroup" mode="howto-titlepage">
  <h4>
    <xsl:text>Editor</xsl:text>
    <xsl:if test="count(author) &gt; 1">s</xsl:if>
    <xsl:text>:</xsl:text>
  </h4>
  <dl class="editorlist">
    <xsl:apply-templates select="author" mode="howto-titlepage"/>
  </dl>
</xsl:template>

<xsl:template match="author" mode="howto-titlepage">
  <dt>
    <xsl:apply-templates select="personname"/>
    <xsl:if test="email">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="email"/>
    </xsl:if>
  </dt>
</xsl:template>

</xsl:stylesheet>
