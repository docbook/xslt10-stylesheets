<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="slides.xsl"/>

<xsl:param name="toc.width" select="100"/>

<xsl:param name="but-fforward.png" select="'but-fforward.png'"/>
<xsl:param name="but-info.png" select="'but-info.png'"/>
<xsl:param name="but-next.png" select="'but-next.png'"/>
<xsl:param name="but-prev.png" select="'but-prev.png'"/>
<xsl:param name="but-rewind.png" select="'but-rewind.png'"/>
<xsl:param name="but-xfforward.png" select="'but-xfforward.png'"/>
<xsl:param name="but-xnext.png" select="'but-xnext.png'"/>
<xsl:param name="but-xprev.png" select="'but-xprev.png'"/>
<xsl:param name="but-xrewind.png" select="'but-xrewind.png'"/>

<!-- ============================================================ -->

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

          <xsl:if test="$keyboard.nav != 0">
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
        </head>
        <body class="tocpage">
          <xsl:call-template name="body.attributes"/>
          <xsl:if test="$keyboard.nav != 0">
            <xsl:attribute name="onkeypress">
              <xsl:text>navigate(event)</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <table border="0" width="100%" summary="Navigation and body table"
                 cellpadding="0" cellspacing="0">
            <tr>
              <td>&#160;</td>
              <td><xsl:apply-templates select="." mode="header"/></td>
            </tr>

            <tr>
              <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                  valign="top" align="left">

                <xsl:variable name="first" select="(/slides/section|/slides/foil)[1]"/>

                <xsl:call-template name="vertical-navigation">
                  <xsl:with-param name="first"/>
                  <xsl:with-param name="prev"/>
                  <xsl:with-param name="next" select="/slides"/>
                  <xsl:with-param name="last" select="(//foil)[last()]"/>
                </xsl:call-template>

              </td>
              <td bgcolor="{$body.bg.color}" valign="top" align="left">
                <div class="{name(.)}">
                  <h1 class="title">
                    <a href="{$titlefoil.html}">
                      <xsl:value-of select="/slides/slidesinfo/title"/>
                    </a>
                  </h1>

                  <xsl:apply-templates select="." mode="toc"/>
                </div>
              </td>
            </tr>

            <tr>
              <td>&#160;</td>
              <td><xsl:apply-templates select="." mode="footer"/></td>
            </tr>
          </table>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="slidesinfo">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat($base.dir, $titlefoil.html)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="title"/></title>
          <link type="text/css" rel="stylesheet">
            <xsl:attribute name="href">
              <xsl:call-template name="css.stylesheet"/>
            </xsl:attribute>
          </link>
        </head>
        <body class="titlepage">
          <xsl:call-template name="body.attributes"/>

          <table border="0" width="100%" summary="Navigation and body table"
                 cellpadding="0" cellspacing="0">
            <tr>
              <td>&#160;</td>
              <td><xsl:apply-templates select="." mode="header"/></td>
            </tr>

            <tr>
              <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                  valign="top" align="left">

                <xsl:call-template name="vertical-navigation">
                  <xsl:with-param name="first"/>
                  <xsl:with-param name="last" select="(following::section|following::foil)[last()]"/>
                  <xsl:with-param name="next" select="(following::section|following::foil)[1]"/>
                </xsl:call-template>

              </td>
              <td bgcolor="{$body.bg.color}" valign="top" align="left">
                <div class="{name(.)}">
                  <xsl:apply-templates mode="titlepage.mode"/>
                </div>
              </td>
            </tr>

            <tr>
              <td>&#160;</td>
              <td><xsl:apply-templates select="." mode="footer"/></td>
            </tr>
          </table>
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

  <xsl:variable name="nextfoil" select="foil[1]"/>
  <xsl:variable name="lastfoil" select="(descendant::foil|following::foil)[last()]"/>
  <xsl:variable name="prevfoil" select="(preceding::foil|/slides)[last()]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat($base.dir, $thissection)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>
      </head>
      <body class="section">
        <xsl:call-template name="body.attributes"/>

        <table border="0" width="100%" summary="Navigation and body table"
               cellpadding="0" cellspacing="0">
          <tr>
            <td>&#160;</td>
            <td><xsl:apply-templates select="." mode="header"/></td>
          </tr>

          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="left">

              <xsl:call-template name="vertical-navigation">
                <xsl:with-param name="last" select="$lastfoil"/>
                <xsl:with-param name="prev" select="$prevfoil"/>
                <xsl:with-param name="next" select="$nextfoil"/>
              </xsl:call-template>

            </td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <div class="{name(.)}">
                <xsl:apply-templates/>
              </div>
            </td>
          </tr>

          <tr>
            <td>&#160;</td>
            <td><xsl:apply-templates select="." mode="footer"/></td>
          </tr>
        </table>
      </body>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates select="foil"/>
