<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="html doc"
                version='1.0'>

<xsl:import href="website.xsl"/>

<!-- ==================================================================== -->

<xsl:param name="textbgcolor">white</xsl:param>

<doc:param name="textbgcolor" xmlns="">
<refpurpose>Background color of the text panel of the page</refpurpose>
<refdescription>
<para>The <varname>textbgcolor</varname> specifies the background color
used in the text panel of the web page.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="navbgcolor">red</xsl:param>

<doc:param name="navbgcolor" xmlns="">
<refpurpose>Background color of the navigation panel of the page</refpurpose>
<refdescription>
<para>The <varname>navbgcolor</varname> specifies the background color
used in the navigation panel of the web page.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="navtocwidth">220</xsl:param>

<doc:param name="navtocwidth" xmlns="">
<refpurpose>Width of the navigation panel of the page</refpurpose>
<refdescription>
<para>The <varname>navtocwidth</varname> specifies the width (generally
in pixels) of the navigation panel (column) of the web page.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="toc.pointer.graphic" select="0"/>

<doc:param name="toc.pointer.graphic" xmlns="">
<refpurpose>Toggle use of graphic for indicating the current position
in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.pointer.graphic</varname> is non-zero, a graphic
will be used to indicate the current position in the navigation panel.</para>
</refdescription>
</doc:param>

<xsl:param name="toc.pointer.image">images/rarrow.gif</xsl:param>

<doc:param name="toc.pointer.image" xmlns="">
<refpurpose>Filename of the graphic to use to indicate the current
position in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.pointer.graphic</varname> is non-zero, the
graphic specified by <varname>toc.pointer.image</varname> will be used
to highlight the current position in the navigation panel.</para>
</refdescription>
</doc:param>

<xsl:param name="toc.pointer.text">&gt;</xsl:param>

<doc:param name="toc.pointer.text" xmlns="">
<refpurpose>Text to use to indicate the current
position in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.pointer.graphic</varname> is zero, the
text specified by <varname>toc.pointer.text</varname> will be used
to highlight the current position in the navigation panel.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="toc.spacer.graphic" select="0"/>

<doc:param name="toc.spacer.graphic" xmlns="">
<refpurpose>Toggle use of graphic for indenting the lines
in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.spacer.graphic</varname> is non-zero, a graphic
will be used to indent the lines in the navigation panel.</para>
</refdescription>
</doc:param>

<xsl:param name="toc.spacer.image"></xsl:param>

<doc:param name="toc.spacer.image" xmlns="">
<refpurpose>Filename of the graphic to use to indent the lines
in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.spacer.graphic</varname> is non-zero, the
graphic specified by <varname>toc.spacer.image</varname> will be used
to indent the lines in the navigation panel.</para>
</refdescription>
</doc:param>

<xsl:param name="toc.spacer.text">&#160;&#160;&#160;</xsl:param>

<doc:param name="toc.spacer.text" xmlns="">
<refpurpose>Text to use to indent the lines
in the navigation panel</refpurpose>
<refdescription>
<para>If <varname>toc.spacer.graphic</varname> is zero, the
text specified by <varname>toc.spacer.text</varname> will be used
to indent the lines in the navigation panel.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="footer.spans.page" select="1"/>

<doc:param name="footer.spans.page" xmlns="">
<refpurpose>Toggle footer width</refpurpose>
<refdescription>
<para>If non-zero, the page footer will span the entire page. If zero,
the footer spans only the text panel.</para>
</refdescription>
</doc:param>

<xsl:param name="nav.table.summary"></xsl:param>

<doc:param name="nav.table.summary" xmlns="">
<refpurpose>Summary attribute for HTML Table</refpurpose>
<refdescription>
<para>If not-empty, this value will be used for the summary
attribute on the navigation tables.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:template name="home.navhead">
<xsl:text>home.navhead</xsl:text>
</xsl:template>

