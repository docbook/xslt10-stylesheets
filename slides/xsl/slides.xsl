<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<xsl:import href="/sourceforge/docbook/xsl/html/chunk.xsl"/>
<xsl:include href="slidechunk.xsl"/>
<xsl:include href="slidenav.xsl"/>

<xsl:strip-space elements="slides foil section"/>

<xsl:param name="chunk">1</xsl:param>
<xsl:param name="ie5">0</xsl:param>
<xsl:param name="ns4">0</xsl:param>
<xsl:param name="multiframe">0</xsl:param>

<xsl:param name="css-stylesheet">slides.css</xsl:param>
<xsl:param name="graphics.dir">graphics</xsl:param>
<xsl:param name="toc.row.height">22</xsl:param>
<xsl:param name="bullet.image" select="'bullet.gif'"/>
<xsl:param name="minus.image" select="'minus.gif'"/>
<xsl:param name="right.image" select="'right.gif'"/>
<xsl:param name="left.image" select="'left.gif'"/>

<xsl:param name="slides.js" select="'slides.js'"/>
<xsl:param name="list.js" select="'list.js'"/>
<xsl:param name="resize.js" select="'resize.js'"/>

<xsl:param name="toc.bg.color">#FFFFFF</xsl:param>
<xsl:param name="toc.width">250</xsl:param>

<xsl:attribute-set name="body-attrs">
  <xsl:attribute name="bgcolor">white</xsl:attribute>
  <xsl:attribute name="text">black</xsl:attribute>
  <xsl:attribute name="link">#0000FF</xsl:attribute>
  <xsl:attribute name="vlink">#840084</xsl:attribute>
  <xsl:attribute name="alink">#0000FF</xsl:attribute>
</xsl:attribute-set>

