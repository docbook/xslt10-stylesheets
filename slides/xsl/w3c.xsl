<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<xsl:import href="slides.xsl"/>

<xsl:template name="overlayDiv.attributes"/>

<xsl:template name="logo">
  <xsl:text>LOGO</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="slides">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="indent" select="$output.indent"/>
    <xsl:with-param name="filename" select="concat($base.dir, $toc.html)"/>
    <xsl:with-param name="content">
      <html>
        <head>
          <title><xsl:value-of select="title"/></title>
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
        </head>
        <body class="tocpage">
          <xsl:call-template name="body.attributes"/>

          <div class="navhead">
            <table class="navbar" cellspacing="0" cellpadding="0" border="0"
                   width="97%" summary="Navigation buttons">
              <tr valign="top">
                <td align="left">
                  <xsl:call-template name="logo"/>
                </td>
                <td valign="top" nowrap="nowrap">&#160;</td>
              </tr>
            </table>
          </div>

          <h1 class="title">
            <a href="{$titlefoil.html}">
              <xsl:value-of select="/slides/slidesinfo/title"/>
            </a>
          </h1>

          <h3 class="author">
            <xsl:text>by </xsl:text>
            <xsl:variable name="author" select="(/slides/slidesinfo//author
                                                |/slides/slidesinfo//editor)"/>
            <xsl:for-each select="$author">
              <xsl:choose>
                <xsl:when test=".//email">
                  <a href="mailto:{.//email[1]}">
                    <xsl:call-template name="person.name"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="person.name"/>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:if test="position() &lt; last()">, </xsl:if>
            </xsl:for-each>
          </h3>

          <xsl:apply-templates select="." mode="toc"/>
        </body>
      </html>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="slidesinfo-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <div class="navhead">
    <table class="navbar" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="Navigation buttons">
      <tr valign="top">
        <td align="left">
          <xsl:call-template name="logo"/>
        </td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <img border="0" width="32" height="32" alt=" ">
              <xsl:attribute name="src">
                <xsl:call-template name="w3c.bleft.image"/>
              </xsl:attribute>
            </img>
            <a rel="contents" href="toc.html" accesskey="C">
              <img border="0" width="32" height="32"
                   alt=" Contents" title="Table of Contents">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.toc.image"/>
                </xsl:attribute>
              </img>
            </a>
            <a rel="next" href="{$nextfile}" accesskey="N">
              <img border="0" width="32" height="32"
                   alt=" Next" title="{$nextfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.right.image"/>
                </xsl:attribute>
              </img>
            </a>
          </div>
        </td>
      </tr>
    </table>

    <xsl:apply-templates select="title" mode="head.title"/>
    <hr class="head"/>
  </div>
</xsl:template>

<xsl:template name="slidesinfo-bottom-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <div class="navfoot">
    <hr class="foot"/>
    <table class="footer" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="footer">
      <tr valign="bottom">
        <td>&#160;</td>
        <td>&#160;</td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <img border="0" width="32" height="32" alt=" ">
              <xsl:attribute name="src">
                <xsl:call-template name="w3c.bleft.image"/>
              </xsl:attribute>
            </img>
            <a rel="next" href="{$nextfile}" accesskey="N">
              <img border="0" width="32" height="32"
                   alt=" Next" title="{$nextfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.right.image"/>
                </xsl:attribute>
              </img>
            </a>
          </div>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="slidesinfo/title" mode="titlepage.mode"/>

<!-- ============================================================ -->