</xsl:template>

<xsl:template match="foil">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="section" select="ancestor::section"/>

  <xsl:variable name="thisfoil">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="lastfoil" select="following::foil[last()]"/>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1]
                                        |/slides)[last()]"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat($base.dir, $thisfoil)"/>
    <xsl:with-param name="content">
      <head>
        <title><xsl:value-of select="title"/></title>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="css.stylesheet"/>
          </xsl:attribute>
        </link>
      </head>
      <body class="foil">
        <xsl:call-template name="body.attributes"/>

        <table border="0" width="100%" summary="Navigation and body table"
               cellpadding="0" cellspacing="0">
          <tr>
            <td>&#160;</td>
            <td><xsl:apply-templates select="." mode="header"/></td>
          </tr>

          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="left">

              <xsl:call-template name="vertical-navigation">
                <xsl:with-param name="last" select="$lastfoil"/>
                <xsl:with-param name="prev" select="$prevfoil"/>
                <xsl:with-param name="next" select="$nextfoil"/>
              </xsl:call-template>

            </td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <div class="{name(.)}">
                <xsl:apply-templates/>
              </div>
            </td>
          </tr>

          <tr>
            <td>&#160;</td>
            <td><xsl:apply-templates select="." mode="footer"/></td>
          </tr>
        </table>
      </body>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="header">
  <div class="navhead">
    <table border="0" width="100%" summary="Header table"
           cellpadding="0" cellspacing="0">
      <tr>
        <td align="left">
          <xsl:apply-templates select="/slides/slidesinfo/copyright"
                               mode="slide.navigation.mode"/>
        </td>
        <td align="right">
          <xsl:value-of select="count(preceding::foil)
                                + count(preceding::section)
                                + count(ancestor::section)
                                + 1"/>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="*" mode="footer">
  <div class="navfoot">
    <table border="0" width="100%" summary="Header table"
           cellpadding="0" cellspacing="0">
      <tr>
        <td align="center">
          <xsl:text>Slide </xsl:text>
          <xsl:value-of select="count(preceding::foil)
                                + count(preceding::section)
                                + count(ancestor::section)
                                + 1"/>
          <xsl:text> of </xsl:text>
          <xsl:value-of select="count(//foil) + count(//section)"/>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="slides" mode="footer"/>

<!-- ============================================================ -->

<xsl:template name="vertical-navigation">
  <xsl:param name="first" select="/slides"/>
  <xsl:param name="prev"/>
  <xsl:param name="last"/>
  <xsl:param name="next"/>

  <div class="vnav">
    <xsl:choose>
      <xsl:when test="$first">
        <a>
          <xsl:attribute name="href">
            <xsl:apply-templates select="$first" mode="filename"/>
          </xsl:attribute>
          <img border="0" alt="First">
            <xsl:attribute name="src">
              <xsl:call-template name="graphics-file">
                <xsl:with-param name="image" select="$but-rewind.png"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$but-xrewind.png"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <xsl:choose>
      <xsl:when test="$prev">
        <a>
          <xsl:attribute name="href">
            <xsl:apply-templates select="$prev" mode="filename"/>
          </xsl:attribute>
          <img border="0" alt="Previous">
            <xsl:attribute name="src">
              <xsl:call-template name="graphics-file">
                <xsl:with-param name="image" select="$but-prev.png"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$but-xprev.png"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <xsl:choose>
      <xsl:when test="$next">
        <a>
          <xsl:attribute name="href">
            <xsl:apply-templates select="$next" mode="filename"/>
          </xsl:attribute>
          <img border="0" alt="Last">
            <xsl:attribute name="src">
              <xsl:call-template name="graphics-file">
                <xsl:with-param name="image" select="$but-next.png"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$but-xnext.png"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <xsl:choose>
      <xsl:when test="$last">
        <a>
          <xsl:attribute name="href">
            <xsl:apply-templates select="$last" mode="filename"/>
          </xsl:attribute>
          <img border="0" alt="Next">
            <xsl:attribute name="src">
              <xsl:call-template name="graphics-file">
                <xsl:with-param name="image" select="$but-fforward.png"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$but-xfforward.png"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>

    <br/>
    <br/>

    <a href="{$toc.html}">
      <img border="0" alt="ToC">
        <xsl:attribute name="src">
          <xsl:call-template name="graphics-file">
            <xsl:with-param name="image" select="$but-info.png"/>
          </xsl:call-template>
        </xsl:attribute>
      </img>
    </a>
  </div>
</xsl:template>

</xsl:stylesheet>
