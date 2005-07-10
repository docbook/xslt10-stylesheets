<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="man.links.list.enabled">1</xsl:param>

<!-- ==================================================================== -->

<xsl:template match="filename|replaceable|varname">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="option|userinput|envar|errorcode|constant|type">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role = 'bold' or @role = 'strong'">
      <xsl:apply-templates mode="bold" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="italic" select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<xsl:template name="do-citerefentry">
  <xsl:param name="refentrytitle" select="''"/>
  <xsl:param name="manvolnum" select="''"/>
  <xsl:variable name="title">
    <bold><xsl:value-of select="$refentrytitle"/></bold>
  </xsl:variable>
  <xsl:apply-templates mode="bold" select="exsl:node-set($title)"/>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$manvolnum"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:call-template name="do-citerefentry">
    <xsl:with-param name="refentrytitle" select="refentrytitle"/>
    <xsl:with-param name="manvolnum" select="manvolnum"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="trademark|productname">
  <xsl:apply-templates/>
  <xsl:choose>
    <!-- * Just use true Unicode chars for copyright, trademark, etc., -->
    <!-- * symbols (by default, we later automatically translate them -->
    <!-- * with the apply-string-subst-map template, or with the -->
    <!-- * default character map, if man.charmap.enabled is true). -->
    <xsl:when test="@class = 'copyright'">
      <xsl:text>&#x00a9;</xsl:text>
    </xsl:when>
    <xsl:when test="@class = 'registered'">
      <xsl:text>&#x00ae;</xsl:text>
    </xsl:when>
    <xsl:when test="@class = 'service'">
      <xsl:text>&#x2120;</xsl:text>
    </xsl:when>
    <xsl:when test="self::trademark" >
      <xsl:text>&#x2122;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- * don't render any default symbol after productname -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- * Here we deal with Ulink... -->
<!-- * -->
<!-- * Other link types are handled by templates from html/xref.xsl, -->
<!-- * which the manpages stylesheets import. But Ulinks - in -->
<!-- * particular, non-empty Ulinks - must be handled differently. -->
<!-- * -->
<!-- * So this is what we do: -->
<!-- * -->
<!-- * We first find out if the Ulink is empty; if it is, we just -->
<!-- * display the contents of its URL (that is, the value of its "Url" -->
<!-- * attribute), and stop there. -->
<!-- * -->
<!-- * On the other hand, if it is NON-empty, we need to display its -->
<!-- * contents AND (optionally) display its URL. We could display the -->
<!-- * URL inline, after the contents (as we did previously), but that -->
<!-- * ends up looking horrible if you have a lot of links. -->
<!-- * -->
<!-- * So, we instead need to display the URL out-of-line, in a way -->
<!-- * that associates it with the content. How to do that in a -->
<!-- * text-based output format that lacks hyperlinks? -->
<!-- * -->
<!-- * Here's how: Do it the way that most text/curses-based browsers -->
<!-- * (e.g., w3m and lynx) do in the "-dump" output: Put a number -->
<!-- * (in brackets) before the contents, and then put the URL, with -->
<!-- * the corresponding number, in a generated section -->
<!-- * at the end of the page. -->

