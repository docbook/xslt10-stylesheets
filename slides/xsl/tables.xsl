<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="slides.xsl"/>

<xsl:param name="blank.image" select="'blank.gif'"/>
<xsl:param name="arrow.image" select="'arrow.gif'"/>

<xsl:param name="toc.bg.color">#6A719C</xsl:param>
<xsl:param name="toc.width">220</xsl:param>

<!-- ============================================================ -->

<xsl:template match="slides">
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
          <div class="{name(.)}">
            <xsl:apply-templates mode="titlepage.mode"/>
          </div>

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
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="center">
              <div class="ttoc">
                <span class="ttoc-title">
                  <a href="{$titlefoil.html}">
                    <xsl:apply-templates select="/slides" mode="toc-title"/>
                  </a>
                </span>
              </div>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <a name="{$id}"/>
              <xsl:call-template name="section-top-nav"/>
            </td>
          </tr>
          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="left">
              <div class="ttoc">
                <xsl:apply-templates select="." mode="toc"/>
              </div>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <div class="{name(.)}">

                <xsl:apply-templates/>
              </div>
            </td>
          </tr>
          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <xsl:call-template name="section-bottom-nav"/>
            </td>
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
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="center">
              <div class="ttoc">
                <span class="ttoc-title">
                  <a href="{$titlefoil.html}">
                    <xsl:apply-templates select="/slides" mode="toc-title"/>
                  </a>
                </span>
              </div>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <a name="{$id}"/>
              <xsl:call-template name="foil-top-nav"/>
            </td>
          </tr>
          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}"
                valign="top" align="left">
              <div class="ttoc">
                <xsl:apply-templates select="." mode="toc"/>
              </div>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <div class="{name(.)}" id="{$id}">
                <a name="{$id}"/>

                <xsl:apply-templates/>
              </div>
            </td>
          </tr>
          <tr>
            <td bgcolor="{$toc.bg.color}" width="{$toc.width}">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td>&#160;</td>
            <td bgcolor="{$body.bg.color}" valign="top" align="left">
              <xsl:call-template name="foil-bottom-nav"/>
            </td>
          </tr>
        </table>
      </body>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slides" mode="toc">
  <xsl:apply-templates select="section|foil" mode="toc"/>
</xsl:template>

<xsl:template match="section" mode="toc">
  <xsl:variable name="thissection" select="."/>

  <xsl:for-each select="/slides/section">
    <xsl:choose>
      <xsl:when test="$thissection = .">
        <img alt="+">
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$arrow.image"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <img alt=" ">
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$blank.image"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>

    <span class="ttoc-section">
      <a>
        <xsl:attribute name="href">
          <xsl:apply-templates select="./foil[1]" mode="filename"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="toc-title"/>
      </a>
    </span>
    <br/>

    <xsl:if test="$thissection = .">
      <xsl:for-each select="foil">
        <img alt=" ">
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$blank.image"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
        <img alt=" ">
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$blank.image"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>

        <span class="ttoc-foil">
          <a>
            <xsl:attribute name="href">
              <xsl:apply-templates select="." mode="filename"/>
            </xsl:attribute>
            <xsl:apply-templates select="." mode="toc-title"/>
          </a>
        </span>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="foil" mode="toc">
  <xsl:variable name="thisfoil" select="."/>

  <xsl:choose>
    <xsl:when test="/slides/section">
      <xsl:for-each select="/slides/section">
        <img alt=" ">
          <xsl:attribute name="src">
            <xsl:call-template name="graphics-file">
              <xsl:with-param name="image" select="$blank.image"/>
            </xsl:call-template>
          </xsl:attribute>
        </img>
        <span class="ttoc-section">
          <a>
            <xsl:attribute name="href">
              <xsl:apply-templates select="./foil[1]" mode="filename"/>
            </xsl:attribute>
            <xsl:apply-templates select="." mode="toc-title"/>
          </a>
        </span>
        <br/>

        <xsl:if test="$thisfoil/ancestor::section = .">
          <xsl:for-each select="foil">
            <img alt=" ">
              <xsl:attribute name="src">
                <xsl:call-template name="graphics-file">
                  <xsl:with-param name="image" select="$blank.image"/>
                </xsl:call-template>
              </xsl:attribute>
            </img>

            <xsl:choose>
              <xsl:when test="$thisfoil = .">
                <img alt="+">
                  <xsl:attribute name="src">
                    <xsl:call-template name="graphics-file">
                      <xsl:with-param name="image" select="$arrow.image"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </img>
              </xsl:when>
              <xsl:otherwise>
                <img alt=" ">
                  <xsl:attribute name="src">
                    <xsl:call-template name="graphics-file">
                      <xsl:with-param name="image" select="$blank.image"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </img>
              </xsl:otherwise>
            </xsl:choose>

            <span class="ttoc-foil">
              <a>
                <xsl:attribute name="href">
                  <xsl:apply-templates select="." mode="filename"/>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="toc-title"/>
              </a>
            </span>
            <br/>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <!-- foils only -->
      <xsl:for-each select="/slides/foil">
        <span class="ttoc-foil">
          <xsl:apply-templates select="." mode="toc-title"/>
        </span>
        <br/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slides" mode="toc-title">
  <xsl:call-template name="nobreak">
    <xsl:with-param name="string">
      <xsl:choose>
        <xsl:when test="slidesinfo/titleabbrev">
          <xsl:value-of select="slidesinfo/titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="slidesinfo/title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="toc-title">
  <xsl:call-template name="nobreak">
    <xsl:with-param name="string">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:value-of select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="foil" mode="toc-title">
  <xsl:call-template name="nobreak">
    <xsl:with-param name="string">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:value-of select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="nobreak">
  <xsl:param name="string" select="''"/>
  <xsl:choose>
    <xsl:when test="contains($string, ' ')">
      <xsl:value-of select="substring-before($string, ' ')"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:call-template name="nobreak">
        <xsl:with-param name="string" select="substring-after($string, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
