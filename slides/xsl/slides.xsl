<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>
<xsl:include href="param.xsl"/>
<xsl:include href="jscript.xsl"/>
<xsl:include href="graphics.xsl"/>

<xsl:output method="html"/>

<xsl:strip-space elements="slides foil section"/>

<!-- ============================================================ -->

<xsl:template name="overlayDiv.attributes">
  <xsl:choose>
    <xsl:when test="$overlay != 0">
      <xsl:attribute name="style">
        <xsl:text>position: absolute; visibility: visible;</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="style">padding-top: 2in;</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="css.stylesheet">
  <!-- danger will robinson: template shadows parameter -->
  <xsl:variable name="source.css.stylesheet">
    <xsl:call-template name="dbhtml-attribute">
      <xsl:with-param name="pis" select="/processing-instruction('dbhtml')"/>
      <xsl:with-param name="attribute" select="'css-stylesheet'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$source.css.stylesheet != ''">
      <xsl:value-of select="$source.css.stylesheet"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$css.stylesheet"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slides">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir, $toc.html)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="slidesinfo/title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <link rel="top">
            <xsl:attribute name="href">
              <xsl:apply-templates select="/slides" mode="filename"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="/slides/slidesinfo/title[1]"/>
            </xsl:attribute>
          </link>

          <xsl:for-each select="section">
            <link rel="section">
              <xsl:attribute name="href">
                <xsl:apply-templates select="." mode="filename"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="title[1]"/>
              </xsl:attribute>
            </link>
          </xsl:for-each>

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0">
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
        <body class="tocpage">
          <xsl:call-template name="body.attributes"/>
          <xsl:if test="$overlay != 0">
            <xsl:attribute name="onload">
              <xsl:text>overlaySetup('lc')</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$keyboard.nav != 0">
            <xsl:attribute name="onkeypress">
              <xsl:text>navigate(event)</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <h1 class="title">
            <a href="{$titlefoil.html}">
              <xsl:value-of select="/slides/slidesinfo/title"/>
            </a>
          </h1>

          <xsl:apply-templates select="." mode="toc"/>

          <div id="overlayDiv" class="navfoot">
            <xsl:call-template name="overlayDiv.attributes"/>
            <xsl:if test="$overlay != 0">
              <hr/>
            </xsl:if>

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
                  <a href="{$titlefoil.html}">
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
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename"
                    select="concat($base.dir, $titlefoil.html)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>

          <link rel="contents" href="{$toc.html}">
            <xsl:attribute name="title">
              <xsl:value-of select="(following::section|following::foil)[1]/title"/>
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

          <xsl:if test="$overlay != 0 or $keyboard.nav != 0">
            <script language="JavaScript1.2"/>
          </xsl:if>

          <xsl:if test="$keyboard.nav != 0">
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
          <xsl:if test="$overlay != 0">
            <xsl:attribute name="onload">
              <xsl:text>overlaySetup('lc')</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$keyboard.nav != 0">
            <xsl:attribute name="onkeypress">
              <xsl:text>navigate(event)</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <xsl:call-template name="slidesinfo-top-nav"/>

          <xsl:call-template name="slidesinfo-titlepage"/>

          <div id="overlayDiv" class="navfoot">
            <xsl:call-template name="overlayDiv.attributes"/>
            <xsl:if test="$overlay != 0">
              <hr/>
            </xsl:if>
            <xsl:call-template name="slidesinfo-bottom-nav"/>
          </div>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="slidesinfo-titlepage">
  <div class="{name(.)}">
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template name="slidesinfo-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <div class="navhead">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <td align="left" width="10%">
          <a href="{$toc.html}">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key">TableofContents</xsl:with-param>
            </xsl:call-template>
          </a>
        </td>
        <td align="center" width="80%">
          <xsl:text>&#160;</xsl:text>
        </td>
        <td align="right" width="10%">
          <xsl:text>&#160;</xsl:text>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template name="slidesinfo-bottom-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

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
        <a>
          <xsl:attribute name="href">
            <xsl:apply-templates select="(following::section|following::foil)[1]"
                                 mode="filename"/>
          </xsl:attribute>
          <img alt="Next" border="0">
            <xsl:attribute name="src">
              <xsl:call-template name="right.image"/>
            </xsl:attribute>
          </img>
        </a>
      </td>
    </tr>
  </table>
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
  <!-- nop -->
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

  <xsl:variable name="prevfoil"
                select="(preceding::foil|/slides)[last()]"/>

  <xsl:variable name="nextfoil" select="foil[1]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir, $thissection)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>

        <xsl:call-template name="section-links"/>

        <xsl:if test="$overlay != 0 or $keyboard.nav != 0">
          <script language="JavaScript1.2"/>
        </xsl:if>

        <xsl:if test="$keyboard.nav != 0">
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
      <body class="section">
        <xsl:call-template name="body.attributes"/>
        <xsl:if test="$overlay != 0">
          <xsl:attribute name="onload">
            <xsl:text>overlaySetup('lc')</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$keyboard.nav != 0">
          <xsl:attribute name="onkeypress">
            <xsl:text>navigate(event)</xsl:text>
          </xsl:attribute>
        </xsl:if>

        <div class="{name(.)}" id="{$id}">
          <a name="{$id}"/>
          <xsl:call-template name="section-top-nav"/>

          <xsl:apply-templates select="title"/>

          <div id="overlayDiv">
            <xsl:call-template name="overlayDiv.attributes"/>
            <xsl:call-template name="section-bottom-nav"/>
          </div>
        </div>
      </body>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates select="foil"/>
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