<xsl:template name="home.navhead.upperright">
<xsl:text>home.navhead.upperright</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="homepage">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <div id="{$id}" class="{name(.)}">
    <a name="{$id}"/>

    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>

    <table border="0" cellpadding="5" cellspacing="0" width="100%">
      <xsl:if test="$nav.table.summary!=''">
	<xsl:attribute name="summary">
	  <xsl:value-of select="$nav.table.summary"/>
	</xsl:attribute>
      </xsl:if>
    <tr>
      <td width="{$navtocwidth}" bgcolor="{$navbgcolor}"
          valign="top" align="left" rowspan="3">
        <p class="navtoc">
          <xsl:call-template name="nav.toc">
            <xsl:with-param name="pages" select="/website/webpage"/>
          </xsl:call-template>
        </p>
      </td>
      <td valign="bottom" bgcolor="{$textbgcolor}">&#160;</td>
      <td align="left" valign="bottom" bgcolor="{$textbgcolor}" height="35">
        <xsl:call-template name="home.navhead"/>
      </td>
      <td align="right" valign="bottom" bgcolor="{$textbgcolor}" height="35">
        <xsl:call-template name="home.navhead.upperright"/>
      </td>
    </tr>
    <tr>
      <td bgcolor="{$textbgcolor}">&#160;</td>
      <td colspan="2" bgcolor="{$textbgcolor}">
        <xsl:text>&#160;</xsl:text>
      </td>
    </tr>
    <tr>
      <td bgcolor="{$textbgcolor}">&#160;</td>
      <td colspan="2" bgcolor="{$textbgcolor}">
        <xsl:apply-templates/>
        <xsl:call-template name="process.footnotes"/>
      </td>
    </tr>

    <xsl:if test="$footer.spans.page = '0'">
      <tr>
        <td bgcolor="{$textbgcolor}">&#160;</td>
        <td colspan="2" bgcolor="{$textbgcolor}">
          <xsl:call-template name="webpage.footer"/>
        </td>
      </tr>
    </xsl:if>

    </table>

    <xsl:if test="$footer.spans.page != '0'">
      <xsl:call-template name="webpage.footer"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="webpage">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <div id="{$id}" class="{name(.)}">
    <a name="{$id}"/>

    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>

    <table border="0" cellpadding="5" cellspacing="0" width="100%">
      <xsl:if test="$nav.table.summary!=''">
	<xsl:attribute name="summary">
	  <xsl:value-of select="$nav.table.summary"/>
	</xsl:attribute>
      </xsl:if>
    <tr>
      <td width="{$navtocwidth}" bgcolor="{$navbgcolor}"
          valign="top" align="left">
        <p class="navtoc">
          <xsl:call-template name="nav.toc">
            <xsl:with-param name="pages" select="/website/webpage"/>
          </xsl:call-template>
        </p>
      </td>
      <td bgcolor="{$textbgcolor}">&#160;</td>
      <td align="left" valign="top" bgcolor="{$textbgcolor}">
        <xsl:apply-templates select="./head/title" mode="title.mode"/>
        <xsl:apply-templates/>
        <xsl:call-template name="process.footnotes"/>
        <br/>
      </td>
    </tr>
    </table>

    <xsl:call-template name="webpage.footer"/>
  </div>
</xsl:template>

<xsl:template name="nav.toc">
  <xsl:param name="curpage" select="."/>
  <xsl:param name="pages"></xsl:param>

  <xsl:variable name="homebanner"
                select="/website/homepage/config[@param='homebanner']/@value"/>
  <xsl:variable name="homebanneralt"
                select="/website/homepage/config[@param='homebanner']/@altval"/>
  <xsl:variable name="banner"
                select="/website/homepage/config[@param='banner']/@value"/>
  <xsl:variable name="banneralt"
                select="/website/homepage/config[@param='banner']/@altval"/>

  <xsl:variable name="hometitle" select="/website/homepage/head/title[1]"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$curpage"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="/website/homepage=$curpage">
      <img src="{$relpath}{$homebanner}"
           alt="{$homebanneralt}" align="left" border="0"/>
      <br clear="all"/>
      <br/>
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="/website/homepage"/>
          </xsl:call-template>
        </xsl:attribute>
        <img src="{$relpath}{$banner}"
             alt="{$banneralt}" align="left" border="0"/>
      </a>
      <br clear="all"/>
      <br/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="$pages" mode="table.toc">
    <xsl:with-param name="curpage" select="$curpage"/>
  </xsl:apply-templates>
  <br/>
</xsl:template>

<xsl:template match="webpage" mode="table.toc">
  <xsl:param name="curpage" select="."/>
  <xsl:param name="toclevel" select="1"/>

  <xsl:variable name="notoc" select="config[@param='notoc']/@value"/>

  <xsl:choose>
    <xsl:when test="$notoc='1'">
