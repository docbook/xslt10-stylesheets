<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sf="http://sourceforge.net/"
                xmlns:cvs="http://www.red-bean.com/xmlns/cvs2cl/"
                exclude-result-prefixes="sf cvs"
                version='1.0'>
  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://docbook.sf.net/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- * This file auto-generates release-notes documentation from -->
  <!-- * XML-formatted ChangeLog output of the cvs2cl command -->
  <!-- *   http://www.red-bean.com/cvs2cl/ -->

  <xsl:param name="release-version"/>
  <xsl:param name="release-version-ncname">
    <xsl:text>V</xsl:text>
    <xsl:value-of select="translate($release-version, '.', '')"/>
  </xsl:param>
  <xsl:param name="latest-tag">VXXXX</xsl:param>
  <!-- * We get the value of $previous-release by chopping up the latest -->
  <!-- * tag, then putting it back together. With dots. -->
  <xsl:param name="previous-release">
    <xsl:value-of select="
      concat(
      substring($latest-tag, 2, 1),
      '.',
      substring($latest-tag, 3, 2),
      '.',
      substring($latest-tag, 5, 1)
      )"/>
  </xsl:param>

  <xsl:strip-space elements="changelog entry"/>

  <!-- * $subsections holds a "display name" for each subsection to -->
  <!-- * include in the release notes. The lowercase versions of these -->
  <!-- * display names correspond to the real subdirectories whose -->
  <!-- * changes we to include. So if you want to include a new -->
  <!-- * subdirectory and have its changes documented in the release -->
  <!-- * notes, then just add a "display name" for the subdirectory -->
  <xsl:param
      name="subsections"
      >Common Extensions FO HTML HTMLHelp Lib Manpages Params Profiling Template WordML</xsl:param>

  <sf:users>
    <!-- * The sf:users structure associates Sourceforge usernames -->
    <!-- * with the real names of the people they correspond to -->
    <sf:user>
      <sf:username>balls</sf:username>
      <sf:realname>Steve&#xA0;Ball</sf:realname>
    </sf:user>
    <sf:user>
      <sf:username>bobstayton</sf:username>
      <sf:realname>Robert&#xA0;Stayton</sf:realname>
    </sf:user>
    <sf:user>
      <sf:username>dcramer</sf:username>
      <sf:realname>David&#xA0;Cramer</sf:realname>
    </sf:user>
    <sf:user>
      <sf:username>kosek</sf:username>
      <sf:realname>Jirka&#xA0;Kosek</sf:realname>
    </sf:user>
    <sf:user>
      <sf:username>nwalsh</sf:username>
      <sf:realname>Norman&#xA0;Walsh</sf:realname>
    </sf:user>
    <sf:user>
      <sf:username>xmldoc</sf:username>
      <sf:realname>Michael(tm)&#xA0;Smith</sf:realname>
    </sf:user>
  </sf:users>

  <xsl:template match="cvs:changelog">
    <article>
      <xsl:text>&#xa;</xsl:text>
      <title
          >Changes since the <xsl:value-of
          select="$previous-release"/> release</title>
      <xsl:text>&#xa;</xsl:text> 
      <sect1>
        <xsl:attribute
            name="xml:id"><xsl:value-of
            select="$release-version-ncname"/></xsl:attribute>
        <xsl:text>&#xa;</xsl:text>
        <title>Release: <xsl:value-of select="$release-version-ncname"/></title>
        <xsl:text>&#xa;</xsl:text>
        <para>The following is a list of changes that have been made
        since the <xsl:value-of select="$previous-release"/> release.</para>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="format.subsection">
          <!-- * Split the space-separated $subsections list into two parts: -->
          <!-- * the part before the first space (the first -->
          <!-- * subsection/dirname in the list), and the part after (the -->
          <!-- * other subsections/dirnames) -->
          <xsl:with-param
              name="subsection"
              select="normalize-space(substring-before($subsections, ' '))"/>
          <xsl:with-param
              name="remaining-subsections"
              select="concat(normalize-space(substring-after($subsections, ' ')),' ')"/>
        </xsl:call-template>
      </sect1>
      <xsl:text>&#xa;</xsl:text>
    </article>
  </xsl:template>

  <xsl:template name="format.subsection">
    <!-- * This template generates DocBook-marked-up output for each -->
    <!-- * subsection in the $subsections list. It does so by tail- -->
    <!-- * recursing through space-separated values in the $subsection -->
    <!-- * param, popping them off until it depletes the list. -->
    <xsl:param name="subsection"/>
    <xsl:param name="remaining-subsections"/>
      <!-- * dirname is a lowercase version of the "display name" for -->
      <!-- * each subsection -->
    <xsl:param name="dirname"
               select="translate($subsection,
                       'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                       'abcdefghijklmnopqrstuvwxyz')"/>
    <!-- * if $subsection is empty it means we have walked through -->
    <!-- * the entire list and depleted it; so that's the point at which -->
    <!-- * the template stops recursing and returns -->
    <xsl:if test="not($subsection = '')">
      <sect2>
        <!-- * the ID on each Sect2 is the release version plus the -->
        <!-- * subsection name; for example, xml:id="snapshost_FO" -->
        <xsl:attribute
            name="xml:id"><xsl:value-of
            select="$release-version-ncname"/>_<xsl:value-of select="$subsection"/></xsl:attribute>
        <xsl:text>&#xa;</xsl:text>
        <title><xsl:attribute
            name="xml:id"><xsl:value-of
            select="$release-version-ncname"/>_<xsl:value-of
            select="$subsection"/>_title</xsl:attribute><xsl:value-of
            select="$subsection"/></title>
        <xsl:text>&#xa;</xsl:text>
        <para>The following changes have been made to the
        <filename><xsl:value-of select="$dirname"/></filename> code
        since the <xsl:value-of select="$previous-release"/> release.</para>
        <xsl:text>&#xa;</xsl:text>
        <!-- * We put the commit descriptions into an Itemizedlist, one -->
        <!-- * Item for each commit -->
        <itemizedlist>
          <xsl:text>&#xa;</xsl:text>
          <xsl:call-template name="format.entries">
            <xsl:with-param name="dirname" select="$dirname"/>
          </xsl:call-template>
          <xsl:text>&#xa;</xsl:text>
        </itemizedlist>
        <xsl:text>&#xa;</xsl:text>
      </sect2>
      <!-- * for example, "end of FO changes for V1691" -->
      <xsl:comment>end of <xsl:value-of
      select="$subsection"/> changes for <xsl:value-of
      select="$release-version-ncname"/></xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:call-template name="format.subsection">
        <!-- * pop the name of the next subsection off the list of -->
        <!-- * remaining subsections -->
        <xsl:with-param
            name="subsection"
            select="substring-before($remaining-subsections, ' ')"/>
        <!-- * remove the current subsection from the list of -->
        <!-- * remaining subsections -->
        <xsl:with-param
            name="remaining-subsections"
            select="substring-after($remaining-subsections, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="format.entries">
    <xsl:param name="dirname"/>
    <xsl:for-each select="cvs:entry[cvs:file/cvs:name[starts-with(.,concat($dirname,'/'))]]">
      
      <!-- * each Listem corresponds to a single commit -->
      <listitem>
        <xsl:text>&#xa;</xsl:text>
        <!-- * for each entry (commit), get just the commit message and -->
        <!-- * username. Put the name of the committor in square brackets -->
        <!-- * at the end of the commit description -->
        <para><xsl:apply-templates
        select="cvs:msg"/> [<xsl:apply-templates select="cvs:author"/>]</para>
        <xsl:text>&#xa;</xsl:text>
      </listitem>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="cvs:msg">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="cvs:author">
    <xsl:variable name="username" select="."/>
    <!-- * based on Sourceforge cvs username, get a real name and use -->
    <!-- * that in the result document, instead of the username -->
    <xsl:value-of select="document('')//sf:users/sf:user[sf:username = $username]/sf:realname"/>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
