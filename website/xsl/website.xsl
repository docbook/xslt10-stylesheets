<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the WebSite distribution.
     See ../README or http://nwalsh.com/website/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:import href="/share/xsl/docbook/xhtml/docbook.xsl"/>
<xsl:import href="xbel.xsl"/>
<xsl:include href="VERSION"/>
<xsl:include href="head.xsl"/>

<xsl:param name="using.chunker">1</xsl:param>

<xsl:preserve-space elements="*"/>
<xsl:strip-space elements="website homepage webpage"/>

<xsl:output method="xml"
            indent="no"
            doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
            doctype-system="http://www.w3.org/TR/html4/loose.dtd"
/>

<!-- ==================================================================== -->

<xsl:param name="footer.hr" select="1"/>

<doc:param name="footer.hr" xmlns="">
<refpurpose>Toggle &lt;HR> before footer</refpurpose>
<refdescription>
<para>If non-zero, an &lt;HR> is generated at the bottom of each web page,
before the footer.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="feedback.href"></xsl:param>

<doc:param name="feedback.href" xmlns="">
<refpurpose>HREF for feedback link</refpurpose>
<refdescription>
<para>The <varname>feedback.href</varname> value is used as the value
for the <sgmltag class="attribute">href</sgmltag> attribute on the feedback
link, if it is not the empty string. If <varname>feedback.href</varname>
is empty, no feedback link is generated.</para>
</refdescription>
</doc:param>

<xsl:param name="feedback.title" select="0"/>

<doc:param name="feedback.title" xmlns="">
<refpurpose>Toggle use of titles in feedback</refpurpose>
<refdescription>
<para>If <varname>feedback.title</varname> is non-zero, the title of the
current page will be added to the feedback link. This can be used, for
example, if the <varname>feedback.href</varname> is a CGI script.</para>
</refdescription>
</doc:param>

<xsl:param name="feedback.link.text">Feedback</xsl:param>

<doc:param name="feedback.link.text" xmlns="">
<refpurpose>The text of the feedback link</refpurpose>
<refdescription>
<para>The contents of this variable is used as the text of the feedback
link if <varname>feedback.href</varname> is not empty. If
<varname>feedback.href</varname> is empty, no feedback link is
generated.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="root-rel-path"/>
  <xsl:value-of select="$admon.graphics.path"/>
  <xsl:choose>
    <xsl:when test="name($node)='note'">note.gif</xsl:when>
    <xsl:when test="name($node)='warning'">warning.gif</xsl:when>
    <xsl:when test="name($node)='caution'">caution.gif</xsl:when>
    <xsl:when test="name($node)='tip'">tip.gif</xsl:when>
    <xsl:when test="name($node)='important'">important.gif</xsl:when>
    <xsl:otherwise>note.gif</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<doc:template name="admon.graphic">
<refpurpose>Select appropriate admonition graphic</refpurpose>
<refdescription>
<para>Selects the appropriate admonition graphic file and returns the
fully qualified path to it.</para>
</refdescription>
<refparam>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The source node to use for the purpose of selection. It should
be one of the admonition elements (<sgmltag>note</sgmltag>,
<sgmltag>warning</sgmltag>, etc.). The default node is the context
node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparam>
<refreturns>
<para>The fully qualified path to the admonition graphic. If the
<varname>node</varname> is not an admonition element, the
  <quote>note</quote> graphic is returned.</para>
</refreturns>
</doc:template>

<!-- ==================================================================== -->

<xsl:template match="/">
  <html>
    <head>
      <title>nothing matters here since the chunker reworks the head</title>
    </head>
    <body>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="website">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="home.navhead">
  <div class="navhomehead">
    <div class="navbar">
      <xsl:text>Home</xsl:text>
      <xsl:text>@</xsl:text>
      <xsl:call-template name="webpage.header">
        <xsl:with-param name="thispage" select="."/>
        <xsl:with-param name="pages" select="/website/webpage"/>
        <xsl:with-param name="text.before"> | </xsl:with-param>
      </xsl:call-template>
      <hr/>
    </div>
  </div>
</xsl:template>

<xsl:template match="homepage">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <div id="{$id}" class="{name(.)}">
    <a name="{$id}"/>

    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>

    <xsl:call-template name="home.navhead"/>

    <xsl:apply-templates select="./head/title" mode="title.mode"/>

    <xsl:apply-templates/>

    <xsl:call-template name="process.footnotes"/>

    <xsl:call-template name="webpage.footer"/>
  </div>
</xsl:template>

<xsl:template name="page.navhead">
  <div class="navhead">
    <div class="navbar">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="/website/homepage"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>Home</xsl:text>
      </a>
      <xsl:call-template name="webpage.header">
        <xsl:with-param name="thispage" select="."/>
        <xsl:with-param name="pages" select="/website/webpage"/>
        <xsl:with-param name="text.before"> | </xsl:with-param>
      </xsl:call-template>
    </div>

    <div class="navbar">
      <xsl:if test="ancestor::webpage">
        <xsl:call-template name="webpage.subheaders">
          <xsl:with-param name="pages" select="ancestor::webpage"/>
        </xsl:call-template>

        <xsl:apply-templates select="./head/title[1]" mode="toc.mode"/>
        <xsl:text>@</xsl:text>
      </xsl:if>

      <hr/>
    </div>
  </div>
