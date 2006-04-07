<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * This file contains named templates related to things other than -->
<!-- * just assembling the actual text of the main text flow of each man -->
<!-- * page. This "other" stuff currently amounts to these steps: -->
<!-- * -->
<!-- *  - add a comment to top part of roff source of each page -->
<!-- *  - make a .TH title line (for controlling page header/footer) -->
<!-- *  - set hyphenation, alignment, indent & line-breaking defaults -->
<!-- *  - "prepare" the complete man page contents for final output -->
<!-- *  - write the actual man file to the filesystem -->
<!-- *  - write any "stub" pages to the filesystem -->
<!-- * -->
<!-- * The templates in this file are actually called only once per -->
<!-- * each Refentry; they are just in a separate file for the purpose -->
<!-- * of keeping things modular. -->

<!-- ==================================================================== -->
<!-- * Get character map contents -->
<!-- ==================================================================== -->

  <xsl:variable name="man.charmap.contents">
    <xsl:if test="$man.charmap.enabled != 0">
      <xsl:call-template name="read-character-map">
        <xsl:with-param name="use.subset" select="$man.charmap.use.subset"/>
        <xsl:with-param name="subset.profile" select="$man.charmap.subset.profile"/>
        <xsl:with-param name="uri">
          <xsl:choose>
            <xsl:when test="$man.charmap.uri != ''">
              <xsl:value-of select="$man.charmap.uri"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'../manpages/charmap.groff.xsl'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

<!-- ==================================================================== -->

