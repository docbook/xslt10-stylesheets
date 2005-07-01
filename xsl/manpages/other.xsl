<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * This file contains named templates that are related to things -->
<!-- * other than just generating the actual text of the main text flow -->
<!-- * of each man page. This "other" stuff currently amounts to: -->
<!-- * -->
<!-- *  - adding a comment to top part of roff source of each page -->
<!-- *  - making a .TH title line (for controlling page header/footer) -->
<!-- *  - setting hyphenation, alignment, & line-breaking defaults -->
<!-- *  - writing any related "stub" pages -->

<!-- ==================================================================== -->

  <xsl:template name="top.comment">
    <xsl:text>.\" ** You probably do not want to</xsl:text>
    <xsl:text> edit this file directly **&#10;</xsl:text>
    <xsl:text>.\" It was generated using the DocBook</xsl:text>
    <xsl:text> XSL Stylesheets (version </xsl:text>
    <xsl:value-of select="$VERSION"/>
    <xsl:text>).&#10;</xsl:text>
    <xsl:text>.\" Instead of manually editing it, you</xsl:text>
    <xsl:text> probably should edit the DocBook XML&#10;</xsl:text>
    <xsl:text>.\" source for it and then use the DocBook</xsl:text>
    <xsl:text> XSL Stylesheets to regenerate it.&#10;</xsl:text>
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
        <!-- * truncate title if it exceeds max. length (user-configurable) -->
        <xsl:value-of
            select="normalize-space(substring($title, 1, $man.th.title.max.length))"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($section)"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($extra1)"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($extra2)"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($extra3)"/>
    <xsl:text>"&#10;</xsl:text>
    <xsl:call-template name="mark.subheading"/>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template name="set.default.formatting">
    <!-- * Set default hyphenation, justification, and line-breaking -->
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
    <!-- * Unless the value of man.break.after.slash is zero (the -->
    <!-- * default), tell groff that it is OK to break a line -->
    <!-- * after a slash when needed. -->
    <xsl:if test="$man.break.after.slash != 0">
      <xsl:text>.\" enable line breaks after slashes&#10;</xsl:text>
      <xsl:text>.cflags 4 /&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- * A "stub" is sort of alias for another file, intended to be read -->
  <!-- * and expanded by soelim(1); it's simply a file whose complete -->
  <!-- * contents are just a single line of the following form: -->
  <!-- * -->
  <!-- *  .so manX/realname.X -->
  <!-- * -->
  <!-- * "realname" is a name of another man-page file. That .so line is -->
  <!-- * basically a *roff "include" statement.  When the man command finds -->
  <!-- * it, it calls soelim(1) (I think) and includes and displays the -->
  <!-- * contents of the manX/realqname.X file. -->
  <!-- * -->
  <!-- * If a refentry has multiple refnames, we generate a "stub" page for -->
  <!-- * each additional refname found. -->
  <xsl:template name="write.stubs">
    <xsl:param name="metadata"/>
    <xsl:for-each select="refnamediv/refname">
      <xsl:if test=". != $metadata/name">
        <xsl:call-template name="write.text.chunk">
          <xsl:with-param name="filename"
                          select="concat(normalize-space(.), '.',
                                  $metadata/section)"/>
          <xsl:with-param name="quiet" select="$man.output.quietly"/>
          <xsl:with-param
              name="content"
              select="concat('.so man', $metadata/section, '/',
                      $metadata/name, '.', $metadata/section, '&#10;')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