<!--
      <xsl:message>
        <xsl:text>Not in TOC: </xsl:text>
        <xsl:value-of select="head/title"/>
      </xsl:message>
-->
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="webpage.nav.toc">
        <xsl:with-param name="curpage" select="$curpage"/>
        <xsl:with-param name="toclevel" select="$toclevel"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="insert.spacers">
  <xsl:param name="count" select="0"/>
  <xsl:param name="relpath"></xsl:param>
  <xsl:if test="$count>0">
    <xsl:choose>
      <xsl:when test="$toc.spacer.graphic">
        <img src="{$relpath}{$toc.spacer.image}" alt="{$toc.spacer.text}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$toc.spacer.text"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="insert.spacers">
      <xsl:with-param name="count" select="$count - 1"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="webpage.nav.toc">
  <xsl:param name="curpage" select="."/>
  <xsl:param name="toclevel" select="1"/>
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="title" select="(head/title|head/titleabbrev)[last()]"/>

  <xsl:variable name="summary" select="head/summary[1]"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$curpage"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="insert.spacers">
    <xsl:with-param name="count" select="$toclevel"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:call-template>

  <span>
    <xsl:if test="$toclevel>1">
      <xsl:attribute name="class">
        <xsl:text>shrink</xsl:text>
        <xsl:value-of select="$toclevel - 1"/>
      </xsl:attribute>
    </xsl:if>

  <xsl:variable name="isdescendant">
    <xsl:call-template name="isdescendant">
      <xsl:with-param name="curpage" select="$curpage"/>
      <xsl:with-param name="here" select="."/>
    </xsl:call-template>
  </xsl:variable>

    <xsl:choose>
      <xsl:when test=".=$curpage">
        <span class="xnavtoc">
          <xsl:choose>
            <xsl:when test="$toc.pointer.graphic != 0">
              <img src="{$relpath}{$toc.pointer.image}"
                   alt="{$toc.pointer.text}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toc.pointer.text"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="$title" mode="table.toc"/>
        </span>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <span>
	  <xsl:choose>
	    <xsl:when test="$isdescendant='0'">
	      <xsl:attribute name="class">navtoc</xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:attribute name="class">ynavtoc</xsl:attribute>
	    </xsl:otherwise>
	  </xsl:choose>

          <xsl:call-template name="insert.spacers">
            <xsl:with-param name="count" select="1"/>
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="from-page" select="$curpage"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="$title" mode="table.toc"/>
          </a>
        </span>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </span>

  <xsl:variable name="isancestor">
    <xsl:call-template name="isancestor">
      <xsl:with-param name="curpage" select="$curpage"/>
      <xsl:with-param name="here" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$isancestor='1'">
    <xsl:apply-templates select="webpage" mode="table.toc">
      <xsl:with-param name="curpage" select="$curpage"/>
      <xsl:with-param name="toclevel" select="$toclevel + 1"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="isancestor">
  <!-- returns 1 iff here is an ancestor of curpage -->
  <xsl:param name="curpage" select="."/>
  <xsl:param name="here" select="."/>

  <xsl:choose>
    <xsl:when test="$curpage = $here">1</xsl:when>
    <xsl:when test="count($curpage/parent::*)>0">
      <xsl:call-template name="isancestor">
        <xsl:with-param name="curpage" select="($curpage/parent::*)[1]"/>
        <xsl:with-param name="here" select="$here"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isdescendant">
  <!-- returns 1 iff here is an descendant of curpage -->
  <xsl:param name="curpage" select="."/>
  <xsl:param name="here" select="."/>

  <xsl:choose>
    <xsl:when test="$curpage = $here">1</xsl:when>
    <xsl:when test="count($here/parent::*)>0">
      <xsl:call-template name="isdescendant">
        <xsl:with-param name="curpage" select="$curpage"/>
        <xsl:with-param name="here" select="($here/parent::*)[1]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="head/title" mode="navtoc.title.mode">
  <b><xsl:apply-templates/></b>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="title" mode="table.toc">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="titleabbrev" mode="table.toc">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="summary" mode="table.toc">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="webtoc">
</xsl:template>

<xsl:template match="config[@param='filename']">
</xsl:template>

</xsl:stylesheet>