<xsl:template name="section-links">
  <xsl:variable name="prevfoil"
                select="(preceding::foil|/slides)[last()]"/>

  <xsl:variable name="nextfoil" select="foil[1]"/>

  <link rel="contents" href="{$toc.html}">
    <xsl:attribute name="title">
      <xsl:value-of select="(following::section|following::foil)[1]/title"/>
    </xsl:attribute>
  </link>

  <link rel="top">
    <xsl:attribute name="href">
      <xsl:apply-templates select="/slides" mode="filename"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="/slides/slidesinfo/title[1]"/>
    </xsl:attribute>
  </link>

  <xsl:if test="parent::section">
    <link rel="up">
      <xsl:attribute name="href">
        <xsl:apply-templates select="parent::section[1]" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="parent::section[1]/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>

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

  <xsl:for-each select="foil">
    <link rel="slides">
      <xsl:attribute name="href">
        <xsl:apply-templates select="." mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="title[1]"/>
      </xsl:attribute>
    </link>
  </xsl:for-each>

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
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="foil">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1]
                                        |/slides)[last()]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir, $thisfoil)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>

        <xsl:call-template name="foil-links"/>

        <xsl:if test="$overlay != 0 or $keyboard.nav != 0">
          <script language="JavaScript1.2"/>
        </xsl:if>

        <xsl:if test="$keyboard.nav != 0">
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
      <body class="foil">
        <xsl:call-template name="body.attributes"/>
        <xsl:if test="$overlay != 0">
          <xsl:attribute name="onload">
            <xsl:text>overlaySetup('lc')</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$keyboard.nav != 0">
          <xsl:attribute name="onkeypress">
            <xsl:text>navigate(event)</xsl:text>
          </xsl:attribute>
        </xsl:if>

        <div class="{name(.)}" id="{$id}">
          <a name="{$id}"/>
          <xsl:call-template name="foil-top-nav"/>

          <xsl:apply-templates/>

          <div id="overlayDiv">
            <xsl:call-template name="overlayDiv.attributes"/>
            <xsl:call-template name="foil-bottom-nav"/>
          </div>
        </div>
      </body>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="foil" mode="foilnumber">
  <xsl:number count="foil" level="any"/>
</xsl:template>

