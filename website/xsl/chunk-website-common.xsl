<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		version="1.0"
                exclude-result-prefixes="html doc">

<!-- ********************************************************************
     $Id$
     ******************************************************************** -->

<xsl:import href="website.xsl"/>

<xsl:output method="html"
            encoding="iso-8859-1"
/>

<!-- ==================================================================== -->

<xsl:param name="using.chunker">0</xsl:param>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="website">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="homepage">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <!-- Note that we can't call apply-imports in here because we must -->
  <!-- process webpage children *outside* of xt:document or interior -->
  <!-- webpages inherit the directory specified on their parent as   -->
  <!-- their default base directory. Which is not the intended       -->
  <!-- semantic.                                                     -->

  <xsl:variable name="page-content">
    <html>
      <xsl:apply-templates select="head" mode="head.mode"/>
      <xsl:apply-templates select="config" mode="head.mode"/>
      <body>

	<div id="{$id}" class="{name(.)}">
	  <a name="{$id}"/>

	  <xsl:call-template name="home.navhead"/>

	  <xsl:apply-templates select="./head/title" mode="title.mode"/>

	  <xsl:apply-templates select="child::*[name(.)!='webpage']"/>

	  <xsl:call-template name="process.footnotes"/>

	  <xsl:call-template name="webpage.footer"/>
	</div>
      </body>
    </html>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="method" select="'html'"/>
    <xsl:with-param name="encoding" select="'ISO-8859-1'"/>
    <xsl:with-param name="content" select="$page-content"/>
  </xsl:call-template>

  <xsl:apply-templates select="webpage"/>

</xsl:template>

<xsl:template match="webpage">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <!-- Note that we can't call apply-imports in here because we must -->
  <!-- process webpage children *outside* of xt:document or interior -->
  <!-- webpages inherit the directory specified on their parent as   -->
  <!-- their default base directory. Which is not the intended       -->
  <!-- semantic.                                                     -->

  <xsl:variable name="page-content">
    <html>
      <xsl:apply-templates select="head" mode="head.mode"/>
      <xsl:apply-templates select="config" mode="head.mode"/>
      <body>

	<div id="{$id}" class="{name(.)}">
	  <a name="{$id}"/>

	  <xsl:call-template name="page.navhead"/>

	  <xsl:apply-templates select="./head/title" mode="title.mode"/>

	  <xsl:apply-templates select="child::*[name(.)!='webpage']"/>

	  <xsl:call-template name="process.footnotes"/>

	  <xsl:call-template name="webpage.footer"/>
	</div>
      </body>
    </html>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="method" select="'html'"/>
    <xsl:with-param name="encoding" select="'ISO-8859-1'"/>
    <xsl:with-param name="content" select="$page-content"/>
  </xsl:call-template>

  <xsl:apply-templates select="webpage"/>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="homepage|webpage" mode="filename">
  <xsl:variable name="dir">
    <xsl:choose>
      <xsl:when test="config[@param='dir']/@value">
        <xsl:value-of select="config[@param='dir']/@value"/>
        <xsl:text>/</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="fname">
    <xsl:choose>
      <xsl:when test="config[@param='filename']/@value">
        <xsl:value-of select="config[@param='filename']/@value"/>
      </xsl:when>
      <xsl:otherwise>index.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="concat($dir, $fname)"/>
</xsl:template>

<xsl:template name="href.target">
  <xsl:param name="object" select="."/>
  <xsl:param name="from-page" select="(ancestor-or-self::webpage
                                       |ancestor-or-self::homepage)[last()]"/>

  <xsl:variable name="ischunk">
    <xsl:if test="local-name($object) = 'webpage'
                  or local-name($object) = 'homepage'">1</xsl:if>
    <xsl:text>0</xsl:text>
  </xsl:variable>
  <xsl:variable name="chunk" select="($object/ancestor-or-self::webpage
                                      |$object/ancestor-or-self::homepage)[last()]"/>

  <xsl:call-template name="root-rel-path">
    <xsl:with-param name="webpage" select="$from-page"/>
  </xsl:call-template>
  <xsl:apply-templates select="$chunk" mode="filename"/>

  <xsl:if test="$ischunk='0'">
    <xsl:text>#</xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$object"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="html:*">
  <xsl:element name="{local-name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*" mode="copy">
  <xsl:attribute name="{local-name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
