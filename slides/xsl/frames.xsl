<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="slides.xsl"/>

<xsl:param name="titlefoil.html" select="'titlefoil.html'"/>

<xsl:param name="ns4" select="0"/>
<xsl:param name="ie5" select="0"/>
<xsl:param name="multiframe" select="0"/>

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

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="'frames.html'"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="$title"/></title>
        </head>
        <frameset border="1" cols="{$toc.width},*" name="topframe">
          <frame src="toc.html" name="toc"/>
          <frame src="{$titlefoil.html}" name="foil"/>
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

  <xsl:if test="$ie5 != 0">
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="'ie5toc.html'"/>
      <xsl:with-param name="content">
        <html>
          <head>
            <title>TOC - <xsl:value-of select="$title"/></title>
            <link type="text/css" rel="stylesheet">
              <xsl:attribute name="href">
                <xsl:call-template name="css-stylesheet"/>
              </xsl:attribute>
            </link>
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
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
            <link type="text/css" rel="stylesheet">
              <xsl:attribute name="href">
                <xsl:call-template name="css-stylesheet"/>
              </xsl:attribute>
            </link>
            <script type="text/javascript" language="JavaScript1.2">
              <xsl:attribute name="src">
                <xsl:call-template name="list.js"/>
              </xsl:attribute>
            </script>
            <script type="text/javascript" language="JavaScript1.2">
              <xsl:attribute name="src">
                <xsl:call-template name="resize.js"/>
              </xsl:attribute>
            </script>
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
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <script type="text/javascript" language="JavaScript">
            <xsl:attribute name="src">
              <xsl:call-template name="slides.js"/>
            </xsl:attribute>
          </script>
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
</xsl:template>

<xsl:template match="slidesinfo">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$titlefoil.html"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
          </xsl:if>
        </head>
        <body class="titlepage" xsl:use-attribute-sets="body-attrs">
          <xsl:if test="$ie5!='0'">
            <xsl:attribute name="onload">
              <xsl:text>newPage('</xsl:text>
              <xsl:value-of select="$titlefoil.html"/>
              <xsl:text>');</xsl:text>
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
                        <img alt="Next" border="0">
                          <xsl:attribute name="src">
                            <xsl:call-template name="graphics.dir"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="$right.image"/>
                          </xsl:attribute>
                        </img>
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
</xsl:template>

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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$thissection"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css-stylesheet"/>
          </xsl:attribute>
        </link>
        <xsl:if test="$ie5 != '0'">
          <script type="text/javascript" language="JavaScript">
            <xsl:attribute name="src">
              <xsl:call-template name="slides.js"/>
            </xsl:attribute>
          </script>
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
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="section-top-nav">
            <xsl:with-param name="prev-target" select="'foil'"/>
            <xsl:with-param name="next-target" select="'foil'"/>
          </xsl:call-template>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('body-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Body</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat('bot-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$thisfoil"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css-stylesheet"/>
          </xsl:attribute>
        </link>
        <xsl:if test="$ie5 != '0'">
          <script type="text/javascript" language="JavaScript">
            <xsl:attribute name="src">
              <xsl:call-template name="slides.js"/>
            </xsl:attribute>
          </script>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
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
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
          </xsl:if>
        </head>
        <body class="navigation">
          <xsl:call-template name="foil-top-nav">
            <xsl:with-param name="prev-target" select="'foil'"/>
            <xsl:with-param name="next-target" select="'foil'"/>
          </xsl:call-template>
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
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
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
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css-stylesheet"/>
            </xsl:attribute>
          </link>
          <xsl:if test="$ie5 != '0'">
            <script type="text/javascript" language="JavaScript">
              <xsl:attribute name="src">
                <xsl:call-template name="slides.js"/>
              </xsl:attribute>
            </script>
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
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
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

<!-- ============================================================ -->

<xsl:template match="slidesinfo" mode="toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <div id="{$id}" class="toc-slidesinfo">
    <a href="{$titlefoil.html}" target="foil">
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
    <img alt="-">
      <xsl:attribute name="src">
        <xsl:call-template name="graphics.dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$minus.image"/>
      </xsl:attribute>
    </img>
    <a href="{$thissection}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
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
    <img alt="-">
      <xsl:attribute name="src">
        <xsl:call-template name="graphics.dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$bullet.image"/>
      </xsl:attribute>
    </img>
    <a href="{$foil}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </div>
</xsl:template>

</xsl:stylesheet>
