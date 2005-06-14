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
  <xsl:include href="other.xsl"/>
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="block.xsl"/>
  <xsl:include href="inline.xsl"/>
  <xsl:include href="synop.xsl"/>
  <xsl:include href="lists.xsl"/>

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

    <!-- * Assemble the various parts into a complete page, then store into -->
    <!-- * $page.contents so that we can manipluate further. -->
    <xsl:variable name="page.contents">
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
        <xsl:with-param name="title"   select="$metadata/title"/>
        <xsl:with-param name="section" select="$metadata/section"/>
        <xsl:with-param name="extra1"  select="$metadata/date"/>
        <xsl:with-param name="extra2"  select="$metadata/versionorname"/>
        <xsl:with-param name="extra3"  select="$metadata/othermetadata"/>
      </xsl:call-template>
      <!-- * main body of man page -->
      <xsl:apply-templates/>
      <!-- * AUTHOR section (at end of man page) -->
      <xsl:call-template name="author.section">
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="parentinfo" select="$parentinfo"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * Prepare the page contents for final output, then store in -->
    <!-- * $page.contents.prepared so the we can pass it on to the -->
    <!-- * write.text.chunk() function -->
    <xsl:variable name="page.contents.prepared">
      <!-- * "Preparing" the page contents involves, at a minimum, -->
      <!-- * converting our internal @dot@, @esc & @dash@ pseudo-markup -->
      <!-- * into real roff; that is: literal . and \ and - characters. -->
      <!-- * -->
      <!-- * If $charmap.enabled is true, "preparing" the page contents also -->
      <!-- * involves applying a character map to convert Unicode symbols and -->
      <!-- * special characters into corresponding roff escape sequences. -->
      <xsl:call-template name="prepare.page.contents">
        <xsl:with-param name="content" select="$page.contents"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-- * At last: Write the prepared page contents to disk to create -->
    <!-- * the final man page. -->
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$metadata/filename"/>
      <xsl:with-param name="content" select="$page.contents.prepared"/>
    </xsl:call-template>

    <!-- * Finish up by generating "stub" (alias) pages (if any needed) -->
    <xsl:call-template name="write.stubs">
      <xsl:with-param name="metadata" select="$metadata"/>
    </xsl:call-template>

  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template match="refmeta"></xsl:template>
  <xsl:template match="title"></xsl:template>
  <xsl:template match="abstract"></xsl:template>

</xsl:stylesheet>