<!-- * top.comment generates a comment containing metadata for the man -->
<!-- * page; for example, Author, Generator, and Date information -->

  <xsl:template name="top.comment">
    <xsl:param name="info"/>
    <xsl:param name="date"/>
    <xsl:param name="title"/>
    <xsl:param name="manual"/>
    <xsl:param name="source"/>
    <xsl:text>.\"     Title: </xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Author: </xsl:text>
      <xsl:call-template name="make.roff.metadata.author">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\" Generator: DocBook XSL Stylesheets v</xsl:text>
    <xsl:value-of select="$VERSION"/>
    <xsl:text> &lt;http://docbook.sf.net/></xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"      Date: </xsl:text>
      <xsl:call-template name="string.subst">
        <!-- * replace hyphens in date with dots -->
        <xsl:with-param name="string" select="$date"/>
        <xsl:with-param name="target" select="'-'"/>
        <xsl:with-param name="replacement" select="'.'"/>
      </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Manual: </xsl:text>
    <xsl:value-of select="$manual"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Source: </xsl:text>
    <xsl:value-of select="$source"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template name="TH.title.line">

    <!-- * The exact way that .TH contents are displayed is system- -->
    <!-- * dependent; it varies somewhat between OSes and roff -->
    <!-- * versions. Below is a description of how Linux systems with -->
    <!-- * a modern groff seem to render .TH contents. -->
    <!-- * -->
    <!-- *   title(section)  extra3  title(section)  <- page header -->
    <!-- *   extra2          extra1  title(section)  <- page footer-->
    <!-- * -->
    <!-- * Or, using the names with which the man(7) man page refers -->
    <!-- * to the various fields: -->
    <!-- * -->
    <!-- *   title(section)  manual  title(section)  <- page header -->
    <!-- *   source          date    title(section)  <- page footer-->
    <!-- * -->
    <!-- * Note that while extra1, extra2, and extra3 are all (nominally) -->
    <!-- * optional, in practice almost all pages include an "extra1" -->
    <!-- * field, which is, universally, a date (in some form), and it is -->
    <!-- * always rendered in the same place (the middle footer position) -->
    <!-- * -->
    <!-- * Here are a couple of examples of real-world man pages that -->
    <!-- * have somewhat useful page headers/footers: -->
    <!-- * -->
    <!-- *   gtk-options(7)    GTK+ User's Manual   gtk-options(7) -->
    <!-- *   GTK+ 1.2              2003-10-20       gtk-options(7) -->
    <!-- * -->
    <!-- *   svgalib(7)       Svgalib User Manual       svgalib(7) -->
    <!-- *   Svgalib 1.4.1      16 December 1999        svgalib(7) -->
    <!-- * -->
    <xsl:param name="title"/>
    <xsl:param name="section"/>
    <xsl:param name="extra1"/>
    <xsl:param name="extra2"/>
    <xsl:param name="extra3"/>

    <xsl:call-template name="mark.subheading"/>
    <!-- * Note that we generate quotes around _every_ field in the -->
    <!-- * .TH title line, including the "title" and "section" -->
    <!-- * fields. That is because we use the contents of those "as -->
    <!-- * is", unchanged from the DocBook source; and DTD-based -->
    <!-- * validation does not provide a way to constrain them to be -->
    <!-- * "space free" -->
    <xsl:text>.TH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test="$man.th.title.max.length != ''">
            <xsl:value-of
                select="normalize-space(substring($title, 1, $man.th.title.max.length))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($title)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($section)"/>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra1.suppress = 0">
      <!-- * there is no max.length for the extra1 field; the reason -->
      <!-- * is, it is almost always a date, and it is not possible -->
      <!-- * to truncate dates without changing their meaning -->
      <xsl:value-of select="normalize-space($extra1)"/>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra2.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra2.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra2, 1, $man.th.extra2.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra2)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra3.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra3.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra3, 1, $man.th.extra3.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra3)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>"&#10;</xsl:text>
    <xsl:call-template name="mark.subheading"/>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template name="set.default.formatting">
    <!-- * Set default hyphenation, justification, indentation and -->
    <!-- * line-breaking -->
    <!-- * -->
    <!-- * If the value of man.hypenate is zero (the default), then -->
    <!-- * disable hyphenation (".nh" = "no hyphenation") -->
    <xsl:if test="$man.hyphenate = 0">
      <xsl:text>.\" disable hyphenation&#10;</xsl:text>
      <xsl:text>.nh&#10;</xsl:text>
    </xsl:if>
    <!-- * If the value of man.justify is zero (the default), then -->
    <!-- * disable justification (".ad l" means "adjust to left only") -->
    <xsl:if test="$man.justify = 0">
      <xsl:text>.\" disable justification</xsl:text>
      <xsl:text> (adjust text to left margin only)&#10;</xsl:text>
      <xsl:text>.ad l&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$man.indentation.default.adjust != 0">
      <xsl:text>.\" store initial "default indentation value"&#10;</xsl:text>
      <xsl:text>.nr zq \n(IN&#10;</xsl:text>
      <xsl:text>.\" adjust default indentation&#10;</xsl:text>
      <xsl:text>.nr IN </xsl:text>
      <xsl:value-of select="$man.indentation.default.value"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>.\" adjust indentation of SS headings&#10;</xsl:text>
      <xsl:text>.nr SN \n(IN&#10;</xsl:text>
    </xsl:if>
    <!-- * Unless the value of man.break.after.slash is zero (the -->
    <!-- * default), tell groff that it is OK to break a line -->
    <!-- * after a slash when needed. -->
    <xsl:if test="$man.break.after.slash != 0">
      <xsl:text>.\" enable line breaks after slashes&#10;</xsl:text>
      <xsl:text>.cflags 4 /&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * The prepare.manpage.contents template is called after -->
  <!-- * everything else has been done, just before writing the actual -->
  <!-- * man-page files to the filesystem. It works on the entire roff -->
  <!-- * source for each man page (not just the visible contents). -->
  <xsl:template name="prepare.manpage.contents">
    <xsl:param name="content" select="''"/>

    <!-- * First do "essential" string/character substitutions; for -->
    <!-- * example, the backslash character _must_ be substituted with -->
    <!-- * a double backslash, to prevent it from being interpreted as -->
    <!-- * a roff escape -->
    <xsl:variable name="adjusted.content">
      <xsl:call-template name="apply-string-subst-map">
        <xsl:with-param name="content" select="$content"/>
        <xsl:with-param name="map.contents"
                        select="exsl:node-set($man.string.subst.map)/*"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * Optionally, apply a character map to replace Unicode -->
    <!-- * symbols and special characters. -->
    <xsl:choose>
      <xsl:when test="$man.charmap.enabled != 0">
        <xsl:call-template name="apply-character-map">
          <xsl:with-param name="content" select="$adjusted.content"/>
          <xsl:with-param name="map.contents"
                          select="exsl:node-set($man.charmap.contents)/*"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * if we reach here, value of $man.charmap.enabled is zero, -->
        <!-- * so we just pass the adjusted contents through "as is" -->
        <xsl:value-of select="$adjusted.content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  
  <xsl:template name="write.man.file">
    <xsl:param name="name"/>
    <xsl:param name="section"/>
    <xsl:param name="content"/>
    <xsl:param name="filename">
      <xsl:call-template name="make.adjusted.man.filename">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="section" select="$section"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="quiet" select="$man.output.quietly"/>
      <xsl:with-param name="encoding" select="$man.output.encoding"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- * A "stub" is sort of alias for another file, intended to be read -->
  <!-- * and expanded by soelim(1); it's simply a file whose complete -->
  <!-- * contents are just a single line of the following form: -->
  <!-- * -->
  <!-- *  .so manX/realname.X -->
  <!-- * -->
  <!-- * "realname" is a name of another man-page file. That .so line is -->
  <!-- * basically a roff "include" statement.  When the man command finds -->
  <!-- * it, it calls soelim(1) and includes and displays the contents of -->
  <!-- * the manX/realqname.X file. -->
  <!-- * -->
  <!-- * If a refentry has multiple refnames, we generate a "stub" page for -->
  <!-- * each refname found, except for the first one. -->
  <xsl:template name="write.stubs">
    <xsl:param name="first.refname"/>
    <xsl:param name="section"/>
    <xsl:for-each select="refnamediv/refname">
      <xsl:if test=". != $first.refname">
        <xsl:call-template name="write.text.chunk">
          <xsl:with-param name="filename">
            <xsl:call-template name="make.adjusted.man.filename">
              <xsl:with-param name="name">
                <xsl:apply-templates/>
              </xsl:with-param>
              <xsl:with-param name="section" select="$section"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="quiet" select="$man.output.quietly"/>
          <xsl:with-param name="content">
            <xsl:value-of select="concat('.so man', $section, '/')"/>
            <xsl:call-template name="make.adjusted.man.filename">
              <xsl:with-param name="name" select="$first.refname"/>
              <xsl:with-param name="section" select="$section"/>
            </xsl:call-template>
            <xsl:text>&#10;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- *  A manifest file is useful for doing “make clean” during -->
  <!-- *  builds and for other purposes. When we make the manifest -->
  <!-- *  file, we need to include in it a filename for each man-page -->
  <!-- *  generated, including any “stub” pages. -->
  <xsl:template name="generate.manifest">
    <xsl:param name="filename">MAN.MANIFEST</xsl:param>
    <xsl:variable name="filelist">
      <xsl:for-each select="//refentry">
        <!-- * all refname instances in a Refentry inherit their section -->
        <!-- * numbers from the parent Refentry; so we only need to get -->
        <!-- * the section once per Refentry, not once per Refname -->
        <xsl:variable name="section">
          <xsl:call-template name="get.refentry.section"/>
        </xsl:variable>
        <xsl:for-each select="refnamediv/refname">
          <xsl:call-template name="make.adjusted.man.filename">
            <xsl:with-param name="name" select="."/>
            <xsl:with-param name="section" select="$section"/>
          </xsl:call-template>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <!-- * we write the manifest file once per document, not once per -->
    <!-- * Refentry -->
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$man.manifest.filename"/>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="$man.output.quietly"/>
      <xsl:with-param name="content">
        <xsl:value-of select="$filelist"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
