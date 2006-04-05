<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:sf="http://sourceforge.net/"
                xmlns:cvs="http://www.red-bean.com/xmlns/cvs2cl/"
                exclude-result-prefixes="exsl sf cvs"
                version='1.0'>
  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://docbook.sf.net/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- * the modified-markup.xsl file is a slightly modified version -->
  <!-- * of Jeni Tennison's "Markup Utility" stylesheet -->
  <!-- * -->
  <!-- *   http://www.jenitennison.com/xslt/utilities/markup.html -->
  <!-- * -->
  <xsl:import href="../contrib/tools/tennison/modified-markup.xsl" />
  <xsl:include href="../xsl/lib/lib.xsl" />

  <!-- * file containing DocBook XSL stylesheet param names -->
  <xsl:param name="param.file"/>

  <!-- * file containing DocBook element names-->
  <xsl:param name="element.file"/>

  <!-- * comma-separated list of terms that should not be -->
  <!-- * automatically marked up -->
  <xsl:param 
      name="stopwords"
      >code,example,markup,note,option,optional,part,parameter,set,step,type,warning</xsl:param>

  <!-- ==================================================================== -->

  <!-- * This stylesheet converts XML-formatted ChangeLog output of the -->
  <!-- * cvs2cl command into DocBook form. -->
  <!-- * -->
  <!-- *   http://www.red-bean.com/cvs2cl/ -->
  <!-- * -->
  <!-- * Features :-->
  <!-- * -->
  <!-- * - groups commit messages by subdirectory name and generates -->
  <!-- *   a Sect2 wrapper around each group (for example, all commit -->
  <!-- *   messages for the "lib" subdirectory get grouped together -->
  <!-- *   into a "Lib" Sect2 section) -->
  <!-- * -->
  <!-- * - within each Sect2 section, generates an Itemizedlist, one -->
  <!-- *   Listitem for each commit message -->
  <!-- * -->
  <!-- * - uses Jeni Tennison's "Markup Utility" stylesheet to -->
  <!-- *   recognize special terms and mark them up; specifically, it -->
  <!-- *   looks for DocBook element names in commit messages and marks -->
  <!-- *   them up with <tag>foo</tag> instances, and looks for DocBook -->
  <!-- *   XSL stylesheet param names, and marks them up with -->
  <!-- *   <parameter>hoge.moge.baz</parameter> instances -->
  <!-- * -->
  <!-- * - preserves newlines (by converting them to <sbr/> instances) -->
  <!-- * -->
  <!-- * - converts cvs usernames to corresponding users' real names -->
  <!-- * -->

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
      <sf:firstname>Steve</sf:firstname>
      <sf:surname>Ball</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>bobstayton</sf:username>
      <sf:firstname>Robert</sf:firstname>
      <sf:surname>Stayton</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>dcramer</sf:username>
      <sf:firstname>David</sf:firstname>
      <sf:surname>Cramer</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>kosek</sf:username>
      <sf:firstname>Jirka</sf:firstname>
      <sf:surname>Kosek</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>nwalsh</sf:username>
      <sf:firstname>Norman</sf:firstname>
      <sf:surname>Walsh</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>xmldoc</sf:username>
      <sf:firstname>Michael(tm)</sf:firstname>
      <sf:surname>Smith</sf:surname>
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
        <title>Release: <xsl:value-of select="$release-version"/></title>
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
      select="$release-version"/></xsl:comment>
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
      <!-- * each Lisitem corresponds to a single commit -->
      <listitem>
        <xsl:text>&#xa;</xsl:text>
        <!-- * for each entry (commit), get the commit message. Also -->
        <!-- * get the filename(s) + revision(s) and username, and -->
        <!-- * put it into an Alt element, which will become a Title -->
        <!-- * element in HTML output, generating "tooltip text"-->
        <para>
          <phrase role="commit-message">
            <xsl:apply-templates
                select="cvs:msg"/>
            <alt>
              <xsl:for-each select="cvs:file">
                <xsl:apply-templates select="."/>
                <xsl:if test="not(position() = last())">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </xsl:for-each>
              <xsl:text> - </xsl:text>
              <xsl:apply-templates select="cvs:author"/>
            </alt>
          </phrase>
        </para>
        <xsl:text>&#xa;</xsl:text>
      </listitem>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="cvs:msg">
    <!-- * trim off any leading and trailing whitespace from this -->
    <!-- * commit message -->
    <xsl:variable name="trimmed">
      <xsl:call-template name="trim.text">
        <xsl:with-param name="contents" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="trimmed-contents" select="exsl:node-set($trimmed)"/>
    <!-- * mask any periods in the contents -->
    <xsl:variable name="masked-contents">
      <xsl:apply-templates mode="mask.period" select="$trimmed-contents"/>
    </xsl:variable>
    <!-- * merk up the elements and params in the masked contents -->
    <xsl:variable name="marked.up.contents">
      <xsl:call-template name="markup">
        <xsl:with-param name="text" select="$masked-contents" />
        <xsl:with-param
            name="phrases"
            select="document($element.file)//member|
                    document($param.file)//member"
            />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="marked.up" select="exsl:node-set($marked.up.contents)"/>
    <!-- * return the marked-up contents, unmasked -->
      <xsl:apply-templates select="$marked.up" mode="restore.period"/>
  </xsl:template>

  <!-- * template for matching DocBook element names -->
  <xsl:template match="*[parent::*[@role = 'element']]" mode="markup">
    <xsl:param name="word" />
    <xsl:param
        name="lowercased-word"
        select="translate($word,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
       <!-- * adjust the value of $stopwords by removing all whitepace -->
       <!-- * from it and adding a comma to the beginning and end of it -->
    <xsl:param
        name="adjusted-stopwords"
        select="concat(',',translate($stopwords,'&#9;&#10;&#13;&#32;',''),',')"/>
    <xsl:choose>
      <!-- * if $word is 'foo', generate a <tag>foo</tag> instance unless -->
      <!-- * ',foo,' is found in the adjustedlist of stopwords. -->
      <xsl:when
          test="not(contains($adjusted-stopwords,concat(',',$lowercased-word,',')))">
        <tag><xsl:value-of select="$word" /></tag>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$word"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- * template for matching DocBook XSL stylesheet param names -->
  <xsl:template match="*[parent::*[@role = 'param']]" mode="markup">
    <xsl:param name="word" />
    <parameter><xsl:value-of select="$word" /></parameter>
  </xsl:template>

  <xsl:template match="cvs:file">
    <xsl:value-of
    select="cvs:name"/><xsl:text>#</xsl:text><xsl:value-of
    select="cvs:revision"/>
  </xsl:template>

  <xsl:template match="cvs:author">
    <xsl:variable name="username" select="."/>
    <!-- * based on Sourceforge cvs username, get a real name and use -->
    <!-- * that in the result document, instead of the username -->
      <xsl:value-of
      select="document('')//sf:users/sf:user[sf:username = $username]/sf:firstname"/>
      <xsl:text> </xsl:text>
      <xsl:value-of
      select="document('')//sf:users/sf:user[sf:username = $username]/sf:surname"/>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Kludges for dealing with dots in/after names                -->
  <!-- * ============================================================== -->

  <!-- * The mask.period and restore.period kludges are an attempt to -->
  <!-- * deal with the need to make sure that parameters names that -->
  <!-- * contain element names get marked up correctly -->

  <!-- * The following mode "masks" periods by converting them to houses -->
  <!-- * (that is, Unicode character x2302). It masks periods that are -->
  <!-- * followed by a space or newline, or any period that is the last -->
  <!-- * character in the given text node. -->
  <xsl:template match="text()" mode="mask.period">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="target">.&#xa;</xsl:with-param>
      <xsl:with-param name="replacement">;&#x2302;&#xa;</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:call-template name="string.subst">
          <xsl:with-param name="target">. </xsl:with-param>
          <xsl:with-param name="replacement">;&#x2302; </xsl:with-param>
          <xsl:with-param name="string">
              <xsl:choose>
                <xsl:when test="substring(., string-length(.)) = '.'">
                  <xsl:value-of
                      select="concat(substring(.,1,string-length(.) - 1),';&#x2302;')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- * unwind results of mask.period - and, as a bonus, convert all -->
  <!-- * newlines characters to instances of a"linebreak element" -->
  <xsl:template match="text()" mode="restore.period">
    <xsl:call-template name="newlines.to.linebreak.element">
      <xsl:with-param name="string">
        <xsl:call-template name="string.subst">
          <xsl:with-param name="string" select="."/>
          <xsl:with-param name="target">;&#x2302;</xsl:with-param>
          <xsl:with-param name="replacement">.</xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*" mode="restore.period">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Utility template for preserving linebreaks in output        -->
  <!-- * ============================================================== -->
  <xsl:template name="newlines.to.linebreak.element">
    <xsl:param name="string"/>
    <xsl:param name="linebreak.element"><sbr /></xsl:param>
    <xsl:choose>
      <xsl:when test="contains($string, '&#xA;')">
        <xsl:value-of select="substring-before($string, '&#xA;')" />
        <xsl:copy-of select="$linebreak.element" />
        <xsl:call-template name="newlines.to.linebreak.element">
          <xsl:with-param name="string"
                          select="substring-after($string, '&#xA;')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