</xsl:template>

<xsl:template match="webpage">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <div id="{$id}" class="{name(.)}">
    <a name="{$id}"/>

    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>

    <xsl:call-template name="page.navhead"/>

    <xsl:apply-templates select="./head/title" mode="title.mode"/>

    <xsl:apply-templates/>

    <xsl:call-template name="process.footnotes"/>

    <xsl:call-template name="webpage.footer"/>
  </div>
</xsl:template>

<xsl:template name="webpage.subheaders">
  <xsl:param name="pages"></xsl:param>
  <xsl:param name="count" select="count($pages)"/>

  <xsl:call-template name="webpage.header">
    <xsl:with-param name="thispage" select="pages[$count=position()]"/>
    <xsl:with-param name="pages" select="$pages"/>
    <xsl:with-param name="text.after"> - </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="webpage.header">
  <xsl:param name="thispage" select="."/>
  <xsl:param name="pages"></xsl:param>
  <xsl:param name="text.before"></xsl:param>
  <xsl:param name="text.after"></xsl:param>
  <xsl:param name="count" select="1"/>
  <xsl:choose>
    <xsl:when test="$count>count($pages)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="curpage" select="$pages[$count=position()]"/>
      <xsl:variable name="title">
        <xsl:apply-templates select="$curpage/head/title[1]" mode="toc.mode"/>
      </xsl:variable>

      <xsl:value-of select="$text.before"/>
      <xsl:choose>
        <xsl:when test="$thispage=$curpage">
          <xsl:copy-of select="$title"/>
          <xsl:text>@</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="$curpage"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:copy-of select="$title"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$text.after"/>
      <xsl:call-template name="webpage.header">
        <xsl:with-param name="thispage" select="$thispage"/>
        <xsl:with-param name="pages" select="$pages"/>
        <xsl:with-param name="text.before" select="$text.before"/>
        <xsl:with-param name="text.after" select="$text.after"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="webpage.footer">
  <xsl:variable name="page" select="."/>
  <xsl:variable name="rcsdate" select="$page/config[@param='rcsdate']/@value"/>
  <xsl:variable name="title">
    <xsl:value-of select="$page/head/title[1]"/>
  </xsl:variable>
  <xsl:variable name="footers" select="$page/config[@param='footer']"/>
  <xsl:variable name="copyright" select="/website/homepage/head/copyright[1]"/>

  <div class="navfoot">
    <xsl:if test="$footer.hr != 0"><hr/></xsl:if>
    <table width="100%" border="0" summary="Footer navigation">
    <tr>
      <td width="33%" align="left">
        <span class="footdate"><xsl:value-of select="$rcsdate"/></span>
      </td>
      <td width="34%" align="center">
        <xsl:variable name="id">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="/website/homepage"/>
          </xsl:call-template>
        </xsl:variable>
        <span class="foothome">
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="/website/homepage"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>Home</xsl:text>
          </a>
        </span>

        <xsl:apply-templates select="$footers" mode="footer.link.mode"/>
      </td>
      <td width="33%" align="right">
        <span class="footfeed">
          <xsl:if test="$feedback.href != ''">
            <a>
              <xsl:choose>
                <xsl:when test="$feedback.title != 0">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$feedback.href"/>
                    <xsl:value-of select="$title"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$feedback.href"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
	      <xsl:value-of select="$feedback.link.text"/>
	    </a>
          </xsl:if>
        </span>
      </td>
    </tr>
    <tr>
      <td colspan="3" align="right">
        <span class="footcopy">
          <xsl:apply-templates select="$copyright" mode="footer.mode"/>
        </span>
      </td>
    </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="config" mode="footer.link.mode">
  <span class="foothome">
    <xsl:text> | </xsl:text>
    <a href="{@value}"><xsl:value-of select="@altval"/></a>
  </span>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="copyright" mode="footer.mode">
  <span class="{name(.)}">
    <xsl:call-template name="gentext.element.name"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="year" mode="footer.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="holder" mode="footer.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="year" mode="footer.mode">
  <xsl:apply-templates/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="year[position()=last()]" mode="footer.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="holder" mode="footer.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="holder[@role]" mode="footer.mode">
  <a href="{@role}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="config">
</xsl:template>

