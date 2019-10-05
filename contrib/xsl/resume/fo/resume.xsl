<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="https://cdn.docbook.org/release/xsl/current/fo/docbook.xsl"/>

<xsl:output indent="yes"/>

<xsl:template name="resume-name">
  <xsl:apply-templates select="/article/articleinfo/address/firstname"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="/article/articleinfo/address/surname"/>
</xsl:template>

<xsl:template name="user.pagemasters">
  <fo:simple-page-master master-name="resume"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="0pt"
                         margin-bottom="1in"
                         margin-left="1in"
                         margin-right="1in">
    <fo:region-body
                    margin-bottom="{$body.margin.bottom}"
                    margin-top="{$body.margin.top}"/>
    <fo:region-before region-name="xsl-region-before-blank"
                      extent="{$region.before.extent}"/>
    <fo:region-after region-name="xsl-region-after-blank"
                     extent="{$region.after.extent}"/>
  </fo:simple-page-master>
</xsl:template>

<!--
(define ($left-header$ #!optional (gi (gi)))
  (if-first-page
   (empty-sosofo)
   (resume-name)))

(define ($center-header$ #!optional (gi (gi)))
  (empty-sosofo))

(define ($right-header$ #!optional (gi (gi)))
  (if-first-page
   (empty-sosofo)
   (page-number-sosofo)))
-->

<xsl:template match="article">
  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster"/>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="resume">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="'resume'"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="'resume'"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <xsl:apply-templates/>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="articleinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="articleinfo/title">
  <!-- suppress -->
</xsl:template>

<xsl:template match="article" mode="running.head.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <!-- none -->
</xsl:template>

<xsl:template match="article" mode="running.foot.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <!-- none -->
</xsl:template>

<xsl:template match="address">
  <fo:table table-layout="fixed" width="100%" space-after="1em"
            border-after-style="solid"
            border-after-width="1pt">
    <fo:table-body>
      <fo:table-row>
        <fo:table-cell>
          <fo:block>&#160;</fo:block>
        </fo:table-cell>
        <fo:table-cell display-align="after">
          <fo:block font-weight="bold" text-align="center">
            <xsl:call-template name="resume-name"/>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block>&#160;</fo:block>
        </fo:table-cell>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell display-align="after">
          <fo:block text-align="center">
            <xsl:choose>
              <xsl:when test="phone and fax and phone != fax">
                <xsl:text>Phone: </xsl:text>
                <xsl:apply-templates select="phone"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell number-rows-spanned="2" display-align="after">
          <xsl:choose>
            <xsl:when test="street or city">
              <xsl:for-each select="street">
                <fo:block text-align="center">
                  <xsl:apply-templates select="."/>
                </fo:block>
              </xsl:for-each>
              <fo:block text-align="center">
                <xsl:apply-templates select="city"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="state"/>
                <xsl:text>  </xsl:text>
                <xsl:apply-templates select="postcode"/>
              </fo:block>
            </xsl:when>
            <xsl:otherwise>
              <fo:block>&#160;</fo:block>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block>&#160;</fo:block>
        </fo:table-cell>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell display-align="after">
          <fo:block text-align="left">
            <xsl:choose>
              <xsl:when test="phone and fax and phone = fax">
                <xsl:text>Phone/Fax: </xsl:text>
                <xsl:apply-templates select="phone"/>
              </xsl:when>
              <xsl:when test="fax">
                <xsl:text>Fax: </xsl:text>
                <xsl:apply-templates select="fax"/>
              </xsl:when>
              <xsl:when test="phone">
                <xsl:text>Phone: </xsl:text>
                <xsl:apply-templates select="phone"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>
        <!-- overhang from above -->
        <fo:table-cell display-align="after">
          <fo:block text-align="right">
            <xsl:text>Email: </xsl:text>
            <xsl:apply-templates select="email"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
  <!-- <hr/> -->
</xsl:template>

<xsl:template match="sect1">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@role = 'experience'">
      <xsl:apply-templates select="." mode="experience"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sect1/title">
  <fo:block font-weight="bold"
            font-size="14pt"
            space-before="1em"
            space-after="0.5em"
            keep-with-next="always">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->
<!-- Experience -->

<xsl:template match="title|sect2info|sect3info" mode="experience">
  <!-- suppress -->
</xsl:template>

<xsl:template match="sect1" mode="experience">
  <fo:table table-layout="fixed" width="100%">
    <fo:table-body>
      <xsl:apply-templates mode="experience"/>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:template match="sect2" mode="experience">
  <fo:table-row>
    <fo:table-cell display-align="before"
                   number-rows-spanned="{(count(sect3)*2)+1}"
                   width="1in">
      <fo:block text-align="left">
        <xsl:apply-templates select="sect2info/pubdate" mode="experience"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell display-align="before" number-columns-spanned="2">
      <fo:block text-align="left">
        <xsl:apply-templates select="title" mode="experience-title"/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
  <xsl:apply-templates mode="experience"/>
</xsl:template>

<xsl:template match="sect3" mode="experience">
  <fo:table-row>
    <fo:table-cell display-align="before">
      <fo:block text-align="left">
        <xsl:apply-templates select="title" mode="experience-title"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell display-align="before">
      <fo:block text-align="left">
        <xsl:apply-templates select="sect3info/pubdate" mode="experience"/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
  <fo:table-row>
    <fo:table-cell display-align="before" number-columns-spanned="2">
      <fo:block text-align="left">
        <xsl:apply-templates mode="experience"/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="sect2/title" mode="experience-title">
  <fo:block font-weight="bold">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="sect3/title" mode="experience-title">
  <fo:block font-style="italic">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
