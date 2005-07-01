<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                exclude-result-prefixes="date"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="man.th.extra2.partA.profile">
  $info/productname
  |$parentinfo/productname
  |$info/orgname
  |$parentinfo/orgname
  |$info/corpname
  |$parentinfo/corpname
  |$info/corpcredit
  |$parentinfo/corpcredit
  |$info/corpauthor
  |$parentinfo/corpauthor
  |$info/author/orgname
  |$parentinfo/author/orgname
  |$info//publishername
  |$parentinfo//publishername
</xsl:param>

<xsl:param name="man.th.extra2.partB.profile">
  refmeta/refmiscinfo[@class = 'version']
  |$info/productnumber
  |$parentinfo/productnumber
  |$info/edition
  |$parentinfo/edition
  |$info/releaseinfo
  |$parentinfo/releaseinfo
</xsl:param>

<xsl:param name="man.th.extra3.profile">
  $parentinfo/title
  |../title
</xsl:param>

  <!-- ==================================================================== -->

  <xsl:template name="get.metadata">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>

    <!-- ******************************************************************** -->
    <!-- *  -->
    <!-- * The get.metadata template returns a node-set with the elements -->
    <!-- * listed below. The descriptions for <title>, <date>, <source>, -->
    <!-- * and <manual> are all verbatim from the man(7) man page. -->
    <!-- * -->
    <!-- * -->
    <!-- * <title>         = the title of the man page (e.g., MAN) -->
    <!-- * <section>       = the section number the man page should be -->
    <!-- *                   placed in (e.g., 7) -->
    <!-- * <date>          = the date of the last revision -->
    <!-- * <source>        = the source of the command -->
    <!-- * <manual>        = the title of the manual (e.g., Linux -->
    <!-- *                   Programmer's Manual) -->
    <!-- * -->
    <!-- * <name>          = "real name" of the documented item -->
    <!-- * <filename>      = <name>.<section>; for example: xsltproc.1 -->
    <!-- * -->
    <!-- ******************************************************************** -->

    <!-- * <name> = real name of the documented item -->
    <!-- * -->    
    <!-- * in the case of a command, the <name> is what you would type in -->
    <!-- * on the command line to run it; that is, in DocBook, a <refname> -->
    <!-- * (as opposed to a <refentrytitle> or <refdescriptor>) -->
    <xsl:variable name="name" select="refnamediv[1]/refname[1]"/>
    <name>
      <xsl:value-of select="$name"/>
    </name>

    <!-- * <section> = "the section number the man page should be -->
    <!-- *             placed in (e.g., 7)" -->
    <!-- * -->    
    <!-- * if we do not find a manvolnum specified in the source, and we find -->
    <!-- * that the refentry is for a function, we use the section number "3" -->
    <!-- * ["Library calls (functions within program libraries)"]; otherwise, -->
    <!-- * we default to using "1" ["Executable programs or shell commands"] -->
    <xsl:variable name="section">
      <xsl:choose>
        <xsl:when test="refmeta/manvolnum">
          <xsl:value-of select="refmeta/manvolnum"/>
        </xsl:when>
        <xsl:when test=".//funcsynopsis">3</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <section>
      <xsl:value-of select="$section"/>
    </section>
    
    <!-- * <filename> = name.section; for example: xsltproc.1 -->
    <filename>
      <xsl:call-template name="string.subst">
        <!-- replace spaces in source filename with underscores in output filename -->
        <xsl:with-param name="string"
                        select="concat(normalize-space ($name), '.', $section)"/>
        <xsl:with-param name="target" select="' '"/>
        <xsl:with-param name="replacement" select="'_'"/>
      </xsl:call-template>
    </filename>

    <!-- * <title> = "the title of the man page (e.g., MAN)" -->
    <!-- * -->
    <!-- * This differs from <name> in that, if the refentry has a -->
    <!-- * refentrytitle, we use that as the <title>; otherwise, we -->
    <!-- * just use the <name>, which is the first refname in the -->
    <!-- * first refnamediv in the source; see above -->
    <title>
      <xsl:choose>
        <xsl:when test="refmeta/refentrytitle">
          <xsl:copy>
            <xsl:apply-templates select="refmeta/refentrytitle/node()"/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>

    <!-- * <date> = "the date of the last revision" -->
    <!-- *          If we can't find one, we add one (see below) -->
    <date>
      <xsl:variable name="Date">
        <xsl:apply-templates
            select="($info/date
                    |$info/pubdate
                    |$parentinfo/date
                    |$parentinfo/pubdate)[1]/node()"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$Date != ''">
          <xsl:value-of select="$Date"/>
        </xsl:when>
        <!-- * If we can't find a date, then we generate a date. -->
        <!-- * And we make it an appropriately localized date. -->
        <xsl:otherwise>
          <xsl:call-template name="datetime.format">
            <xsl:with-param name="date">
              <xsl:choose>
                <xsl:when test="function-available('date:date-time')">
                  <xsl:value-of select="date:date-time()"/>
                </xsl:when>
                <xsl:when test="function-available('date:dateTime')">
                  <!-- Xalan quirk -->
                  <xsl:value-of select="date:dateTime()"/>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="format">
              <xsl:call-template name="gentext.template">
                <xsl:with-param name="context" select="'datetime'"/>
                <xsl:with-param name="name" select="'format'"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </date>

    <!-- * <source> = "the source of the command" -->
    <!-- * -->
    <!-- * Here are the examples from the man(7) man page: -->
    <!-- * -->
    <!-- *   For binaries, use something like: GNU, NET-2, -->
    <!-- *   SLS Distribution, MCC Distribution. -->
    <!-- * -->
    <!-- *   For system calls, use the version of the -->
    <!-- *   kernel that you are currently looking at: -->
    <!-- *   Linux 0.99.11. -->
    <!-- * -->
    <!-- *   For library calls, use the source of the -->
    <!-- *   function: GNU, BSD 4.3, Linux DLL 4.4.1. -->
    <!-- * -->
    <!-- * So, it looks like what we have is a two-part field, -->
    <!-- * "PartA PartB", where: -->
    <!-- * -->
    <!-- *   PartA = product name (BSD) or organization name (GNU) -->
    <!-- *   PartB = version name (if PartA is a product name) -->
    <!-- * -->
    <!-- * Each part is optional. -->
    <!-- * -->
    <source>
      <!-- * by default, here we try to locate a product or -->
      <!-- * organization or publisher name -->
      <xsl:variable name="partA">
        <xsl:call-template name="find.first.profile.occurence">
          <xsl:with-param name="profile" select="$man.th.extra2.partA.profile"/>
          <xsl:with-param name="info" select="$info"/>
          <xsl:with-param name="parentinfo" select="$parentinfo"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- * by default, here we try to locate a version number -->
      <xsl:variable name="partB">
        <xsl:call-template name="find.first.profile.occurence">
          <xsl:with-param name="profile" select="$man.th.extra2.partB.profile"/>
          <xsl:with-param name="info" select="$info"/>
          <xsl:with-param name="parentinfo" select="$parentinfo"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <!-- * if we have a partA and/or partB, use either or both -->
        <!-- * of those, in the form "partA partB" or just "partA" -->
        <!-- * or just "partB" -->
        <xsl:when test="$partA != '' or $partB != ''">
          <xsl:value-of select="normalize-space(concat($partA, ' ', $partB))"/>
        </xsl:when>
        <!-- * if no partA or partB, use fallback (if any) -->
        <!-- * by default, we fall back to first Refmiscinfo found -->
        <xsl:when test="refmeta/refmiscinfo">
          <xsl:apply-templates select="refmeta/refmiscinfo[1]/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- * found nothing, so leave <source> empty -->
        </xsl:otherwise>
      </xsl:choose>
    </source>

    <!-- * <manual> = "the title of the manual (e.g., Linux -->
    <!-- *            Programmer's Manual)" -->
    <!-- * -->
    <!-- * Examples from some real-world man pages: -->
    <!-- * -->
    <!-- *   dpkg-name  -  "dpkg utilities" -->
    <!-- *   GET        -  "User Contributed Perl Documentation" -->
    <!-- *   ld         -  "GNU Development Tools" -->
    <!-- *   ddate      -  "Emperor Norton Utilities" -->
    <!-- *   dh_clean   -  "Debhelper" -->
    <!-- *   faked      -  "Debian GNU/Linux manual" -->
    <!-- *   gimp       -  "GIMP Manual Pages" -->
    <!-- *   qt2kdoc    -  "KDOC Documentation System" -->
    <!-- * -->
    <!-- * We just leave it empty if we can't find anything to use -->
    <manual>
      <xsl:variable name="Manual">
        <xsl:call-template name="find.first.profile.occurence">
          <xsl:with-param name="profile" select="$man.th.extra3.profile"/>
          <xsl:with-param name="info" select="$info"/>
          <xsl:with-param name="parentinfo" select="$parentinfo"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$Manual != ''">
          <xsl:value-of select="$Manual"/>
        </xsl:when>
        <!-- * if no Manual, use contents of specified -->
        <!-- * Fallback (if any) -->
        <xsl:when test="refmeta/refmiscinfo">
          <xsl:apply-templates select="refmeta/refmiscinfo[1]/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- * found nothing, so leave it empty -->
        </xsl:otherwise>
      </xsl:choose>
    </manual>

  </xsl:template>

  <!-- * ============================================================== -->

  <xsl:template name="author.section">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>
    <xsl:choose>
      <xsl:when test="$info//author">
        <xsl:apply-templates select="$info" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="$parentinfo//author">
        <xsl:apply-templates select="$parentinfo" mode="authorsect"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- * Match only the direct *info children of Refentry, along with -->
  <!-- * any *info for the valid direct parents of Refentry -->
  <xsl:template match="info|refentryinfo|referenceinfo
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"
                mode="authorsect">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Author'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>

    <xsl:for-each select=".//author" >
      <xsl:if test="position() > 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="." mode="authorsect"/>
    </xsl:for-each>
    <xsl:text>. &#10;</xsl:text>
    <xsl:if test=".//editor">
      <xsl:text>.br&#10;</xsl:text>
      <xsl:apply-templates select=".//editor" mode="authorsect"/>
      <xsl:text>. (man page)&#10;</xsl:text>
    </xsl:if>
    <xsl:for-each select="address">
      <xsl:text>.br&#10;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="author|editor" mode="authorsect">
    <xsl:call-template name="person.name"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select=".//email" mode="authorsect"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="email" mode="authorsect">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <!-- * ============================================================== -->

  <!-- * suppress all *info (we grab what we need from it elsewhere -->
  <xsl:template match="info|refentryinfo|referenceinfo|refsynopsisdivinfo
                       |refsectioninfo|refsect1info|refsect2info|refsect3info
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"/>

</xsl:stylesheet>
