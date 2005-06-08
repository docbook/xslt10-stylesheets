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

<!-- ==================================================================== -->

  <xsl:import href="../html/docbook.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="general.xsl"/>
  <xsl:include href="info.xsl"/>
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="block.xsl"/>
  <xsl:include href="inline.xsl"/>
  <xsl:include href="synop.xsl"/>
  <xsl:include href="lists.xsl"/>
  <xsl:include href="xref.xsl"/>

  <!-- * Needed for chunker.xsl (for now): -->
  <xsl:param name="chunker.output.method" select="'text'"/>
  <xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>

  <xsl:output method="text"
              encoding="ISO-8859-1"
              indent="no"/>

  <!-- * if document does not contain at least one refentry, then emit a -->
  <!-- * message and stop -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//refentry">
        <xsl:apply-templates select="//refentry"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>No refentry elements!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template match="refentry">

    <!-- * Because there are several times when we need to check *info of -->
    <!-- * this refentry and *info of its parent, we get those and store -->
    <!-- * as node-sets in memory. -->

    <!-- * Make a node-set with contents of *info -->
    <xsl:variable name="get.info" select="(info|refentryinfo|docinfo)[1]"/>
    <xsl:variable name="info" select="exsl:node-set($get.info)"/>
    <!-- * Make a node-set with contents of parent's *info -->
    <xsl:variable name="get.parentinfo"
                  select="(../info
                          |../referenceinfo
                          |../articleinfo
                          |../sectioninfo
                          |../appendixinfo
                          |../chapterinfo
                          |../sect1info
                          |../sect2info
                          |../sect3info
                          |../sect4info
                          |../sect5info
                          |../partinfo
                          |../prefaceinfo
                          |../docinfo)[1]"/>
    <xsl:variable name="parentinfo" select="exsl:node-set($get.parentinfo)"/>

    <!-- * The get.metadata template looks for metadata in $info and/or -->
    <!-- * $parentinfo and in various other places and then puts it into -->
    <!-- * a form that's easier for us to digest. -->
    <xsl:variable name="get.metadata">
      <xsl:call-template name="get.metadata">
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="parentinfo" select="$parentinfo"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="metadata" select="exsl:node-set($get.metadata)"/>

    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$metadata/filename"/>
      <xsl:with-param name="content">

        <!-- * top.comment = commented-out section at top of roff source -->
        <xsl:call-template name="top.comment"/>
        
        <!-- * TH.title.line = title line in header/footer of man page -->
        <xsl:call-template name="TH.title.line">

          <!-- * .TH "TITLE" "SECTION" "extra1" "extra2" "extra3" -->
          <!-- *  -->
          <!-- * extra1 = date of publication of the man page (almost universally) -->
          <!-- * extra2 = version and/or name of some kind (usually) -->
          <!-- * extra3 = context description (e.g., often a description of the -->
          <!-- *          group of related applications that the item documented -->
          <!-- *          in the man page belongs to -->
          <!-- * -->
          <!-- * .TH TITLE SECTION DATE VERSION/NAME CONTEXT -->
          <!-- * -->
          <!-- * If you want to chenge how the .TH line is constructed, change the -->
          <!-- * order/content of the values of the "select" attributes below. -->

          <xsl:with-param name="title" select="$metadata/title"/>
          <xsl:with-param name="section" select="$metadata/section"/>
          <xsl:with-param name="extra1" select="$metadata/date"/>
          <xsl:with-param name="extra2" select="$metadata/versionorname"/>
          <xsl:with-param name="extra3" select="$metadata/othermetadata"/>
        </xsl:call-template>
        
        <!-- * main body of man page -->
        <xsl:apply-templates/>

        <!-- * AUTHOR section (at end of man page) -->
        <xsl:call-template name="author.section">
          <xsl:with-param name="info" select="$info"/>
          <xsl:with-param name="parentinfo" select="$parentinfo"/>
        </xsl:call-template>
        
      </xsl:with-param>
    </xsl:call-template>

    <!-- generate "stub" pages (if any) -->
    <xsl:call-template name="write.stubs">
      <xsl:with-param name="metadata" select="$metadata"/>
    </xsl:call-template>

  </xsl:template>

  <!-- * ============================================================== -->
  <!-- * -->
  <!-- * top comment     comment part at top of roff source; unrendered -->
  <!-- * TH title line   rendererd "title" lines in header/footer of page -->
  <!-- * -->
  <!-- * ============================================================== -->

  <xsl:template name="top.comment">
    <xsl:text>.\" Generated by: DocBook XSL Stylesheets V</xsl:text>
    <xsl:value-of select="$VERSION"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"       ** Do not edit this file **&#10;</xsl:text>
    <xsl:text>.\" Instead, edit the DocBook XML source and then use the&#10;</xsl:text>
    <xsl:text>.\" DocBook XSL Stylesheets to regenerate this.&#10;</xsl:text>
  </xsl:template>

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

  <!-- A "stub" is sort of alias for another file - it's simply a file whose -->
  <!-- complete contents are just a single line of the following form: -->
  <!-- * -->
  <!-- *  .so manX/realname.X -->
  <!-- * -->
  <!-- * "realname" is a name of another man-page file. That .so line is -->
  <!-- * basically a *roff "include" statement.  When the man command finds it, -->
  <!-- * it includes and displays the contents of the manX/realqname.X file. -->
  <!-- * -->
  <!-- * If a refentry has multiple refnames, we generate a "stub" page for -->
  <!-- * additional refname found. -->

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

  <!-- ============================================================== -->

  <xsl:template match="refmeta"></xsl:template>
  <xsl:template match="title"></xsl:template>
  <xsl:template match="abstract"></xsl:template>

</xsl:stylesheet>
