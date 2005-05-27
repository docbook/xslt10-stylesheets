<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:import href="../html/docbook.xsl"/>
<xsl:include href="synop.xsl"/>
<xsl:include href="lists.xsl"/>
<xsl:include href="xref.xsl"/>

<!-- Needed for chunker.xsl (for now): -->
<xsl:param name="chunker.output.method" select="'text'"/>
<xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>

<xsl:output method="text"
            encoding="ISO-8859-1"
            indent="no"/>

<!--
  named templates for bold and italic. call like:

  <xsl:apply-templates mode="bold" select="node-you-want" />
-->
<xsl:template mode="bold" match="*">
  <xsl:for-each select="child::node()">
    <xsl:text>\fB</xsl:text>
    <xsl:apply-templates select="."/>
    <xsl:text>\fR</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template mode="italic" match="*">
  <xsl:for-each select="node()">
    <xsl:text>\fI</xsl:text>
    <xsl:apply-templates select="."/>
    <xsl:text>\fR</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="caution|important|note|tip|warning">
  <xsl:text>.RS&#10;.Sh "</xsl:text>
    <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
    <xsl:text>"&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>.RE&#10;</xsl:text>
</xsl:template> 

<xsl:template match="refsection|refsect1">
  <xsl:choose>
    <xsl:when test="ancestor::refsection">
      <xsl:text>.SS "</xsl:text>
      <xsl:value-of select="title[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.SH "</xsl:text>
      <xsl:value-of select="translate(title[1],'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>"&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect2">
  <xsl:text>.SS "</xsl:text>
  <xsl:value-of select="title[1]"/>
  <xsl:text>"&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:text>.SH "</xsl:text>
  <xsl:call-template name="string.upper">
    <xsl:with-param name="string">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>"&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="mixed-block">
  <!-- jump through a few hoops to deal with mixed-content blocks, so that -->
  <!-- we don't end up munging verbatim environments or lists and so that we -->
  <!-- don't gobble up whitespace when we shouldn't -->
  <xsl:for-each select="node()">
    <xsl:choose>
      <xsl:when test="self::address|self::literallayout|self::programlisting|
                      self::screen|self::synopsis">
        <!-- Check to see if this node is a verbatim environment. -->
        <!-- If so, put a line break before it. -->
        
        <!-- Yes, address and synopsis are vertabim environments. -->
        
        <!-- The code here previously also treated informaltable as a -->
        <!-- verbatim, presumably to support some kludge; I removed it -->
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="."/>
        <!-- we don't need an extra line break after verbatim environments
        <xsl:text> &#10;</xsl:text>
        -->
      </xsl:when>
      <xsl:when test="self::itemizedlist|self::orderedlist|
                      self::variablelist|self::simplelist[@type !='inline']">
        <!-- Check to see if this node is a list; if so, -->
        <!-- put a line break before it. -->
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="."/>
        <!-- we don't need an extra line break after lists
        <xsl:text> &#10;</xsl:text>
        -->
      </xsl:when>
      <xsl:when test="self::text()">
        <!-- Check to see if this is a text node. -->
        
        <!-- If so, take any multiple whitespace at the beginning or end of -->
        <!-- it, and replace it with a space plus a linebreak. -->
        
        <!-- This hack results in some ugliness in the generated roff -->
        <!-- source. But it ensures the whitespace around text nodes in mixed -->
        <!-- content gets preserved; without the hack, that whitespace -->
        <!-- effectively gets gobbled. -->

        <!-- Note if the node is just space, we just pass it through -->
        <!-- without (re)adding a line break. -->
        
        <!-- There must be a better way to do with this...  -->
        <xsl:variable name="content">
          <xsl:apply-templates select="."/>
        </xsl:variable>
        <xsl:if
            test="starts-with(translate(.,'&#9;&#10;&#13; ','    '), ' ')
                  and preceding-sibling::node()[name(.)!='']
                  and normalize-space($content) != ''
                  ">
          <xsl:text> &#10;</xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space($content)"/>
        <xsl:if
            test="translate(substring(., string-length(.), 1),'&#x9;&#10;&#13; ','    ')  = ' '
                  and following-sibling::node()[name(.)!='']
                  ">
          <xsl:text> </xsl:text>
          <xsl:if test="normalize-space($content) != ''">
            <xsl:text>&#10;</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- At this point, we know that this node is not a verbatim -->
        <!-- environment, list, or text node; so we can safely -->
        <!-- normailize-space() it. -->
        <xsl:variable name="content">
          <xsl:apply-templates select="."/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($content)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="para">
  <xsl:text>.PP&#10;</xsl:text>
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="simpara">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ============================================================== -->