<xsl:template match="ulink">
  <!-- * Note that we don't do anything for Ulinks in *info sections -->
  <!-- * or Refmeta or Refnamediv or Indexterm, because, in manpages -->
  <!-- * output, contents of those are either suppressed or are -->
  <!-- * displayed out of document order - for example, the Info/Author -->
  <!-- * content gets moved to the end of the page. So, if we were to -->
  <!-- * number links in the Author content, it would "throw off" the -->
  <!-- * numbering at the beginning of the main text flow. -->

  <xsl:variable name="unique.links"
           select=".//ulink[node()
                  and not(ancestor::refentryinfo)
                  and not(ancestor::info)
                  and not(ancestor::docinfo)
                  and not(ancestor::refmeta)
                  and not(ancestor::refnamediv)
                  and not(ancestor::indexterm)
                  and not(@url =
                  preceding::ulink[node()
                  and not(ancestor::refentryinfo)
                  and not(ancestor::info)
                  and not(ancestor::docinfo)
                  and not(ancestor::refmeta)
                  and not(ancestor::refnamediv)
                  and not(ancestor::indexterm)
                  and (generate-id(ancestor::refentry)
                  = generate-id(current()))]/@url)]"/>

  <xsl:variable name="url">
    <xsl:value-of select="@url"/>
  </xsl:variable>
  <xsl:variable name="link">
    <xsl:choose>
      <!-- * check to see if the element is empty or not; if it's non-empty, -->
      <!-- * get the content -->
      <xsl:when test="node()">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- * the element is empty, so we just get the value of the URL; -->
        <!-- * note that we don't number empty links -->
        <xsl:value-of select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- * if link is non-empty AND user wants links numbered, output -->
  <!-- * a number for it -->
  <xsl:if test="node() and $man.links.are.numbered != 0">
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test="$url = $unique.links/@url">
        <xsl:apply-templates
            select="$unique.links[@url = $url]"
            mode="link.number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="link.number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:choose>
    <!-- * if user wants links underlined, underline (ital) it -->
    <xsl:when test="$man.links.are.underlined != 0">
      <xsl:variable name="link.wrapper">
        <italic><xsl:value-of select="$link"/></italic>
      </xsl:variable>
      <xsl:apply-templates mode="italic" select="exsl:node-set($link.wrapper)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- * user doesn't want links underlined, so just display content -->
      <xsl:value-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="link.number">
  
  <!-- * we only number links that have child content and that aren't -->
  <!-- * in suppressed content or in content that gets rendered out of -->
  <!-- * document order -->
  <xsl:value-of select="count(preceding::ulink[node()
                        and not(ancestor::refentryinfo)
                        and not(ancestor::info)
                        and not(ancestor::docinfo)
                        and not(ancestor::refmeta)
                        and not(ancestor::refnamediv)
                        and not(ancestor::indexterm)
                        and not(@url = preceding::ulink[node()
                        and not(ancestor::refentryinfo)
                        and not(ancestor::info)
                        and not(ancestor::docinfo)
                        and not(ancestor::refmeta)
                        and not(ancestor::refnamediv)
                        and not(ancestor::indexterm)
                        and (generate-id(ancestor::refentry)
                        = generate-id(current()/ancestor::refentry))]/@url)]
                        [generate-id(ancestor::refentry)
                        = generate-id(current()/ancestor::refentry)]) + 1"/>
  <!-- * Note that we don't do anything for Ulinks in *info sections
       -->
  <!-- * or Refmeta or Refnamediv or Indexterm, because, in manpages -->
  <!-- * output, contents of those are either suppressed or are -->
  <!-- * displayed out of document order - for example, the Info/Author -->
  <!-- * content gets moved to the end of the page. So, if we were to -->
  <!-- * number links in the Author content, it would "throw off" the -->
  <!-- * numbering at the beginning of the main text flow. -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="links.list">
  <xsl:variable name="links"
                select=".//ulink[node()
                  and not(ancestor::refentryinfo)
                  and not(ancestor::info)
                  and not(ancestor::docinfo)
                  and not(ancestor::refmeta)
                  and not(ancestor::refnamediv)
                  and not(ancestor::indexterm)
                  and not(@url =
                  preceding::ulink[node()
                  and not(ancestor::refentryinfo)
                  and not(ancestor::info)
                  and not(ancestor::docinfo)
                  and not(ancestor::refmeta)
                  and not(ancestor::refnamediv)
                  and not(ancestor::indexterm)
                  and (generate-id(ancestor::refentry)
                  = generate-id(current()))]/@url)]"/>
  <xsl:if test="$links/node()">
    <xsl:call-template name="format.links.list">
      <xsl:with-param name="links" select="$links"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="format.links.list">
  <xsl:param name="links"/>
  <xsl:param name="heading">
    <xsl:choose>
      <xsl:when test="$man.links.section.heading != ''">
        <xsl:value-of select="$man.links.section.heading"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Links</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <!-- * The value of $padding.length is used for determining how much -->
  <!-- * to right-pad numbers in the LINKS list. So, for $length, we -->
  <!-- * count how many links there are, then take the number of digits -->
  <!-- * in that count, and add 2 to it. The reason we add 2 is that we -->
  <!-- * also prepend a dot and no-break space to each link number in -->
  <!-- * the list, so we need to consider what length to pad out to. -->
  <xsl:param name="padding.length">
    <xsl:choose>
      <xsl:when test="$man.links.are.numbered != 0">
        <xsl:value-of select="string-length(count($links)) + 2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:call-template name="mark.subheading"/>
  <!-- * make the LINKS section heading -->
  <xsl:text>.SH "</xsl:text>
  <xsl:call-template name="string.upper">
    <xsl:with-param name="string">
      <xsl:choose>
        <xsl:when test="$man.links.section.heading != ''">
          <xsl:value-of select="$man.links.section.heading"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'Links'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>"&#10;</xsl:text>
  <xsl:for-each select="$links">
    <xsl:variable name="link.number">
      <xsl:apply-templates select="." mode="link.number"/>
      <xsl:text>.&#160;</xsl:text>
    </xsl:variable>
    <xsl:text>.PP&#10;</xsl:text>
    <!-- * right-pad each number out to the correct length -->
    <xsl:call-template name="prepend-pad">
      <xsl:with-param name="padVar" select="$link.number"/>
      <xsl:with-param name="length" select="$padding.length"/>
    </xsl:call-template>
    <xsl:variable name="link.contents">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($link.contents)"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.br&#10;</xsl:text>
    <!-- * pad leader for URL -->
    <xsl:call-template name="prepend-pad">
      <xsl:with-param name="padVar" select="' '"/>
      <xsl:with-param name="length" select="$padding.length"/>
    </xsl:call-template>
    <!-- * print the Ulink's URL -->
    <xsl:value-of select="@url"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