<xsl:template match="slides" mode="filename">
  <xsl:value-of select="$titlefoil.html"/>
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
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template name="foil-links">
  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1]
                                        |/slides)[last()]"/>


  <link rel="contents" href="{$toc.html}">
    <xsl:attribute name="title">
      <xsl:value-of select="(following::section|following::foil)[1]/title"/>
    </xsl:attribute>
  </link>

  <link rel="top">
    <xsl:attribute name="href">
      <xsl:apply-templates select="/slides" mode="filename"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="/slides/slidesinfo/title[1]"/>
    </xsl:attribute>
  </link>

  <xsl:if test="parent::section">
    <link rel="up">
      <xsl:attribute name="href">
        <xsl:apply-templates select="parent::section[1]" mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="parent::section[1]/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>

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

  <xsl:if test="preceding-sibling::foil">
    <link rel="first">
      <xsl:attribute name="href">
        <xsl:apply-templates select="preceding-sibling::foil[last()]"
                             mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="preceding-sibling::foil[last()]/title"/>
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

  <xsl:if test="following-sibling::foil">
    <link rel="last">
      <xsl:attribute name="href">
        <xsl:apply-templates select="following-sibling::foil[last()]"
                             mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="following-sibling::foil[last()]/title"/>
      </xsl:attribute>
    </link>
  </xsl:if>

  <xsl:for-each select="../../section">
    <link rel="section">
      <xsl:attribute name="href">
        <xsl:apply-templates select="." mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="title[1]"/>
      </xsl:attribute>
    </link>
  </xsl:for-each>

  <xsl:for-each select="../foil">
    <link rel="slides">
      <xsl:attribute name="href">
        <xsl:apply-templates select="." mode="filename"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="title[1]"/>
      </xsl:attribute>
    </link>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

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
        <xsl:when test="contains($pidata,'blue')">class="blue"</xsl:when>
        <xsl:when test="contains($pidata,'orange')">class="orange"</xsl:when>
        <xsl:when test="contains($pidata,'red')">class="red"</xsl:when>
        <xsl:when test="contains($pidata,'brown')">class="brown"</xsl:when>
        <xsl:when test="contains($pidata,'violet')">class="violet"</xsl:when>
        <xsl:when test="contains($pidata,'black')">class="black"</xsl:when>
        <xsl:otherwise>class="bold"</xsl:otherwise>
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

<xsl:template match="link">
  <xsl:call-template name="link">
    <xsl:with-param name="a.target" select="'foil'"/>
  </xsl:call-template>
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

<xsl:template match="slides" mode="toc">
  <p class="toctitle">
    <b>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">TableofContents</xsl:with-param>
      </xsl:call-template>
    </b>
  </p>
  <dl>
    <xsl:apply-templates select="section|foil" mode="toc"/>
  </dl>
</xsl:template>

<xsl:template match="section" mode="toc">
  <xsl:variable name="snumber">
    <xsl:number count="section" level="any"/>
  </xsl:variable>

  <xsl:variable name="thissection">
    <xsl:text>section</xsl:text>
    <xsl:number value="$snumber" format="01"/>
    <xsl:text>.html</xsl:text>
  </xsl:variable>

  <dt>
    <a href="{$thissection}">
      <xsl:value-of select="title"/>
    </a>
  </dt>
  <dd>
    <dl>
      <xsl:apply-templates select="foil" mode="toc"/>
    </dl>
  </dd>
</xsl:template>

<xsl:template match="foil" mode="toc">
  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <dt>
    <xsl:apply-templates select="." mode="foilnumber"/>
    <xsl:text>. </xsl:text>
    <a href="{$thisfoil}">
      <xsl:value-of select="title"/>
    </a>
  </dt>
</xsl:template>

<xsl:template match="title|titleabbrev" mode="toc">
  <xsl:apply-templates mode="toc"/>
</xsl:template>

