<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="slides.xsl"/>

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

  <xsl:if test="$overlay != 0 and $multiframe != 0">
    <xsl:message terminate='yes'>
      <xsl:text>Multiframe and overlay are mutually exclusive.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'frames.html')"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="$title"/></title>
        </head>
        <frameset border="1" cols="{$toc.width},*" name="topframe" framespacing="0">
          <frame src="toc.html" name="toc" frameborder="1"/>
          <frame src="{$titlefoil.html}" name="foil"/>
          <noframes>
            <body class="frameset">
              <xsl:call-template name="body.attributes"/>
              <a href="titleframe.html">
                <xsl:text>Your browser doesn't support frames.</xsl:text>
              </a>
            </body>
          </noframes>
        </frameset>
      </html>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'toc.html')"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>TOC - <xsl:value-of select="$title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0
                        or $overlay.logo != ''">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0' or $overlay.logo != ''">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$dynamic.toc != 0">
            <script language="JavaScript"><xsl:text>
function init() {
  var width = </xsl:text>
<xsl:value-of select="$toc.width"/>
<xsl:text>, height = </xsl:text>
<xsl:value-of select="$toc.row.height"/>
<xsl:text>;
  myList = new List(true, width, height, "</xsl:text>
<xsl:value-of select="$toc.bg.color"/>
<xsl:text>","</xsl:text>
<xsl:call-template name="plus.image"/>
<xsl:text>","</xsl:text>
<xsl:call-template name="minus.image"/>
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
          </xsl:if>
        </head>
        <body class="toc">
          <xsl:call-template name="body.attributes"/>

          <xsl:if test="$overlay.logo != ''">
            <xsl:attribute name="onload">
              <xsl:text>overlaySetup('lc');</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="$dynamic.toc != 0">
            <xsl:attribute name="onload">
              <xsl:text>init(</xsl:text>
              <xsl:value-of select="$overlay"/>
              <xsl:text>);</xsl:text>
              <xsl:if test="$overlay.logo != ''">
                <xsl:text>overlaySetup('lc');</xsl:text>
              </xsl:if>
            </xsl:attribute>
          </xsl:if>

          <xsl:choose>
            <xsl:when test="$dynamic.toc = 0">
              <div class="toc">
                <xsl:apply-templates mode="toc"/>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div id="spacer"/>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="$overlay.logo != ''">
            <div style="position: absolute; visibility: visible;" id="overlayDiv">
              <img src="{$overlay.logo}" alt="logo" vspace="20"/>
            </div>
          </xsl:if>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename"
                    select="concat($base.dir,$titlefoil.html)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <link rel="next">
            <xsl:attribute name="href">
              <xsl:apply-templates select="(following::section|following::foil)[1]"
                                   mode="filename"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="(following::section|following::foil)[1]/title"/>
            </xsl:attribute>
          </link>

          <xsl:for-each select="../section">
            <link rel="section">
              <xsl:attribute name="href">
                <xsl:apply-templates select="." mode="filename"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="title[1]"/>
              </xsl:attribute>
            </link>
          </xsl:for-each>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
        </head>
        <body class="titlepage">
          <xsl:call-template name="body.attributes"/>
          <xsl:choose>
            <xsl:when test="$active.toc != 0">
              <xsl:attribute name="onload">
                <xsl:text>newPage('</xsl:text>
                <xsl:value-of select="$titlefoil.html"/>
                <xsl:text>',</xsl:text>
                <xsl:value-of select="$overlay"/>
                <xsl:text>);</xsl:text>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$overlay != 0">
              <xsl:attribute name="onload">
                <xsl:text>overlaySetup('lc');</xsl:text>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <xsl:if test="$keyboard.nav != 0">
            <xsl:attribute name="onkeypress">
              <xsl:text>navigate(event)</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <div class="{name(.)}">
            <xsl:apply-templates mode="titlepage.mode"/>
          </div>

          <xsl:choose>
            <xsl:when test="$multiframe=0">
              <div id="overlayDiv" class="navfoot">
                <xsl:choose>
                  <xsl:when test="$overlay != 0">
                    <xsl:attribute name="style">
                      <xsl:text>position:absolute;visibility:visible;</xsl:text>
                    </xsl:attribute>
                    <hr/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="style">
                      <xsl:text>padding-top: 2in;</xsl:text>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

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
                            <xsl:call-template name="right.image"/>
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

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,$thissection)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>

        <xsl:call-template name="section-links"/>

        <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                      or $dynamic.toc != 0 or $active.toc != 0">
          <script language="JavaScript1.2"/>
        </xsl:if>

        <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
          <xsl:call-template name="ua.js"/>
          <xsl:call-template name="xbDOM.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
          <xsl:call-template name="xbStyle.js"/>
          <xsl:call-template name="xbCollapsibleLists.js"/>
          <xsl:call-template name="slides.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="$overlay != '0'">
          <xsl:call-template name="overlay.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
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

  <frameset rows="{$multiframe.navigation.height},*,{$multiframe.navigation.height}"
            border="0" name="foil" framespacing="0">
    <frame src="top-{$thissection}" name="top" marginheight="0"
           scrolling="no" frameborder="0"/>
    <frame src="body-{$thissection}" name="body" marginheight="0" frameborder="0"/>
    <frame src="bot-{$thissection}" name="bottom" marginheight="0"
           scrolling="no" frameborder="0"/>
    <noframes>
      <body class="frameset">
        <xsl:call-template name="body.attributes"/>
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
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'top-',$section)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
        </head>
        <body class="topnavigation" bgcolor="{$multiframe.top.bgcolor}">
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

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'body-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Body</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
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

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'bot-',$thissection)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
        </head>
        <body class="botnavigation" bgcolor="{$multiframe.bottom.bgcolor}">
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

  <body class="section">
    <xsl:call-template name="body.attributes"/>
    <xsl:choose>
      <xsl:when test="$active.toc != 0">
        <xsl:attribute name="onload">
          <xsl:text>newPage('</xsl:text>
          <xsl:value-of select="$thissection"/>
          <xsl:text>',</xsl:text>
          <xsl:value-of select="$overlay"/>
          <xsl:text>);</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$overlay != 0">
        <xsl:attribute name="onload">
          <xsl:text>overlaySetup('lc');</xsl:text>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="$keyboard.nav != 0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate(event)</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <div class="{name(.)}" id="{$id}">
      <a name="{$id}"/>
      <xsl:if test="$multiframe=0">
        <xsl:call-template name="section-top-nav"/>
      </xsl:if>

      <div class="{name(.)}" id="{$id}">
        <a name="{$id}"/>
        <xsl:apply-templates select="title"/>
      </div>

      <xsl:if test="$multiframe=0">
        <div id="overlayDiv">
          <xsl:if test="$overlay != 0">
            <xsl:attribute name="style">
              <xsl:text>position:absolute;visibility:visible;</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="section-bottom-nav"/>
        </div>
      </xsl:if>
    </div>
  </body>