<!-- ============================================================ -->

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slides">
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="(slidesinfo/titleabbrev|titleabbrev)">
        <xsl:value-of select="(slidesinfo/titleabbrev|titleabbrev)[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="(slidesinfo/title|title)[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="toc.rows" select="1+count(//section)+count(//foil)"/>
  <xsl:variable name="toc.height" select="$toc.rows * $toc.row.height"/>

  <xsl:choose>
    <xsl:when test="$chunk=0">
      <!--nop-->
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="'frames.html'"/>
        <xsl:with-param name="content">
          <html>
            <head>
              <title><xsl:value-of select="$title"/></title>
            </head>
            <frameset border="1" cols="{$toc.width},*" name="topframe">
              <frame src="toc.html" name="toc"/>
              <frame src="titlefoil.html" name="foil"/>
              <noframes>
                <body class="frameset" xsl:use-attribute-sets="body-attrs">
                  <a href="titleframe.html">
                    <xsl:text>Your browser doesn't support frames.</xsl:text>
                  </a>
                </body>
              </noframes>
            </frameset>
          </html>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$chunk=0">
      <html>
        <body class="foil" xsl:use-attribute-sets="body-attrs">
          <xsl:apply-templates/>
        </body>
      </html>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$ie5 != 0">
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename" select="'ie5toc.html'"/>
          <xsl:with-param name="content">
            <html>
              <head>
                <title>TOC - <xsl:value-of select="$title"/></title>
                <link type="text/css" rel="stylesheet"
                      href="{$css-stylesheet}"/>
                <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
              </head>
              <body class="toc" xsl:use-attribute-sets="body-attrs"
                    onload="newPage('toc.html');">
                <div class="toc">
                  <xsl:apply-templates mode="toc"/>
                </div>
              </body>
            </html>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$ns4 != 0">
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename" select="'ns4toc.html'"/>
          <xsl:with-param name="content">
            <html>
              <head>
                <title>TOC - <xsl:value-of select="$title"/></title>
                <link type="text/css" rel="stylesheet"
                      href="{$css-stylesheet}"/>
                <script type="text/javascript" language="JavaScript1.2" src="{$list.js}"></script>
                <script type="text/javascript" language="JavaScript1.2" src="{$resize.js}"></script>
                <script type="text/javascript" language="JavaScript"><xsl:text>
function init() {
  var width = </xsl:text>
<xsl:value-of select="$toc.width"/>
<xsl:text>, height = </xsl:text>
<xsl:value-of select="$toc.row.height"/>
<xsl:text>;
  myList = new List(true, width, height, "</xsl:text>
<xsl:value-of select="$toc.bg.color"/>
<xsl:text>");
</xsl:text>
                <xsl:apply-templates mode="ns-toc"/>
<xsl:text>
  myList.build(0,0);
}
</xsl:text>
                </script>
                <style type="text/css"><xsl:text>
  #spacer { position: absolute; height: </xsl:text>
                <xsl:value-of select="$toc.height"/>
  <xsl:text>; }
</xsl:text>
</style>
              </head>
              <body class="toc" xsl:use-attribute-sets="body-attrs"
                    onload="init();">
                <div id="spacer"></div>
              </body>
            </html>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="'toc.html'"/>
        <xsl:with-param name="content">
          <html>
            <head>
              <title>TOC - <xsl:value-of select="$title"/></title>
              <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
              <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
              <script type="text/javascript" language="JavaScript">
                <xsl:if test="$ns4 != 0">
                  <xsl:text><![CDATA[
if (selectBrowser() == "ns4") {
      location.replace("ns4toc.html");
}
]]></xsl:text>
                </xsl:if>
                <xsl:if test="$ie5 != 0">
                  <xsl:text><![CDATA[
if (selectBrowser() == "ie5") {
      location.replace("ie5toc.html");
}
]]></xsl:text>
                </xsl:if>
              </script>
            </head>
            <body class="toc" xsl:use-attribute-sets="body-attrs">
              <div class="toc">
                <xsl:apply-templates mode="toc"/>
              </div>
            </body>
          </html>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo">
  <xsl:choose>
    <xsl:when test="$chunk=0">
      <div class="{name(.)}">
	<xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="'titlefoil.html'"/>
        <xsl:with-param name="content">
          <html>
            <head>
              <title><xsl:value-of select="title"/></title>
              <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
              <xsl:if test="$ie5 != '0'">
                <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
              </xsl:if>
            </head>
            <body class="titlepage" xsl:use-attribute-sets="body-attrs">
              <xsl:if test="$ie5!='0'">
                <xsl:attribute name="onload">
                  <xsl:text>newPage('titlefoil.html');</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="onkeypress">
                  <xsl:text>navigate('','foil01.html');</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <div class="{name(.)}">
                <xsl:apply-templates mode="titlepage.mode"/>
              </div>

              <xsl:choose>
                <xsl:when test="$multiframe=0">
                  <div class="navfoot" style="padding-top: 2in;">
                    <table width="100%" border="0"
                           cellspacing="0" cellpadding="0"
                           summary="Navigation">
                      <tr>
                        <td align="left" width="80%" valign="top">
                          <span class="navfooter">
                            <xsl:apply-templates select="/slides/slidesinfo/copyright"
                                                 mode="slide.navigation.mode"/>
                          </span>
                        </td>
                        <td align="right" width="20%" valign="top">
                          <a href="foil01.html">
                            <img alt="Next" src="{$graphics.dir}/{$right.image}" border="0"/>
                          </a>
                        </td>
                      </tr>
                    </table>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <div class="navfoot" style="padding-top: 2in;">
                    <table width="100%" border="0"
                           cellspacing="0" cellpadding="0"
                           summary="Navigation">
                      <tr>
                        <td align="center" width="100%" valign="top">
                          <span class="navfooter">
                            <xsl:apply-templates select="/slides/slidesinfo/copyright"
                                                 mode="slide.navigation.mode"/>
                          </span>
                        </td>
                      </tr>
                    </table>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </body>
          </html>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="slidesinfo/title">
  <h1 class="{name(.)}"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="slidesinfo/authorgroup">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo/author|slidesinfo/authorgroup/author">
  <h1 class="{name(.)}"><xsl:apply-imports/></h1>
</xsl:template>

<xsl:template match="slidesinfo/releaseinfo">
  <h4 class="{name(.)}"><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="slidesinfo/date">
  <h4 class="{name(.)}"><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="slidesinfo/copyright">
  <xsl:if test="$chunk=0">
    <xsl:apply-templates select="." mode="titlepage.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template match="copyright" mode="slide.navigation.mode">
  <xsl:variable name="years" select="year"/>
  <xsl:variable name="holders" select="holder"/>

  <span class="{name(.)}">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="$years" mode="titlepage.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="$holders" mode="titlepage.mode"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="section">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="foil[1]" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding::foil">
        <xsl:apply-templates select="preceding::foil[1]" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$chunk=0">
      <hr/>
      <div class="{name(.)}" id="{$id}">
	<a name="{$id}"/>
	<xsl:apply-templates select="title"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$thissection"/>
        <xsl:with-param name="content">
          <head>
            <title><xsl:value-of select="title"/></title>
            <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
            <xsl:if test="$ie5 != '0'">
              <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
            </xsl:if>
          </head>
          <xsl:choose>
            <xsl:when test="$multiframe != 0">
              <xsl:apply-templates select="." mode="multiframe"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="singleframe"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$multiframe != 0">
    <xsl:apply-templates select="." mode="multiframe-top"/>
    <xsl:apply-templates select="." mode="multiframe-body"/>
    <xsl:apply-templates select="." mode="multiframe-bottom"/>
  </xsl:if>

  <xsl:apply-templates select="foil"/>
</xsl:template>

<xsl:template match="section" mode="multiframe">
  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <frameset rows="25,*,25" border="0" name="foil" framespacing="0">
    <frame src="top-{$thissection}" name="top" marginheight="0" scrolling="no"/>
    <frame src="body-{$thissection}" name="body" marginheight="0"/>
    <frame src="bot-{$thissection}" name="bottom" marginheight="0" scrolling="no"/>
    <noframes>
      <body class="frameset" xsl:use-attribute-sets="body-attrs">
        <p>
          <xsl:text>Your browser doesn't support frames.</xsl:text>
        </p>
      </body>
    </noframes>
  </frameset>
</xsl:template>

<xsl:template match="section" mode="multiframe-top">
  <xsl:variable name="section">
    <xsl:text>section</xsl:text>
    <xsl:number count="section" level="any" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('top-',$section)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="section-top-nav"/>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="multiframe-body">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="foil[1]" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding::foil">
        <xsl:apply-templates select="preceding::foil[1]" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('body-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Body</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
          <style type="text/css">div.section { margin-top: 3em }</style>
        </head>
        <xsl:apply-templates select="." mode="singleframe"/>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="multiframe-bottom">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="foil[1]" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding::foil">
        <xsl:apply-templates select="preceding::foil[1]" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('bot-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="section-bottom-nav"/>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="singleframe">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="foil[1]" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding::foil">
        <xsl:apply-templates select="preceding::foil[1]" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <body class="section" xsl:use-attribute-sets="body-attrs">
    <xsl:if test="$ie5!='0'">
      <xsl:attribute name="onload">
        <xsl:text>newPage('</xsl:text>
        <xsl:value-of select="$thissection"/>
        <xsl:text>');</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate('</xsl:text>
        <xsl:value-of select="$prevfoil"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="$nextfoil"/>
        <xsl:text>')</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <div class="{name(.)}" id="{$id}">
      <a name="{$id}"/>
      <xsl:if test="$multiframe=0">
        <xsl:call-template name="section-top-nav"/>
        <hr/>
      </xsl:if>

      <div class="{name(.)}" id="{$id}">
        <a name="{$id}"/>
        <xsl:apply-templates select="title"/>
      </div>

      <xsl:if test="$multiframe=0">
        <hr/>
        <xsl:call-template name="section-bottom-nav"/>
      </xsl:if>
    </div>
  </body>
</xsl:template>

<xsl:template match="section/title">
  <h1 class="{name(.)}"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="section/title" mode="navheader">
  <span class="navheader"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="slides/title" mode="navheader">
  <span class="navheader"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="slides/slidesinfo/title" mode="navheader">
  <span class="navheader"><xsl:apply-templates/></span>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="foil">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="section" select="ancestor::section"/>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="(following::foil
                                 |following::section)[1]"
                         mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding-sibling::foil">
        <xsl:apply-templates select="preceding-sibling::foil[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:when test="parent::section">
        <xsl:apply-templates select="parent::section[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$chunk=0">
      <hr/>
      <div class="{name(.)}" id="{$id}">
	<a name="{$id}"/>
	<xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$thisfoil"/>
        <xsl:with-param name="content">
          <head>
            <title><xsl:value-of select="title"/></title>
            <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
            <xsl:if test="$ie5 != '0'">
              <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
            </xsl:if>
          </head>
          <xsl:choose>
            <xsl:when test="$multiframe != 0">
              <xsl:apply-templates select="." mode="multiframe"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="singleframe"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$multiframe != 0">
    <xsl:apply-templates select="." mode="multiframe-top"/>
    <xsl:apply-templates select="." mode="multiframe-body"/>
    <xsl:apply-templates select="." mode="multiframe-bottom"/>
  </xsl:if>
</xsl:template>

<xsl:template match="foil" mode="multiframe">
  <xsl:variable name="section" select="ancestor::section"/>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="(following::foil
                                 |following::section)[1]"
                         mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding-sibling::foil">
        <xsl:apply-templates select="preceding-sibling::foil[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:when test="parent::section">
        <xsl:apply-templates select="parent::section[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <frameset rows="25,*,25" border="0" name="foil" framespacing="0">
    <xsl:attribute name="onkeypress">
      <xsl:text>navigate('</xsl:text>
      <xsl:value-of select="$prevfoil"/>
      <xsl:text>','</xsl:text>
      <xsl:value-of select="$nextfoil"/>
      <xsl:text>')</xsl:text>
    </xsl:attribute>
    <frame src="top-{$thisfoil}" name="top" marginheight="0" scrolling="no">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate('</xsl:text>
        <xsl:value-of select="$prevfoil"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="$nextfoil"/>
        <xsl:text>')</xsl:text>
      </xsl:attribute>
    </frame>
    <frame src="body-{$thisfoil}" name="body" marginheight="0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate('</xsl:text>
        <xsl:value-of select="$prevfoil"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="$nextfoil"/>
        <xsl:text>')</xsl:text>
      </xsl:attribute>
    </frame>
    <frame src="bot-{$thisfoil}" name="bottom" marginheight="0" scrolling="no">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate('</xsl:text>
        <xsl:value-of select="$prevfoil"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="$nextfoil"/>
        <xsl:text>')</xsl:text>
      </xsl:attribute>
    </frame>
    <noframes>
      <body class="frameset" xsl:use-attribute-sets="body-attrs">
        <p>
          <xsl:text>Your browser doesn't support frames.</xsl:text>
        </p>
      </body>
    </noframes>
  </frameset>
</xsl:template>

<xsl:template match="foil" mode="multiframe-top">
  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('top-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="foil-top-nav"/>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="foil" mode="multiframe-body">
  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('body-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Body</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
        </head>
        <xsl:apply-templates select="." mode="singleframe"/>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="foil" mode="multiframe-bottom">
  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('bot-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet" href="{$css-stylesheet}"/>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript" src="{$slides.js}"/>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="foil-bottom-nav"/>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="foil" mode="singleframe">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="section" select="ancestor::section"/>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="nextfoil">
    <xsl:apply-templates select="(following::foil
                                 |following::section)[1]"
                         mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil">
    <xsl:choose>
      <xsl:when test="preceding-sibling::foil">
        <xsl:apply-templates select="preceding-sibling::foil[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:when test="parent::section">
        <xsl:apply-templates select="parent::section[1]"
                             mode="filename"/>
      </xsl:when>
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <body class="foil" xsl:use-attribute-sets="body-attrs">
    <xsl:if test="$ie5!='0'">
      <xsl:attribute name="onload">
        <xsl:text>newPage('</xsl:text>
        <xsl:value-of select="$thisfoil"/>
        <xsl:text>');</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate('</xsl:text>
        <xsl:value-of select="$prevfoil"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="$nextfoil"/>
        <xsl:text>')</xsl:text>
      </xsl:attribute>
    </xsl:if>

    <div class="{name(.)}" id="{$id}">
      <a name="{$id}"/>
      <xsl:if test="$multiframe=0">
        <xsl:call-template name="foil-top-nav"/>
        <hr/>
      </xsl:if>

      <xsl:apply-templates/>

      <xsl:if test="$multiframe=0">
        <hr/>
        <xsl:call-template name="foil-bottom-nav"/>
      </xsl:if>
    </div>
  </body>
</xsl:template>

<xsl:template match="foil" mode="foilnumber">
  <xsl:number count="foil" level="any"/>
</xsl:template>

<xsl:template match="foil" mode="filename">
  <xsl:text>foil</xsl:text>
  <xsl:number count="foil" level="any" format="01"/>
  <xsl:text>.html</xsl:text>
</xsl:template>

<xsl:template match="section" mode="filename">
  <xsl:text>section</xsl:text>
  <xsl:number count="section" level="any" format="01"/>
  <xsl:text>.html</xsl:text>
</xsl:template>

<xsl:template match="foil/title">
  <h1 class="{name(.)}">
    <xsl:if test="$chunk=0">
      <xsl:text>Slide </xsl:text>
      <xsl:apply-templates select="parent::*" mode="foilnumber"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="processing-instruction('Pub')">
  <xsl:variable name="pidata"><xsl:value-of select="(.)"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($pidata,'UDT')"></xsl:when>
    <xsl:when test="contains($pidata,'/_font')">
      <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
    </xsl:when>
    <xsl:when test="contains($pidata,'_font')">
      <xsl:text disable-output-escaping="yes">&lt;span </xsl:text>
      <xsl:choose>
        <xsl:when test="contains($pidata,'green')">class="green"</xsl:when>
        <xsl:when test="contains($pidata,'orange')">class="orange"</xsl:when>
        <xsl:when test="contains($pidata,'red')">class="red"</xsl:when>
        <xsl:when test="contains($pidata,'brown')">class="brown"</xsl:when>
        <xsl:when test="contains($pidata,'violet')">class="violet"</xsl:when>
        <xsl:when test="contains($pidata,'black')">class="black"</xsl:when>
        <xsl:otherwise>weight="bold"</xsl:otherwise>
      </xsl:choose>
      <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->
<!-- blocks -->

<xsl:template match="figure">
  <div class="{name(.)}">
    <xsl:apply-imports/>
  </div>
  <xsl:if test="following-sibling::*"><hr/></xsl:if>
</xsl:template>

<!-- ============================================================ -->
<!-- inlines -->

<xsl:template match="emphasis">
  <i class="emphasis"><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="ulink">
  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:if test="$ulink.target != ''">
      <xsl:attribute name="target">
        <xsl:value-of select="$ulink.target"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
	<xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
        <xsl:if test="@role='show'">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@url"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="title/ulink">
  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:if test="$ulink.target != ''">
      <xsl:attribute name="target">
        <xsl:value-of select="$ulink.target"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
	<xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="graphic">
  <center>
    <!-- can't this be done a better way? -->
    <xsl:apply-imports/>
  </center>
</xsl:template>

<xsl:template match="titleabbrev">
  <!-- nop -->
</xsl:template>

<xsl:template match="speakernotes">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="foil" mode="foil-filename">
  <xsl:text>foil</xsl:text>
  <xsl:number count="foil" level="any" format="01"/>
  <xsl:text>.html</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo" mode="toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <div id="{$id}" class="toc-slidesinfo">
    <a href="titlefoil.html" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
    <hr/>
  </div>
</xsl:template>

<xsl:template match="section" mode="toc">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <div class="toc-section" id="{$id}">
    <img src="{$graphics.dir}/{$minus.image}" alt="-"/>
    <a href="{$thissection}" target="foil">
      <xsl:apply-templates select="title" mode="toc"/>
    </a>
    <xsl:apply-templates select="foil" mode="toc"/>
  </div>
</xsl:template>

<xsl:template match="foil" mode="toc">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="foil">
    <xsl:apply-templates select="." mode="foil-filename"/>
  </xsl:variable>

  <div id="{$id}" class="toc-foil">
    <img src="{$graphics.dir}/{$bullet.image}" alt="-"/>
    <a href="{$foil}" target="foil">
      <xsl:apply-templates select="title" mode="toc"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="title|titleabbrev" mode="toc">
  <xsl:apply-templates mode="toc"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo" mode="ns-toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:text>myList.addItem('</xsl:text>
  <div id="{$id}" class="toc-slidesinfo">
    <a href="titlefoil.html" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:value-of select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </div>
  <xsl:text>');&#10;</xsl:text>
</xsl:template>

<xsl:template match="section" mode="ns-toc">
  <xsl:variable name="foil">
    <xsl:apply-templates select="foil[1]" mode="foil-filename"/>
  </xsl:variable>

  <xsl:text>subList = new List(false, width, height, "</xsl:text>
<xsl:value-of select="$toc.bg.color"/>
<xsl:text>");&#10;</xsl:text>
  <xsl:text>subList.setIndent(12);&#10;</xsl:text>
  <xsl:apply-templates select="foil" mode="ns-toc"/>

  <xsl:text>myList.addList(subList, '</xsl:text>
  <div class="toc-section">
    <a href="{$foil}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:value-of select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </div>
  <xsl:text>');&#10;</xsl:text>

</xsl:template>

<xsl:template match="foil" mode="ns-toc">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="foil">
    <xsl:apply-templates select="." mode="foil-filename"/>
  </xsl:variable>

  <xsl:text>subList.addItem('</xsl:text>
  <div id="{$id}" class="toc-foil">
    <img src="{$graphics.dir}/{$bullet.image}" alt="-"/>
    <a href="{$foil}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:value-of select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </div>
  <xsl:text>');&#10;</xsl:text>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
