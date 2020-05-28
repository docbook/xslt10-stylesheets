<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:sf="http://sourceforge.net/"
                exclude-result-prefixes="exsl sf"
                version='1.0'>
  <!-- ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or https://cdn.docbook.org/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- * The modified-markup.xsl file is a slightly modified version -->
  <!-- * of Jeni Tennison's "Markup Utility" stylesheet -->
  <!-- * -->
  <!-- *   http://www.jenitennison.com/xslt/utilities/markup.html -->
  <!-- * -->
  <xsl:import href="./modified-markup.xsl" />
  <xsl:include href="../xsl/lib/lib.xsl" />

  <!-- * name of main distro this changelog is for-->
  <xsl:param name="distro">xsl</xsl:param>

  <!-- * file containing DocBook XSL stylesheet param names -->
  <xsl:param name="param.file"/>

  <!-- * file containing DocBook element names-->
  <xsl:param name="element.file"/>

  <!-- * comma-separated list of terms that should not be -->
  <!-- * automatically marked up -->
  <xsl:param 
      name="stopwords"
      >code,example,markup,note,option,optional,org,package,part,parameter,property,see,set,step,type,uri,warning</xsl:param>

  <!-- ==================================================================== -->

  <!-- * This stylesheet converts XML-formatted ChangeLog output of the -->
  <!-- * "svn log" command into DocBook form. -->
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
  <!-- * - converts usernames to corresponding users' real names -->
  <!-- * -->

  <xsl:param name="release-version"/>
  <xsl:param name="previous-release"/>

  <!-- * a subsection can actually be either subsection of the distro or -->
  <!-- * a sibling of the distro (whatever you want to include in the -->
  <!-- * DocBook version of the changelog). -->
  <!-- * $subsections holds a "display name" for each subsection to -->
  <!-- * include in DocBookified changelog. The lowercase versions of -->
  <!-- * these display names correspond to the real subdirectories or -->
  <!-- * sibling directories whose changes we want to include. So if you want -->
  <!-- * to include a new subdirectory or sibling directory and have its -->
  <!-- * changes documented in the output, then just add a "display name" -->
  <!-- * for the subdirectory or sibling directory. -->
  <xsl:param
      name="subsections"
      >Gentext Common FO HTML Manpages Epub HTMLHelp Eclipse JavaHelp Roundtrip Slides Website Webhelp Params Highlighting Profiling Lib Tools Template Extensions XSL-Java XSL-Saxon XSL-Xalan XSL-libxslt</xsl:param>
  <sf:users>
    <!-- * The sf:users structure associates Sourceforge usernames -->
    <!-- * with the real names of the people they correspond to -->
    <sf:user>
      <sf:username>paulnorton</sf:username>
      <sf:firstname>Paul</sf:firstname>
      <sf:surname>Norton</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>abdelazer</sf:username>
      <sf:firstname>Keith</sf:firstname>
      <sf:surname>Fahlgren</sf:surname>
    </sf:user>
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
      <sf:username>dongsheng</sf:username>
      <sf:firstname>Dongsheng</sf:firstname>
      <sf:surname>Song</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>dcramer</sf:username>
      <sf:firstname>David</sf:firstname>
      <sf:surname>Cramer</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>dpawson</sf:username>
      <sf:firstname>Dave</sf:firstname>
      <sf:surname>Pawson</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>kosek</sf:username>
      <sf:firstname>Jirka</sf:firstname>
      <sf:surname>Kosek</sf:surname>
    </sf:user>
    <sf:user>
      <sf:username>mzjn</sf:username>
      <sf:firstname>Mauritz</sf:firstname>
      <sf:surname>Jeanson</sf:surname>
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

  <xsl:template match="log">
    <xsl:text>&#xa;</xsl:text>
    <article>
      <xsl:text>&#xa;</xsl:text>
        <info>
        <xsl:text>&#xa;</xsl:text>
        <abstract>
          <xsl:text>&#xa;</xsl:text>
          <para><emphasis role="strong">Note:</emphasis> This
            document lists changes only since the <xsl:value-of
              select="$previous-release"/> release.
	  </para>
        </abstract>
        <xsl:text>&#xa;</xsl:text>
      </info>
      <title
          >Changes since the <xsl:value-of
          select="$previous-release"/> release</title>
      <xsl:text>&#xa;</xsl:text> 
      <xsl:text>&#xa;</xsl:text>
      <sect1>
        <xsl:attribute
            name="xml:id">V<xsl:value-of
            select="$release-version"/></xsl:attribute>
        <xsl:text>&#xa;</xsl:text>
        <title>Release Notes: <xsl:value-of select="$release-version"/></title>
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
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template name="format.subsection">
    <!-- * This template generates DocBook-marked-up output for each -->
    <!-- * subsection in the $subsections list. It does so by tail- -->
    <!-- * recursing through space-separated values in the $subsection -->
    <!-- * param, popping them off until it depletes the list. -->
    <xsl:param name="subsection"/>
    <xsl:param name="remaining-subsections"/>
    <!-- * dirname is a lowercase version of the "display name" for -->
    <!-- * each subsection of the distro or sibling of the distro -->
    <xsl:param name="dirname"
               select="translate($subsection,
                       'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                       'abcdefghijklmnopqrstuvwxyz')"/>
    <!-- * if $subsection is empty it means we have walked through -->
    <!-- * the entire list and depleted it; so that's the point at which -->
    <!-- * the template stops recursing and returns -->
    <xsl:if test="not($subsection = '')">
      <!-- * Output a sect2 for this subsection only if with find path names -->
      <!-- * for changed files in the $dirname subsection of the distro -->
      <!-- * OR in the $dirname sibling of the distro -->
      <xsl:if test="logentry[paths/path[
        starts-with(.,concat($distro,'/',$dirname,'/'))
        or starts-with(.,concat($dirname,'/'))]]
        ">
        <sect2>
          <!-- * the ID on each Sect2 is the release version plus the -->
          <!-- * subsection name; for example, xml:id="snapshost_FO" -->
          <xsl:attribute
            name="xml:id">V<xsl:value-of
              select="$release-version"/>_<xsl:value-of select="$subsection"/></xsl:attribute>
          <xsl:text>&#xa;</xsl:text>
          <title><xsl:value-of select="$subsection"/></title>
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
          </itemizedlist>
          <xsl:text>&#xa;</xsl:text>
        </sect2>
        <!-- * for example, "end of FO changes for V1691" -->
        <xsl:comment>end of <xsl:value-of
        select="$subsection"/> changes for <xsl:value-of
        select="$release-version"/></xsl:comment>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
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
    <!-- * to through the "svn log" output to check for each $dirname -->
    <!-- * subsection of the distro or $dirname sibling of the distro -->
    <xsl:for-each
      select="
      logentry[paths/path[
      starts-with(.,concat($distro,'/',$dirname,'/'))
      or starts-with(.,concat($dirname,'/'))]]
      ">
      <!-- * each Lisitem corresponds to a single commit -->
      <listitem>
        <xsl:text>&#xa;</xsl:text>
        <!-- * for each entry (commit), get the author, then the list of -->
        <!-- * changed files, then the actual commit message -->
        <para>
          <literal>
            <!-- * commitmetadata = author+filelist -->
            <xsl:variable name="commitmetadata">
              <xsl:apply-templates select="author"/>
              <xsl:text>: </xsl:text>
              <!-- * Only get path names for files that are in the subsection -->
              <!-- * that we are currently formatting -->
              <xsl:for-each select="
                paths/path[
                starts-with(.,concat($distro,'/',$dirname,'/'))
                or starts-with(.,concat($dirname,'/'))]
                ">
                <!-- * for each changed file we list, we don't want to show -->
                <!-- * its whole repository path back to the repository -->
                <!-- * root; instead we just want the basename of the file -->
                <xsl:variable name="pathprefix">
                  <xsl:choose>
                    <!-- * first case, changed file is in a subdir of distro -->
                    <xsl:when test="contains(.,(concat($dirname,'/')))">
                      <xsl:value-of select="concat($dirname,'/')"/>
                    </xsl:when>
                    <!-- * other case, changed file is in a sibling dir of distro -->
                    <xsl:otherwise>
                      <xsl:value-of select="concat($distro,'/',$dirname,'/')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- * call string-replacement template to strip off the -->
                <!-- * pathname and just give us the base filename -->
                <xsl:call-template name="string.subst">
                  <xsl:with-param name="string" select="."/>
                  <xsl:with-param name="target" select="$pathprefix"/>
                  <xsl:with-param name="replacement" select="''"/>
                </xsl:call-template>
                <xsl:if test="not(position() = last())">
                  <xsl:text>; </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
              <!-- * if we have a long file list (more that will fit on -->
              <!-- * one line on a printed page, we just truncate it and -->
              <!-- * append some ellipses -->
              <xsl:when test="string-length($commitmetadata) > 90">
                <xsl:value-of select="substring($commitmetadata,1,90)"/>
                <xsl:text>⋯</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <!-- * otherwise, we have a short file list, so use it as-is -->
                <xsl:value-of select="$commitmetadata"/>
              </xsl:otherwise>
            </xsl:choose>
          </literal>
        </para>
        <screen><phrase role="commit-message">
            <xsl:apply-templates select="msg"/>
        </phrase></screen>
        <xsl:text>&#xa;</xsl:text>
      </listitem>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="msg">
    <!-- * trim off any leading and trailing whitespace from this -->
    <!-- * commit message -->
    <xsl:variable name="trimmed">
      <xsl:choose>
        <xsl:when test="parent::logentry[@revision='6226']">
          <!-- * hack to workaround a dumb mistake I made on r6226; ..Mike -->
          <xsl:text
              >Added namespace declarations to document elements for all param files.</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="trim.text">
            <xsl:with-param name="contents" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
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

  <xsl:template match="author">
    <!-- * based on Sourceforge cvs username, get a real name (if one has been defined) 
	 * and use that in the result document, instead of the username -->
    <xsl:variable name="username" select="."/>
    <xsl:variable name="users" select="document('')//sf:users"/>
    <xsl:variable name="realname" select="concat($users/sf:user[sf:username = $username]/sf:firstname, 
					  ' ',
					  $users/sf:user[sf:username = $username]/sf:surname)"/>
    
    <xsl:choose>
      <xsl:when test="string-length($realname) > 1">
	<xsl:value-of select="$realname"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$username"/>
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="."/>
      <xsl:with-param name="target">;&#x2302;</xsl:with-param>
      <xsl:with-param name="replacement">.</xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="*" mode="restore.period">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
