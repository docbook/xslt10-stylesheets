<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!-- Generate an S5 slide show. See http://www.meyerweb.com/eric/tools/s5/ -->

<xsl:import href="https://cdn.docbook.org/release/xsl/current/xhtml/docbook.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	    method="xml"/>

<xsl:template match="slides">
  <html>
    <head>
      <title>
	<xsl:value-of select="slidesinfo/title"/>
      </title>
      <meta name="version" content="S5 1.1" />
      <meta name="generator" content="docbook-slides-xsl" />
      <xsl:if test="slidesinfo/pubdate">
        <meta name="presdate" content="{slidesinfo/pubdate}" />        
      </xsl:if>
      <!--<meta name="author" content="[author's name]" />-->
      <!--<meta name="company" content="[author's employer]" />-->
      <!--<meta http-equiv="Content-Type" content="[content-type]" />-->
      <meta name="defaultView" content="slideshow" />
      <meta name="controlVis" content="hidden" />

      <link rel="stylesheet" href="ui/slides.css" type="text/css"
	    media="projection" id="slideProj" />
      <link rel="stylesheet" href="ui/outline.css" type="text/css"
            media="screen" id="outlineStyle" />
      <link rel="stylesheet" href="ui/opera.css"
	    type="text/css" media="projection" id="operaFix" />
      <link rel="stylesheet" href="ui/print.css"
	    type="text/css" media="print" id="slidePrint" />
      <style type="text/css" media="all">
        .imgcon {width: 525px; margin: 0 auto; padding: 0; text-align: center;}
        #anim {width: 270px; height: 320px; position: relative; margin-top: 0.5em;}
        #anim img {position: absolute; top: 42px; left: 24px;}
        img#me01 {top: 0; left: 0;}
        img#me02 {left: 23px;}
        img#me04 {top: 44px;}
        img#me05 {top: 43px;left: 36px;}
      </style>
      <script src="ui/slides.js" type="text/javascript"></script>
    </head>
    <body>
      <div class="layout">
        <div id="controls"><!-- DO NOT EDIT --></div>
        <div id="currentSlide"><!-- DO NOT EDIT --></div>
	<div id="header"/>
	<div id="footer">
          <xsl:if test="slidesinfo/pubdate">
            <h1><xsl:value-of select="slidesinfo/pubdate"/></h1>        
          </xsl:if>
	  <h2><xsl:value-of select="slidesinfo/title"/></h2>
	  <div id="controls"/>
	</div>
<!--
	<div class="topleft">[top left layout bit]</div>
	<div class="topright">[top right layout bit]</div>
	<div class="bottomleft">[bottom left layout bit]</div>
	<div class="bottomright">[bottom right layout bit]</div>
-->
      </div>
      <div class="presentation">
	<xsl:apply-templates/>
      </div>
    </body>
  </html>
</xsl:template>

<xsl:template match="slidesinfo">
  <div class="slide">
    <xsl:apply-templates select="*" mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="foilgroup">
  <div class="slide">
    <h1>
      <xsl:value-of select="title"/>
    </h1>
    <div class="slidecontent">
      <ul>
        <xsl:for-each select="preceding-sibling::foilgroup">
          <li class="previous">
            <xsl:apply-templates select="title" mode="show"/>
          </li>
        </xsl:for-each>
        <li>
          <xsl:apply-templates select="title" mode="show"/>
          <ul>
            <xsl:for-each select="foil">
              <li>
                <xsl:apply-templates select="title" mode="show"/>
              </li>
            </xsl:for-each>
          </ul>
        </li>
        <xsl:for-each select="following-sibling::foilgroup">
          <li class="following">
            <xsl:apply-templates select="title" mode="show"/>
          </li>
        </xsl:for-each>
      </ul>
    </div>
    <div class="handout">
      <p>handout</p>
    </div>
  </div>
  <xsl:apply-templates select="foil"/>
</xsl:template>

<xsl:template match="foil">
  <div class="slide">
    <h1>
      <xsl:value-of select="title"/>
    </h1>
    <div class="slidecontent">
      <xsl:apply-templates/>
    </div>
    <div class="handout">
      <p>handout</p>
    </div>
  </div>
</xsl:template>

<xsl:template match="foil/title" priority="200"/>
<xsl:template match="foil/titleabbrev" priority="200"/>

</xsl:stylesheet>