<!--                ** Everything starts here. ** -->

<xsl:template match="refentry">

  <xsl:variable name="section">
    <xsl:choose>
      <xsl:when test="refmeta/manvolnum">
        <xsl:value-of select="refmeta/manvolnum[1]"/>
      </xsl:when>
      <xsl:when test=".//funcsynopsis">3</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="name" select="refnamediv/refname[1]"/>

  <!-- standard man page width is 64 chars; 6 chars needed for the two
       (x) volume numbers, and 2 spaces, leaves 56 -->
  <xsl:variable name="twidth" select="(56 - string-length(refmeta/refentrytitle)) div 2"/>

  <xsl:variable name="reftitle" 
                select="substring(refmeta/refentrytitle, 1, $twidth)"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="refentryinfo/title">
        <xsl:value-of select="refentryinfo/title"/>
      </xsl:when>
      <xsl:when test="../referenceinfo/title">
        <xsl:value-of select="../referenceinfo/title"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="date">
    <xsl:choose>
      <xsl:when test="refentryinfo/date">
        <xsl:value-of select="refentryinfo/date"/>
      </xsl:when>
      <xsl:when test="../referenceinfo/date">
        <xsl:value-of select="../referenceinfo/date"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="productname">
    <xsl:choose>
      <xsl:when test="refentryinfo/productname">
        <xsl:value-of select="refentryinfo/productname"/>
      </xsl:when>
      <xsl:when test="../referenceinfo/productname">
        <xsl:value-of select="../referenceinfo/productname"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:call-template name="replace-string">
      <!-- replace spaces in source filename with underscores in output filename -->
      <xsl:with-param name="content"
                      select="concat(normalize-space ($name), '.', $section)"/>
      <xsl:with-param name="replace" select="' '"/>
      <xsl:with-param name="with" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="content">

      <!-- generated commented-out page header -->
      <xsl:call-template name="page.header"/>
      
      <!-- generate .TH line -->
      <xsl:call-template name="TH.title.section">
        <xsl:with-param name="reftitle" select="$reftitle"/>
        <xsl:with-param name="section" select="$section"/>
        <xsl:with-param name="date" select="$date"/>
        <xsl:with-param name="productname" select="$productname"/>
        <xsl:with-param name="title" select="$title"/>
      </xsl:call-template>
      
      <!-- generate main body of man page -->
      <xsl:apply-templates/>

      <!-- generate AUTHOR section at end of man page -->
      
    </xsl:with-param>
  </xsl:call-template>
  <!-- Now generate stub include pages for every page documented in
       this refentry (except the page itself) -->
  <xsl:for-each select="refnamediv/refname">
    <xsl:if test=". != $name">
      <xsl:call-template name="write.text.chunk">
        <xsl:with-param name="filename"
                        select="concat(normalize-space(.), '.', $section)"/>
        <xsl:with-param name="content" select="concat('.so man',
              $section, '/', $name, '.', $section, '&#10;')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="page.header">
      <xsl:text>.\"Generated by db2man.xsl. Don't modify this, modify the source.