</xsl:template>

<xsl:template name="section-links">
  <xsl:variable name="prevfoil"
                select="(preceding::foil|/slides)[last()]"/>

  <xsl:variable name="nextfoil" select="foil[1]"/>

  <xsl:if test="$prevfoil">
    <link rel="previous">
      <xsl:attribute name="href">
        <xsl:apply-templates select="$prevfoil" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="$prevfoil/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>

  <xsl:if test="$nextfoil">
    <link rel="next">
      <xsl:attribute name="href">
        <xsl:apply-templates select="$nextfoil" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="$nextfoil/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="foil">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,$thisfoil)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>

        <xsl:call-template name="foil-links"/>

        <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                      or $dynamic.toc != 0 or $active.toc != 0">
          <script language="JavaScript1.2"/>
        </xsl:if>

        <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
          <xsl:call-template name="ua.js"/>
          <xsl:call-template name="xbDOM.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
          <xsl:call-template name="xbStyle.js"/>
          <xsl:call-template name="xbCollapsibleLists.js"/>
          <xsl:call-template name="slides.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="$overlay != '0'">
          <xsl:call-template name="overlay.js">
            <xsl:with-param name="language" select="'JavaScript'"/>
          </xsl:call-template>
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

  <frameset rows="{$multiframe.navigation.height},*,{$multiframe.navigation.height}" border="0" name="foil" framespacing="0">
    <xsl:attribute name="onkeypress">
      <xsl:text>navigate(event)</xsl:text>
    </xsl:attribute>
    <frame src="top-{$thisfoil}" name="top" marginheight="0" scrolling="no" frameborder="0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate(event)</xsl:text>
      </xsl:attribute>
    </frame>
    <frame src="body-{$thisfoil}" name="body" marginheight="0" frameborder="0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate(event)</xsl:text>
      </xsl:attribute>
    </frame>
    <frame src="bot-{$thisfoil}" name="bottom" marginheight="0" scrolling="no" frameborder="0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate(event)</xsl:text>
      </xsl:attribute>
    </frame>
    <noframes>
      <body class="frameset">
        <xsl:call-template name="body.attributes"/>
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
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'top-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
        </head>
        <body class="topnavigation" bgcolor="{$multiframe.top.bgcolor}">
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
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'body-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Body</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
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
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir,'bot-',$thisfoil)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title>Navigation</title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0
                        or $dynamic.toc != 0 or $active.toc != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0 or $dynamic.toc != 0 or $active.toc != 0">
            <xsl:call-template name="ua.js"/>
            <xsl:call-template name="xbDOM.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
            <xsl:call-template name="xbStyle.js"/>
            <xsl:call-template name="xbCollapsibleLists.js"/>
            <xsl:call-template name="slides.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:if test="$overlay != '0'">
            <xsl:call-template name="overlay.js">
              <xsl:with-param name="language" select="'JavaScript'"/>
            </xsl:call-template>
          </xsl:if>
        </head>
        <body class="botnavigation" bgcolor="{$multiframe.bottom.bgcolor}">
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

  <body class="foil">
    <xsl:call-template name="body.attributes"/>
    <xsl:choose>
      <xsl:when test="$active.toc != 0">
        <xsl:attribute name="onload">
          <xsl:text>newPage('</xsl:text>
          <xsl:value-of select="$thisfoil"/>
          <xsl:text>',</xsl:text>
          <xsl:value-of select="$overlay"/>
          <xsl:text>);</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$overlay != 0">
        <xsl:attribute name="onload">
          <xsl:text>overlaySetup('lc');</xsl:text>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="$keyboard.nav != 0">
      <xsl:attribute name="onkeypress">
        <xsl:text>navigate(event)</xsl:text>
      </xsl:attribute>
    </xsl:if>

    <div class="{name(.)}" id="{$id}">
      <a name="{$id}"/>
      <xsl:if test="$multiframe=0">
        <xsl:call-template name="foil-top-nav"/>
      </xsl:if>

      <xsl:apply-templates/>

      <xsl:if test="$multiframe=0">
        <div id="overlayDiv">
          <xsl:if test="$overlay != 0">
            <xsl:attribute name="style">
              <xsl:text>position:absolute;visibility:visible;</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="foil-bottom-nav"/>
        </div>
      </xsl:if>
    </div>
  </body>