<xsl:template match="speakernotes" mode="toc">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slidesinfo" mode="ns-toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:text>myList.addItem('</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;DIV id="</xsl:text>
  <xsl:value-of select="$id"/>
  <xsl:text disable-output-escaping="yes">" class="toc-slidesinfo"&gt;</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;A href="</xsl:text>
  <xsl:value-of select="$titlefoil.html"/>
  <xsl:text disable-output-escaping="yes">" target="foil"&gt;</xsl:text>

  <xsl:choose>
    <xsl:when test="titleabbrev">
      <xsl:value-of select="titleabbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="title"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text disable-output-escaping="yes">&lt;/A&gt;&lt;/DIV&gt;</xsl:text>
  <xsl:text>');&#10;</xsl:text>
</xsl:template>

<xsl:template match="section" mode="ns-toc">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:text>subList = new List(false, width, height, "</xsl:text>
<xsl:value-of select="$toc.bg.color"/>
<xsl:text>");&#10;</xsl:text>
  <xsl:text>subList.setIndent(12);&#10;</xsl:text>
  <xsl:apply-templates select="foil" mode="ns-toc"/>

  <xsl:text>myList.addList(subList, '</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;DIV id="</xsl:text>
  <xsl:value-of select="$id"/>
  <xsl:text disable-output-escaping="yes">" class="toc-section"&gt;</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;A href="</xsl:text>
  <xsl:apply-templates select="." mode="filename"/>
  <xsl:text disable-output-escaping="yes">" target="foil"&gt;</xsl:text>

  <xsl:choose>
    <xsl:when test="titleabbrev">
      <xsl:value-of select="titleabbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="title"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text disable-output-escaping="yes">&lt;/A&gt;&lt;/DIV&gt;</xsl:text>
  <xsl:text>');&#10;</xsl:text>
</xsl:template>

<xsl:template match="foil" mode="ns-toc">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:choose>
    <xsl:when test="ancestor::section">
      <xsl:text>subList.addItem('</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>myList.addItem('</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text disable-output-escaping="yes">&lt;DIV id="</xsl:text>
  <xsl:value-of select="$id"/>
  <xsl:text disable-output-escaping="yes">" class="toc-foil"&gt;</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;img alt="-" src="</xsl:text>
  <xsl:call-template name="bullet.image"/>
  <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>

  <xsl:text disable-output-escaping="yes">&lt;A href="</xsl:text>
  <xsl:apply-templates select="." mode="filename"/>
  <xsl:text disable-output-escaping="yes">" target="foil"&gt;</xsl:text>

  <xsl:choose>
    <xsl:when test="titleabbrev">
      <xsl:value-of select="titleabbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="title"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text disable-output-escaping="yes">&lt;/A&gt;&lt;/DIV&gt;</xsl:text>
  <xsl:text>');&#10;</xsl:text>
</xsl:template>

<xsl:template match="speakernotes" mode="ns-toc">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="section-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

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

  <div class="navhead">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <xsl:call-template name="generate.toc.hide.show"/>
        <td align="left" width="10%">
          <xsl:choose>
            <xsl:when test="$prevfoil != ''">
              <a href="{$prevfoil}">
                <xsl:if test="$prev-target != ''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$prev-target"/>
                  </xsl:attribute>
                </xsl:if>
                <img alt="Prev" border="0">
                  <xsl:attribute name="src">
                    <xsl:call-template name="left.image"/>
                  </xsl:attribute>
                </img>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="center" width="80%">
          <xsl:variable name="prestitle">
            <xsl:value-of select="(/slides/slidesinfo/title
                                  |/slides/title)[1]"/>
          </xsl:variable>

          <span class="navheader">
            <xsl:value-of select="$prestitle"/>
          </span>
        </td>
        <td align="right" width="10%">
          <xsl:choose>
            <xsl:when test="$nextfoil != ''">
              <a href="{$nextfoil}">
                <xsl:if test="$next-target != ''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$next-target"/>
                  </xsl:attribute>
                </xsl:if>
                <img alt="Next" border="0">
                  <xsl:attribute name="src">
                    <xsl:call-template name="right.image"/>
                  </xsl:attribute>
                </img>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
    <hr class="head"/>
  </div>
</xsl:template>

<xsl:template name="section-bottom-nav">
  <div class="navfoot">
    <hr class="foot"/>
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <td align="left" width="80%" valign="top">
          <span class="navfooter">
            <xsl:apply-templates select="/slides/slidesinfo/copyright"
                                 mode="slide.navigation.mode"/>
          </span>
        </td>
        <td align="right" width="20%" valign="top">
          <xsl:text>&#160;</xsl:text>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template name="foil-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="section" select="ancestor::section"/>

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

  <div class="navhead">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <xsl:call-template name="generate.toc.hide.show"/>
        <td align="left" width="10%">
          <xsl:choose>
            <xsl:when test="$prevfoil != ''">
              <a href="{$prevfoil}">
                <xsl:if test="$prev-target != ''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$prev-target"/>
                  </xsl:attribute>
                </xsl:if>
                <img alt="Prev" border="0">
                  <xsl:attribute name="src">
                    <xsl:call-template name="left.image"/>
                  </xsl:attribute>
                </img>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="center" width="80%">
          <xsl:variable name="prestitle">
            <xsl:value-of select="(/slides/slidesinfo/title
                                  |/slides/title)[1]"/>
          </xsl:variable>
          <xsl:variable name="secttitle">
            <xsl:if test="$section">
              <xsl:value-of select="$section/title"/>
            </xsl:if>
          </xsl:variable>

          <span class="navheader">
            <xsl:value-of select="$prestitle"/>
            <xsl:if test="$secttitle != ''">
              <xsl:text>: </xsl:text>
              <xsl:value-of select="$secttitle"/>
            </xsl:if>
          </span>
        </td>
        <td align="right" width="10%">
          <xsl:choose>
            <xsl:when test="$nextfoil != ''">
              <a href="{$nextfoil}">
                <xsl:if test="$next-target != ''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$next-target"/>
                  </xsl:attribute>
                </xsl:if>
                <img alt="Next" border="0">
                  <xsl:attribute name="src">
                    <xsl:call-template name="right.image"/>
                  </xsl:attribute>
                </img>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
    <hr/>
  </div>
</xsl:template>

<xsl:template name="foil-bottom-nav">
  <div class="navfoot">
    <hr/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0"
           summary="Navigation">
      <tr>
        <td align="left" width="80%" valign="top">
          <span class="navfooter">
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates select="/slides/slidesinfo/copyright"
                                 mode="slide.navigation.mode"/>
          </span>
        </td>
        <td align="right" width="20%" valign="top">
          <span class="navfooter">
            <xsl:number count="foil" level="any"/>
            <xsl:text>&#160;</xsl:text>
          </span>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template name="generate.toc.hide.show">
  <xsl:if test="$toc.hide.show != 0">
    <td>
      <img hspace="4">
        <xsl:attribute name="src">
          <xsl:call-template name="hidetoc.image"/>
	</xsl:attribute>
	<xsl:attribute name="onClick">
          <xsl:text>toggletoc(this,</xsl:text>
          <xsl:value-of select="$toc.width"/>
          <xsl:text>,'</xsl:text>
          <xsl:call-template name="hidetoc.image"/>
          <xsl:text>','</xsl:text>
          <xsl:call-template name="showtoc.image"/>
          <xsl:text>');</xsl:text>
        </xsl:attribute>
      </img>
    </td>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="name($node)='slides'">1</xsl:when>
    <xsl:when test="name($node)='foil'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="chunk-filename">
  <xsl:param name="recursive">0</xsl:param>
  <!-- returns the filename of a chunk -->
  <xsl:variable name="ischunk"><xsl:call-template name="chunk"/></xsl:variable>
  <xsl:variable name="filename">
    <xsl:call-template name="dbhtml-filename"/>
  </xsl:variable>
  <xsl:variable name="dir">
    <xsl:call-template name="dbhtml-dir"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk='0'">
      <!-- if called on something that isn't a chunk, walk up... -->
      <xsl:choose>
        <xsl:when test="count(./parent::*)>0">
          <xsl:apply-templates mode="chunk-filename" select="./parent::*">
            <xsl:with-param name="recursive" select="$recursive"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- unless there is no up, in which case return "" -->
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not($recursive) and $filename != ''">
      <!-- if this chunk has an explicit name, use it -->
      <xsl:if test="$dir != ''">
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <xsl:when test="name(.)='foil'">
      <xsl:variable name="foilnumber">
	<xsl:number count="foil" level="any"/>
      </xsl:variable>

      <xsl:text>foil</xsl:text>
      <xsl:number value="$foilnumber" format="01"/>
      <xsl:text>.html</xsl:text>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text>chunk-filename-error-</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:number level="any" format="01" from="set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="@*" mode="copy">
  <xsl:attribute name="{local-name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="html:*" xmlns:html='http://www.w3.org/1999/xhtml'>
  <xsl:element name="{local-name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
