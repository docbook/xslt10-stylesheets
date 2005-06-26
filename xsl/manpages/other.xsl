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

<!-- * This file contains named templates for generating content other than -->
<!-- * what appears in the main text flow of each man page. This "other" -->
<!-- * stuff currently amounts to: -->
<!-- * -->
<!-- *  - a commented-out section in top part of roff source of each page -->
<!-- *  - the .TH title line for controlling the page header/footer -->
<!-- *  - any related "stub" pages (which end up getting read by soelim(1) -->

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
    
    <!-- * FYI: Here is how the .TH contents show up in a rendered man page: -->
    <!-- * -->
    <!-- *   title(section)      extra3      title(section)  <- page header -->
    <!-- * -->
    <!-- *   extra2              extra1      title(section)  <- page footer-->
    <!-- * -->
    <!-- * Note the while extra1, extra2, and extra3 are all optional, almost all -->
    <!-- * pages include an "extra1", which is almost always a date. -->

    <!-- * Here are a couple of examples of real-world man pages that have -->
    <!-- * useful page headers/footers: -->
    <!-- * -->
    <!-- *   GIMP(1)           GIMP Manual Pages           GIMP(1) -->
    <!-- *   Version 2.2.6     March 23 2004               GIMP(1) -->
    <!-- * -->
    <!-- *   QT2KDOC(1)        KDOC Documentation System   QT2KDOC(1) -->
    <!-- *   2.0a54            2002-03-18                  QT2KDOC(1) -->
    <!-- * -->
    <!-- * In those examples, extra2 has version data, while extra3 has "context" -->
    <!-- * data about some larger system the documented item belongs to -->

    <xsl:param name="title"/>
    <xsl:param name="section"/>
    <xsl:param name="extra1"/>
    <xsl:param name="extra2"/>
    <xsl:param name="extra3"/>

    <!-- * FIXME: th.title.max.length needs to be made into a documented -->
    <!-- * user-configurable parameter -->
    <xsl:variable name="th.title.max.length" select="'20'"/>

    <xsl:text>.TH "</xsl:text>
    <xsl:value-of select="translate(
                          substring($title, 1, $th.title.max.length),
                          'abcdefghijklmnopqrstuvwxyz',
                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                          )"/>
    <xsl:text>" </xsl:text>
    <xsl:value-of select="$section"/>
    <xsl:text> "</xsl:text>
    <xsl:value-of select="normalize-space($extra1)"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($extra2)"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($extra3)"/>
    <xsl:text>"&#10;</xsl:text>
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
          <xsl:with-param
              name="content"
              select="concat('.so man', $metadata/section, '/',
                      $metadata/name, '.', $metadata/section, '&#10;')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