<xsl:template name="section-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="nextfoil" select="foil[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil" select="preceding::foil"/>

  <xsl:variable name="prevfile">
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
    <table class="navbar" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="Navigation buttons">
      <tr valign="top">
        <td align="left">
          <xsl:call-template name="logo"/>
        </td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <a rel="previous" href="{$prevfile}" accesskey="P">
              <img border="0" width="32" height="32"
                   alt=" Previous" title="{$prevfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.left.image"/>
                </xsl:attribute>
              </img>
            </a>
            <a rel="contents" href="toc.html" accesskey="C">
              <img border="0" width="32" height="32"
                   alt=" Contents" title="Table of Contents">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.toc.image"/>
                </xsl:attribute>
              </img>
            </a>
            <a rel="next" href="{$nextfile}" accesskey="N">
              <img border="0" width="32" height="32"
                   alt=" Next" title="{$nextfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.right.image"/>
                </xsl:attribute>
              </img>
            </a>
          </div>
        </td>
      </tr>
    </table>

    <xsl:apply-templates select="title" mode="head.title"/>
    <hr class="foot"/>
  </div>
</xsl:template>

<xsl:template match="section/title" mode="head.title">
  <h1 class="{name(.)}"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="section/title"/>

<xsl:template name="section-bottom-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="nextfoil" select="foil[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil" select="preceding::foil[1]"/>

  <xsl:variable name="prevfile">
    <xsl:choose>
      <xsl:when test="$prevfoil">
        <xsl:apply-templates select="$prevfoil" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="navfoot">
    <hr class="foot"/>
    <table class="footer" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="footer">
      <tr valign="bottom">
        <td>
          <xsl:variable name="author" select="(/slides/slidesinfo//author
                                              |/slides/slidesinfo//editor)"/>
          <xsl:for-each select="$author">
            <xsl:choose>
              <xsl:when test=".//email">
                <a href="mailto:{.//email[1]}">
                  <xsl:call-template name="person.name"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="person.name"/>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="position() &lt; last()">, </xsl:if>
          </xsl:for-each>
        </td>
        <td align="right">
          <p class="index">
            <xsl:value-of select="count(preceding::foil)
                                  + count(preceding::section)
                                  + count(ancestor::section)
                                  + 1"/>
            <xsl:text> of </xsl:text>
            <xsl:value-of select="count(//foil|//section)"/>
          </p>
        </td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <a rel="previous" href="{$prevfile}" accesskey="P">
              <img border="0" width="32" height="32"
                   alt=" Previous" title="{$prevfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.left.image"/>
                </xsl:attribute>
              </img>
            </a>
            <a rel="next" href="{$nextfile}" accesskey="N">
              <img border="0" width="32" height="32"
                   alt=" Next" title="{$nextfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.right.image"/>
                </xsl:attribute>
              </img>
            </a>
          </div>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="foil-top-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="section" select="ancestor::section"/>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1])[last()]"/>

  <xsl:variable name="prevfile">
    <xsl:choose>
      <xsl:when test="$prevfoil">
        <xsl:apply-templates select="$prevfoil" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="navhead">
    <table class="navbar" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="Navigation buttons">
      <tr valign="top">
        <td align="left">
          <xsl:call-template name="logo"/>
        </td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <a rel="previous" href="{$prevfile}" accesskey="P">
              <img border="0" width="32" height="32"
                   alt=" Previous" title="{$prevfoil/title}">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.left.image"/>
                </xsl:attribute>
              </img>
            </a>
            <a rel="contents" href="toc.html" accesskey="C">
              <img border="0" width="32" height="32"
                   alt=" Contents" title="Table of Contents">
                <xsl:attribute name="src">
                  <xsl:call-template name="w3c.toc.image"/>
                </xsl:attribute>
              </img>
            </a>
            <xsl:choose>
              <xsl:when test="$nextfoil != ''">
                <a rel="next" href="{$nextfile}" accesskey="N">
                  <img border="0" width="32" height="32"
                       alt=" Next" title="{$nextfoil/title}">
                    <xsl:attribute name="src">
                      <xsl:call-template name="w3c.right.image"/>
                    </xsl:attribute>
                  </img>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <img border="0" width="32" height="32" alt=" The End.">
                  <xsl:attribute name="src">
                    <xsl:call-template name="w3c.bright.image"/>
                  </xsl:attribute>
                </img>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>
    </table>

    <xsl:apply-templates select="title" mode="head.title"/>
    <hr class="head"/>
  </div>
</xsl:template>

<xsl:template name="foil-bottom-nav">
  <xsl:param name="prev-target" select="''"/>
  <xsl:param name="next-target" select="''"/>

  <xsl:variable name="nextfoil" select="(following::foil
                                        |following::section)[1]"/>

  <xsl:variable name="nextfile">
    <xsl:apply-templates select="$nextfoil" mode="filename"/>
  </xsl:variable>

  <xsl:variable name="prevfoil" select="(preceding-sibling::foil[1]
                                        |parent::section[1])[last()]"/>

  <xsl:variable name="prevfile">
    <xsl:choose>
      <xsl:when test="$prevfoil">
        <xsl:apply-templates select="$prevfoil" mode="filename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$titlefoil.html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="navfoot">
    <hr class="foot"/>
    <table class="footer" cellspacing="0" cellpadding="0" border="0" width="97%"
           summary="footer">
      <tr valign="bottom">
        <td>
          <xsl:variable name="author" select="(/slides/slidesinfo//author
                                              |/slides/slidesinfo//editor)"/>
          <xsl:for-each select="$author">
            <xsl:choose>
              <xsl:when test=".//email">
                <a href="mailto:{.//email[1]}">
                  <xsl:call-template name="person.name"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="person.name"/>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="position() &lt; last()">, </xsl:if>
          </xsl:for-each>
        </td>
        <td align="right">
          <p class="index">
            <xsl:value-of select="count(preceding::foil)
                                  + count(preceding::section)
                                  + count(ancestor::section)
                                  + 1"/>
            <xsl:text> of </xsl:text>
            <xsl:value-of select="count(//foil|//section)"/>
          </p>
        </td>
        <td valign="top" nowrap="nowrap" width="150">
          <div align="right">
            <a rel="previous" href="{$prevfile}" accesskey="P">
              <img border="0" width="32" height="32"
                   alt=" Previous" title="{$prevfoil/title}">
                  <xsl:attribute name="src">
                    <xsl:call-template name="w3c.left.image"/>
                  </xsl:attribute>
                </img>
            </a>
            <xsl:choose>
              <xsl:when test="$nextfoil != ''">
                <a rel="next" href="{$nextfile}" accesskey="N">
                  <img border="0" width="32" height="32"
                       alt=" Next" title="{$nextfoil/title}">
                  <xsl:attribute name="src">
                    <xsl:call-template name="w3c.right.image"/>
                  </xsl:attribute>
                </img>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <img border="0" width="32" height="32" alt=" The End.">
                  <xsl:attribute name="src">
                    <xsl:call-template name="w3c.bright.image"/>
                  </xsl:attribute>
                </img>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="title" mode="head.title">
  <h1 class="{name(.)}">
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="foil/title"/>

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
