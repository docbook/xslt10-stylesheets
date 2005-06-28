<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

  <xsl:import href="../html/docbook.xsl"/>

  <xsl:output method="text"
              encoding="UTF-8"
              indent="no"/>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

  <xsl:include href="param.xsl"/>
  <xsl:include href="general.xsl"/>
  <xsl:include href="info.xsl"/>
  <xsl:include href="other.xsl"/>
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="block.xsl"/>
  <xsl:include href="inline.xsl"/>
  <xsl:include href="synop.xsl"/>
  <xsl:include href="lists.xsl"/>

  <!-- * Read the character-map contents in only once per document, no -->
  <!-- * matter how many Refentry elements it contains. For documents -->
  <!-- * that contain a large number or Refentry elements, this can -->
  <!-- * result in a significant performance gain over the alternative -->
  <!-- * (that is, reading it in once for every Refentry processed) -->
  <xsl:variable name="man.charmap.contents">
    <xsl:if test="$man.charmap.enabled != '0'">
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
    <!-- * each refentry and *info of its parent, we get those and store -->
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
    <!-- * $manpage.contents so that we can manipluate them further. -->
    <xsl:variable name="manpage.contents">
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * top.comment = commented-out section at top of roff source -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="top.comment"/>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * TH.title.line = title line in header/footer of man page -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
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
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * Now deal with setting default hyphenation and justification -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * -->
      <!-- * If the value of man.hypenate is zero (the default), then -->
      <!-- * disable hyphenation (".nh" means "no hyphenation", I guess) -->
      <xsl:if test="$man.hyphenate = 0">
        <xsl:text>.nh&#10;</xsl:text>
      </xsl:if>
      <!-- * If the value of man.justify is zero (the default), then -->
      <!-- * disable justification (".ad l" means "adjust to left only" -->
      <xsl:if test="$man.justify = 0">
        <xsl:text>.ad l&#10;</xsl:text>
      </xsl:if>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * Main body of man page -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:apply-templates/>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * AUTHOR section (at end of man page) -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="author.section">
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="parentinfo" select="$parentinfo"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * Prepare the page contents for final output, then store in -->
    <!-- * $manpage.contents.prepared so the we can pass it on to the -->
    <!-- * write.text.chunk() function -->
    <xsl:variable name="manpage.contents.prepared">
      <!-- * "Preparing" the page contents involves, at a minimum, -->
      <!-- * doubling any backslashes found (so they aren't interpreted -->
      <!-- * as roff escapes). -->
      <!-- * -->
      <!-- * If $charmap.enabled is true, "preparing" the page contents also -->
      <!-- * involves applying a character map to convert Unicode symbols and -->
      <!-- * special characters into corresponding roff escape sequences. -->
      <xsl:call-template name="prepare.manpage.contents">
        <xsl:with-param name="content" select="$manpage.contents"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-- * At last: Write the prepared page contents to disk to create -->
    <!-- * the final man page. -->
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$metadata/filename"/>
      <xsl:with-param name="quiet" select="$man.output.quietly"/>
      <xsl:with-param name="encoding" select="$man.output.encoding"/>
      <xsl:with-param name="content" select="$manpage.contents.prepared"/>
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