.\"
. \"---------------------------------------------------
.de Sh \" - a second-level section (a DocBook refsect2)
.br
.if t .Sp
.ne 5
\fB\\$1\fR
.PP
..\"---------------------------------------------------
.de Sp \" - vertical space (when we can't use .PP)
.if t .sp .5v
.if n .sp
..\"---------------------------------------------------
.de Ip \" - a list item
.br
.ie \\n(.$>=3 .ne \\$3
.el .ne 3
.IP "\\$1" \\$2
..\"---------------------------------------------------
.\"</xsl:text>
<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="TH.title.section">
  <xsl:param name="title"/>
  <xsl:param name="reftitle"/>
  <xsl:param name="section"/>
  <xsl:param name="date"/>
  <xsl:param name="productname"/>

  <xsl:text>.\" "TITLE" "SECTION NUMBER" "DATE" "PRODUCT" "GROUP TITLE"</xsl:text>
  <xsl:text>&#10;</xsl:text>
      <xsl:text>.TH "</xsl:text>
      <xsl:value-of select="translate($reftitle,
                            'abcdefghijklmnopqrstuvwxyz',
                            'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:text>" </xsl:text>
      <xsl:value-of select="$section"/>
      <xsl:text> "</xsl:text>
      <xsl:value-of select="normalize-space($date)"/>
      <xsl:text>" "</xsl:text>
      <xsl:value-of select="normalize-space($productname)"/>
      <xsl:text>" "</xsl:text>
      <xsl:value-of select="$title"/>
      <xsl:text>"&#10;</xsl:text>
</xsl:template>

<xsl:template name="author.section">
  <xsl:choose>
    <xsl:when test="refentryinfo//author">
      <xsl:apply-templates select="refentryinfo" mode="authorsect"/>
    </xsl:when>
    <xsl:when test="/book/bookinfo//author">
      <xsl:apply-templates select="/book/bookinfo" mode="authorsect"/>
    </xsl:when>
    <xsl:when test="/article/articleinfo//author">
      <xsl:apply-templates select="/article/articleinfo" mode="authorsect"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="refmeta"></xsl:template>
<xsl:template match="title"></xsl:template>
<xsl:template match="abstract"></xsl:template>

<!-- ============================================================== -->

<xsl:template match="articleinfo|bookinfo|refentryinfo" mode="authorsect">
  <xsl:text>.SH "</xsl:text>
  <xsl:call-template name="string.upper">
    <xsl:with-param name="string">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Author'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>"&#10;</xsl:text>

  <xsl:for-each select=".//author">
    <xsl:if test="position() > 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <xsl:text>. &#10;</xsl:text>
  <xsl:if test=".//editor">
    <xsl:text>.br&#10;</xsl:text>
    <xsl:apply-templates select=".//editor"/>
    <xsl:text>. (man page)&#10;</xsl:text>
  </xsl:if>
  <xsl:for-each select="address">
  <xsl:text>.br&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="author|editor">
  <xsl:call-template name="person.name"/>
  <xsl:if test=".//email">
    <xsl:text> </xsl:text>
    <xsl:apply-templates select=".//email"/>
  </xsl:if>
</xsl:template>

<xsl:template match="copyright">
  <xsl:text>Copyright \(co  </xsl:text>
  <xsl:apply-templates select="./year" />
  <xsl:text>.Sp&#10;</xsl:text>
</xsl:template>

<xsl:template match="email">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="refnamediv">
  <xsl:text>.SH "</xsl:text>
  <xsl:call-template name="string.upper">
    <xsl:with-param name="string">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefName'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>"&#10;</xsl:text>
  <xsl:for-each select="refname">
    <xsl:if test="position()>1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:text> \- </xsl:text>
  <xsl:value-of select="normalize-space (refpurpose)"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="refentry/refentryinfo"></xsl:template>

<xsl:template match="informalexample|screen">
  <xsl:text>.IP&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="filename|replaceable|varname">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="option|userinput|envar|errorcode|constant|type">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role = 'bold' or @role = 'strong'">
      <xsl:apply-templates mode="bold" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="italic" select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>``</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>''</xsl:text>
</xsl:template>

<xsl:template match="address|literallayout|programlisting|screen|synopsis">
  <!-- Yes, address and synopsis are verbatim environments. -->

  <xsl:choose>
    <!-- Check to see if this vertbatim item is within a parent element that -->
    <!-- allows mixed content. -->
    
    <!-- If it is within a mixed-content parent, then a line break is -->
    <!-- already added before it by the mixed-block template, so we don't -->
    <!-- need to add one here. -->
    
    <!-- If it is not within a mixed-content parent, then we need to add a -->
    <!-- line break before it. -->
    <xsl:when test="parent::caption|parent::entry|parent::para|
                    parent::td|parent::th" /> <!-- do nothing -->
    <xsl:otherwise>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.nf&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>.fi&#10;</xsl:text>
</xsl:template>

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<xsl:template name="do-citerefentry">
  <xsl:param name="refentrytitle" select="''"/>
  <xsl:param name="manvolnum" select="''"/>

  <xsl:apply-templates mode="bold" select="$refentrytitle"/>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$manvolnum"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:call-template name="do-citerefentry">
    <xsl:with-param name="refentrytitle" select="refentrytitle"/>
    <xsl:with-param name="manvolnum" select="manvolnum"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="ulink">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="url" select="@url"/>
  <xsl:choose>
    <xsl:when test="$url=$content or $content=''">
      <xsl:text>\fI</xsl:text>
      <xsl:value-of select="$url"/>
      <xsl:text>\fR</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$content"/>
      <xsl:text>: \fI</xsl:text>
      <xsl:value-of select="$url"/>
      <xsl:text>\fR</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Translate some entities to textual equivalents. -->
<xsl:template name="replace-string">
  <xsl:param name="content" select="''"/>
  <xsl:param name="replace" select="''"/>
  <xsl:param name="with" select="''"/>
  <xsl:choose>
    <xsl:when test="not(contains($content,$replace))">
      <xsl:value-of select="$content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring-before($content,$replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">
        <xsl:with-param name="content"
             select="substring-after($content,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="replace-dash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'-'"/>
    <xsl:with-param name="with" select="'\-'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-ndash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8211;'"/>
    <xsl:with-param name="with" select="'-'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-mdash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8212;'"/>
    <xsl:with-param name="with" select="'--'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-hellip">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8230;'"/>
    <xsl:with-param name="with" select="'...'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-setmn">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8726;'"/>
    <xsl:with-param name="with" select="'\\'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-minus">
  <xsl:param name="content" select="''"/>
  <xsl:value-of select="translate($content,'&#8722;','-')"/>
</xsl:template>

<xsl:template name="replace-nbsp">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#x00a0;'"/>
    <xsl:with-param name="with" select="'\~'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-ldquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8220;'"/>
    <xsl:with-param name="with" select="'\(lq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-rdquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'&#8221;'"/>
    <xsl:with-param name="with" select="'\(rq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-backslash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'\'"/>
    <xsl:with-param name="with" select="'\\'"/>
  </xsl:call-template>
</xsl:template>

<!-- if a period character is output at the beginning of a line
  it will be interpreted as a groff macro, so prefix all periods
  with "\&", a zero-width space. -->
<xsl:template name="replace-period">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="replace" select="'.'"/>
    <xsl:with-param name="with" select="'\&#38;.'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-entities">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-hellip">
    <xsl:with-param name="content">
      <xsl:call-template name="replace-minus">
        <xsl:with-param name="content">
          <xsl:call-template name="replace-mdash">
            <xsl:with-param name="content">
              <xsl:call-template name="replace-ndash">
                <xsl:with-param name="content">
                  <xsl:call-template name="replace-dash">
                    <xsl:with-param name="content">
                      <xsl:call-template name="replace-setmn">
                        <xsl:with-param name="content">
                          <xsl:call-template name="replace-period">
                            <xsl:with-param name="content">
                              <xsl:call-template name="replace-nbsp">
                                <xsl:with-param name="content">
                                  <xsl:call-template name="replace-ldquo">
                                    <xsl:with-param name="content">
                                      <xsl:call-template name="replace-rdquo">
                                        <xsl:with-param name="content">
                                          <xsl:call-template name="replace-backslash">
                                            <xsl:with-param name="content" select="$content"/>
                                          </xsl:call-template>
                                        </xsl:with-param>
                                      </xsl:call-template>
                                    </xsl:with-param>
                                  </xsl:call-template>
                                </xsl:with-param>
                              </xsl:call-template>
                            </xsl:with-param>
                          </xsl:call-template>
                        </xsl:with-param>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="dingbat.characters">
  <!-- now that I'm using the real serializer, all that dingbat malarky -->
  <!-- isn't necessary anymore... -->
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:choose>
    <xsl:when test="$dingbat='bullet'">\(bu</xsl:when>
    <xsl:when test="$dingbat='copyright'">\(co</xsl:when>
    <xsl:when test="$dingbat='trademark'">\(tm</xsl:when>
    <xsl:when test="$dingbat='trade'">\(tm</xsl:when>
    <xsl:when test="$dingbat='registered'">\(rg</xsl:when>
    <xsl:when test="$dingbat='service'">(SM)</xsl:when>
    <xsl:when test="$dingbat='nbsp'">\~</xsl:when>
    <xsl:when test="$dingbat='ldquo'">\(lq</xsl:when>
    <xsl:when test="$dingbat='rdquo'">\(rq</xsl:when>
    <xsl:when test="$dingbat='lsquo'">`</xsl:when>
    <xsl:when test="$dingbat='rsquo'">'</xsl:when>
    <xsl:when test="$dingbat='em-dash'">\(em</xsl:when>
    <xsl:when test="$dingbat='mdash'">\(em</xsl:when>
    <xsl:when test="$dingbat='en-dash'">\(en</xsl:when>
    <xsl:when test="$dingbat='ndash'">\(en</xsl:when>
    <xsl:otherwise>
      <xsl:text>\(bu</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()">
  <xsl:call-template name="replace-entities">
    <xsl:with-param name="content">
      <xsl:value-of select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

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

</xsl:stylesheet>