</xsl:template>

<xsl:template name="foil-links">
  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1]
                                        |/slides)[last()]"/>


  <xsl:if test="$prevfoil">
    <link rel="previous">
      <xsl:attribute name="href">
        <xsl:apply-templates select="$prevfoil" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="$prevfoil/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>

  <xsl:if test="$nextfoil">
    <link rel="next">
      <xsl:attribute name="href">
        <xsl:apply-templates select="$nextfoil" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="$nextfoil/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo" mode="toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <DIV id="{$id}" class="toc-slidesinfo">
    <A href="{$titlefoil.html}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
    </A>
    <hr/>
  </DIV>
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

  <DIV class="toc-section" id="{$id}">
    <img alt="-">
      <xsl:attribute name="src">
        <xsl:call-template name="minus.image"/>
      </xsl:attribute>
    </img>
    <A href="{$thissection}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
    </A>
    <xsl:apply-templates select="foil" mode="toc"/>
  </DIV>
</xsl:template>

<xsl:template match="foil" mode="toc">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="foil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <DIV id="{$id}" class="toc-foil">
    <img alt="-">
      <xsl:attribute name="src">
        <xsl:call-template name="bullet.image"/>
      </xsl:attribute>
    </img>
    <A href="{$foil}" target="foil">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev" mode="toc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title" mode="toc"/>
        </xsl:otherwise>
      </xsl:choose>
    </A>
  </DIV>
</xsl:template>

</xsl:stylesheet>
