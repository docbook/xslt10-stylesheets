<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:template name="section-top-nav">
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

  <div class="navhead">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <td align="left" width="10%">
          <xsl:choose>
            <xsl:when test="$prevfoil != ''">
              <a href="{$prevfoil}">
                <xsl:if test="$multiframe!=0">
                  <xsl:attribute name="target">foil</xsl:attribute>
                </xsl:if>
                <img alt="Prev" src="{$graphics.dir}/{$left.image}" border="0"/>
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
                <xsl:if test="$multiframe!=0">
                  <xsl:attribute name="target">foil</xsl:attribute>
                </xsl:if>
                <img alt="Next" src="{$graphics.dir}/{$right.image}" border="0"/>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template name="section-bottom-nav">
  <div class="navfoot">
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
      <xsl:otherwise>titlefoil.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="navhead">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"
           summary="Navigation">
      <tr>
        <td align="left" width="10%">
          <xsl:choose>
            <xsl:when test="$prevfoil != ''">
              <a href="{$prevfoil}">
                <xsl:if test="$multiframe!=0">
                  <xsl:attribute name="target">foil</xsl:attribute>
                </xsl:if>
                <img alt="Prev" src="{$graphics.dir}/{$left.image}" border="0"/>
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
                <xsl:if test="$multiframe!=0">
                  <xsl:attribute name="target">foil</xsl:attribute>
                </xsl:if>
                <img alt="Next" src="{$graphics.dir}/{$right.image}" border="0"/>
              </a>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template name="foil-bottom-nav">
  <div class="navfoot">
    <table width="100%" border="0" cellspacing="0" cellpadding="0"
           summary="Navigation">
      <tr>
        <td align="left" width="80%" valign="top">
          <span class="navfooter">
            <xsl:apply-templates select="/slides/slidesinfo/copyright"
                                 mode="slide.navigation.mode"/>
          </span>
        </td>
        <td align="right" width="20%" valign="top">
          <span class="navfooter">
            <xsl:number count="foil" level="any"/>
          </span>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

</xsl:stylesheet>