<xsl:template match="config[@param='filename']" mode="head.mode">
  <xsl:variable name="dir" select="../config[@param='dir']"/>
  <xsl:if test="$using.chunker = '1'">
    <xsl:choose>
      <xsl:when test="$dir">
	<xsl:processing-instruction name="dbhtml">
	  <xsl:text>filename="</xsl:text>
	  <xsl:value-of select="$dir/@value"/>
	  <xsl:text>/</xsl:text>
	  <xsl:value-of select="@value"/>
	  <xsl:text>"</xsl:text>
	</xsl:processing-instruction>
      </xsl:when>
      <xsl:otherwise>
	<xsl:processing-instruction name="dbhtml">
	  <xsl:text>filename="</xsl:text>
	  <xsl:value-of select="@value"/>
	  <xsl:text>"</xsl:text>
	</xsl:processing-instruction>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="head">
</xsl:template>

<xsl:template match="head/title" mode="title.mode">
  <h1><xsl:apply-templates/></h1>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="directory-depth">
  <xsl:param name="dir"></xsl:param>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test='contains($dir,"/")'>
      <xsl:call-template name="directory-depth">
        <xsl:with-param name="dir" select="substring-after($dir,'/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test='$dir=""'>
          <xsl:value-of select="$count"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$count + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="root-rel-path">
  <xsl:param name="webpage" select="ancestor-or-self::webpage"/>
  <xsl:variable name="dir" select="$webpage[last()]/config[@param='dir']"/>
  <xsl:variable name="depth">
    <xsl:call-template name="directory-depth">
      <xsl:with-param name="dir" select="$dir/@value"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$dir">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string">../</xsl:with-param>
        <xsl:with-param name="count" select="$depth"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="webtoc">
  <xsl:choose>
    <xsl:when test="ancestor::homepage">
      <xsl:call-template name="toc">
        <xsl:with-param name="pages" select="/website/webpage"/>
        <xsl:with-param name="from-page"
                        select="(ancestor-or-self::webpage
                                 |ancestor-or-self::homepage)[last()]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="toc">
        <xsl:with-param name="pages" select="ancestor::webpage[1]/webpage"/>
        <xsl:with-param name="from-page"
                        select="(ancestor-or-self::webpage
                                 |ancestor-or-self::homepage)[last()]"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="toc">
  <xsl:param name="pages"></xsl:param>
  <xsl:param name="from-page"></xsl:param>
  <ul>
    <xsl:apply-templates select="$pages" mode="toc.mode">
      <xsl:with-param name="from-page" select="$from-page"/>
    </xsl:apply-templates>
  </ul>
</xsl:template>

<xsl:template match="webpage" mode="toc.mode">
  <xsl:variable name="notoc" select="config[@param='notoc']/@value"/>
  <xsl:param name="from-page"></xsl:param>

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
      <xsl:variable name="title" select="./head/title[1]"/>
      <xsl:variable name="summary" select="./head/summary[1]"/>
      <li>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="from-page" select="$from-page"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$title" mode="toc.mode"/>
        </a>
        <xsl:if test="$summary">
          <xsl:text> - </xsl:text>
          <xsl:apply-templates select="$summary" mode="toc.mode"/>
        </xsl:if>
      </li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="title" mode="toc.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="summary" mode="toc.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="titleabbrev">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="footnote" mode="footnote.number">
  <xsl:choose>
    <xsl:when test="ancestor::table|ancestor::informaltable">
      <xsl:number level="any" from="table|informaltable" format="a"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="any" from="webpage|homepage" format="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.footnotes">
  <!-- we're only interested in footnotes that occur on this page, not
       on descendants of this page (which will be similarly processed) -->
  <xsl:variable name="thispage"
                select="(ancestor-or-self::webpage
                         |ancestor-or-self::homepage)[last()]"/>
  <xsl:variable name="footnotes"
                select=".//footnote[(ancestor-or-self::webpage
                                     |ancestor-or-self::homepage)[last()]
                                    =$thispage]"/>
  <xsl:variable name="table.footnotes"
                select=".//table//footnote[(ancestor-or-self::webpage
                                     |ancestor-or-self::homepage)[last()]
                                    =$thispage]
                        |.//informaltable//footnote[(ancestor-or-self::webpage
                                     |ancestor-or-self::homepage)[last()]
                                    =$thispage]"/>

  <!-- Only bother to do this if there's at least one non-table footnote -->
  <xsl:if test="count($footnotes)>count($table.footnotes)">
    <div class="footnotes">
      <hr width="100" align="left"/>
      <xsl:apply-templates select="$footnotes" mode="process.footnote.mode"/>
    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xlink">
  <xsl:choose>
    <xsl:when test="@actuate='auto'">
      <xsl:choose>
	<xsl:when test="@role='dynamic'">
	  <xsl:apply-templates select="document(@href,.)" mode="dynamic"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="document(@href,.)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="@role='olink'">
          <a href="/cgi-bin/olink?{@href}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <a href="{@href}"><xsl:apply-templates/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="olink">
  <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
  <xsl:apply-templates select="document(unparsed-entity-uri(@targetdocent),.)"/>
  <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
</xsl:template>

<xsl:template match="html:*">
  <xsl:element name="{local-name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*" mode="copy">
  <xsl:attribute name="{local-name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
