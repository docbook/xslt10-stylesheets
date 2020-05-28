<?xml version='1.0'?> 
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc='http://nwalsh.com/xsl/documentation/1.0'
                xmlns:suwl='http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks'
                exclude-result-prefixes='doc html'
                version='1.0'>

<!--
  This is a docbook XSL stylesheet customization that embeds the
  DocBook document chunking formalism within the DocBook Website 
  formalism, in order to extend the hierarchical tabular navigation
  menu of Docbook website to the chunked sections of website
  embedded books, parts or articles. 
  Caveat: Website really likes unique IDs on all chunkable nodes.

  As a bonus, it still works for Website 'webpage' documents too!
  Webpages are explicitly unchunkable

  Actually if you omit to define the 'autolayout-file' parameter string
  you may well find yourself with a stand-alone chunked tabular book,
  of a sort ... 

  Customization by Doug du Boulay (2005) ddb@owari.msl.titech.ac.jp
  Be freeeee...
   
  -->

<!--
<xsl:import href='xbel.xsl'/>
<xsl:include href='VERSION'/>
<xsl:include href='head.xsl'/>
<xsl:include href='rss.xsl'/>
<xsl:include href='olink.xsl'/>
  -->

<xsl:preserve-space elements='*'/>
<xsl:strip-space elements='website webpage'/>

<xsl:output method='html'
            indent='no'/>

<!--  ======================================================================  -->
<!--
 |
 |file:  html/admon.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->
<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:output method="html"/>
 -->

<!-- ==================================================================== -->

<xsl:param name="website" select="''"/> <!-- part of a larger website -->

<xsl:param name="tabular" select="'0'"/> <!-- for the website tabular toc style -->

<xsl:param name="website.database.document"
           select="'website.database.xml'"/>



<!-- ==================================================================== -->
<xsl:param name="header.hr" select="1"/>

<doc:param name="header.hr" xmlns="">
<refpurpose>Toggle &lt;HR> after header</refpurpose>
<refdescription>
<para>If non-zero, an &lt;HR> is generated at the top of each web page,
after the heaader.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="footer.hr" select="1"/>

<doc:param name="footer.hr" xmlns="">
<refpurpose>Toggle &lt;HR> before footer</refpurpose>
<refdescription>
<para>If non-zero, an &lt;HR> is generated at the bottom of each web page,
before the footer.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="feedback.href"></xsl:param>

<doc:param name="feedback.href" xmlns="">
<refpurpose>HREF for feedback link</refpurpose>
<refdescription>
<para>The <varname>feedback.href</varname> value is used as the value
for the <sgmltag class="attribute">href</sgmltag> attribute on the feedback
link. If <varname>feedback.href</varname>
is empty, no feedback link is generated.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="feedback.with.ids" select="0"/>

<doc:param name="feedback.with.ids" xmlns="">
<refpurpose>Toggle use of IDs in feedback</refpurpose>
<refdescription>
<para>If <varname>feedback.with.ids</varname> is non-zero, the ID of the
current page will be added to the feedback link. This can be used, for
example, if the <varname>feedback.href</varname> is a CGI script.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="feedback.link.text">Feedback</xsl:param>

<doc:param name="feedback.link.text" xmlns="">
<refpurpose>The text of the feedback link</refpurpose>
<refdescription>
<para>The contents of this variable is used as the text of the feedback
link if <varname>feedback.href</varname> is not empty. If
<varname>feedback.href</varname> is empty, no feedback link is
generated.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="filename-prefix" select="''"/>

<doc:param name="filename-prefix" xmlns="">
<refpurpose>Prefix added to all filenames</refpurpose>
<refdescription>
<para>To produce the <quote>text-only</quote> (that is, non-tabular) layout
of a website simultaneously with the tabular layout, the filenames have to
be distinguished. That's accomplished by adding the
<varname>filename-prefix</varname> to the front of each filename.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="autolayout-file" select="'autolayout.xml'"/>

<doc:param name="autolayout-file" xmlns="">
<refpurpose>Identifies the autolayout.xml file</refpurpose>
<refdescription>
<para>When the source pages are spread over several directories, this
parameter can be set (for example, from the command line of a batch-mode
XSLT processor) to indicate the location of the autolayout.xml file.</para>
<para>FIXME: for browser-based use, there needs to be a PI for this...
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="output-root" select="'.'"/>

<doc:param name="ouput-root" xmlns="">
<refpurpose>Specifies the root directory of the website</refpurpose>
<refdescription>
<para>When using the XSLT processor to manage dependencies and construct
the website, this parameter can be used to indicate the root directory
where the resulting pages are placed.</para>
<para>Only applies when XSLT-based chunking is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="dry-run" select="'0'"/>

<doc:param name="dry-run" xmlns="">
<refpurpose>Indicates that no files should be produced</refpurpose>
<refdescription>
<para>When using the XSLT processor to manage dependencies and construct
the website, this parameter can be used to suppress the generation of
new and updated files. Effectively, this allows you to see what the
stylesheet would do, without actually making any changes.</para>
<para>Only applies when XSLT-based chunking is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="rebuild-all" select="'0'"/>

<doc:param name="" xmlns="">
<refpurpose>Indicates that all files should be produced</refpurpose>
<refdescription>
<para>When using the XSLT processor to manage dependencies and construct
the website, this parameter can be used to regenerate the whole website,
updating even pages that don't appear to need to be updated.</para>
<para>The dependency extension only looks at the source documents. So
if you change something in the stylesheet, for example, that has a global
effect, you can use this parameter to force the stylesheet to rebuild the
whole website.
</para>
<para>Only applies when XSLT-based chunking is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="nav.table.summary">Navigation</xsl:param>

<doc:param name="nav.table.summary" xmlns="">
<refpurpose>HTML Table summary attribute value for navigation tables</refpurpose>
<refdescription>
<para>The value of this parameter is used as the value of the table
summary attribute for the navigation table.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="navtocwidth">220</xsl:param>

<doc:param name="navtocwidth" xmlns="">
<refpurpose>Specifies the width of the navigation table TOC</refpurpose>
<refdescription>
<para>The width, in pixels, of the navigation column.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="navbodywidth"></xsl:param>

<doc:param name="navbodywidth" xmlns="">
<refpurpose>Specifies the width of the navigation table body</refpurpose>
<refdescription>
<para>The width of the body column.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="textbgcolor">white</xsl:param>

<doc:param name="textbgcolor" xmlns="">
<refpurpose>The background color of the table body</refpurpose>
<refdescription>
<para>The background color of the table body.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="navbgcolor">#4080FF</xsl:param>

<doc:param name="navbgcolor" xmlns="">
<refpurpose>The background color of the navigation TOC</refpurpose>
<refdescription>
<para>The background color of the navigation TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.spacer.graphic" select="1"/>

<doc:param name="toc.space.graphic" xmlns="">
<refpurpose>Use graphic for TOC spacer?</refpurpose>
<refdescription>
<para>If non-zero, the indentation in the TOC will be accomplished
with the graphic identified by <varname>toc.spacer.image</varname>.
</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.spacer.text">&#160;&#160;&#160;</xsl:param>

<doc:param name="toc.spacer.text" xmlns="">
<refpurpose>The text for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.spacer.graphic</varname> is zero, this text string
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.spacer.image">graphics/blank.gif</xsl:param>

<doc:param name="toc.spacer.image" xmlns="">
<refpurpose>The image for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.spacer.graphic</varname> is non-zero, this image
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.pointer.graphic" select="1"/>

<doc:param name="toc.space.graphic" xmlns="">
<refpurpose>Use graphic for TOC pointer?</refpurpose>
<refdescription>
<para>If non-zero, the indentation in the TOC will be accomplished
with the graphic identified by <varname>toc.pointer.image</varname>.
</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.pointer.text">&#160;&#160;&#160;</xsl:param>

<doc:param name="toc.pointer.text" xmlns="">
<refpurpose>The text for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.pointer.graphic</varname> is zero, this text string
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.pointer.image">graphics/blank.gif</xsl:param>

<doc:param name="toc.pointer.image" xmlns="">
<refpurpose>The image for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.pointer.graphic</varname> is non-zero, this image
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.blank.graphic" select="1"/>

<doc:param name="toc.space.graphic" xmlns="">
<refpurpose>Use graphic for TOC blank?</refpurpose>
<refdescription>
<para>If non-zero, the indentation in the TOC will be accomplished
with the graphic identified by <varname>toc.blank.image</varname>.
</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.blank.text">&#160;&#160;&#160;</xsl:param>

<doc:param name="toc.blank.text" xmlns="">
<refpurpose>The text for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.blank.graphic</varname> is zero, this text string
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="toc.blank.image">graphics/blank.gif</xsl:param>

<doc:param name="toc.blank.image" xmlns="">
<refpurpose>The image for spacing the TOC</refpurpose>
<refdescription>
<para>If <varname>toc.blank.graphic</varname> is non-zero, this image
will be used to indent the TOC.</para>
<para>Only applies with the tabular presentation is being used.</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="suppress.homepage.title" select="'1'"/>

<doc:param name="" xmlns="">
<refpurpose></refpurpose>
<refdescription>
<para></para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:attribute-set name="body.attributes">
  <xsl:attribute name="bgcolor">white</xsl:attribute>
  <xsl:attribute name="text">black</xsl:attribute>
  <xsl:attribute name="link">#0000FF</xsl:attribute>
  <xsl:attribute name="vlink">#840084</xsl:attribute>
  <xsl:attribute name="alink">#0000FF</xsl:attribute>
</xsl:attribute-set>

<doc:attribute-set name="body.attributes" xmlns="">
<refpurpose>DEPRECATED</refpurpose>
<refdescription>
<para></para>
</refdescription>
</doc:attribute-set>

<!-- ==================================================================== -->
<xsl:param name="sequential.links" select="'0'"/>

<doc:param name="sequential.links" xmlns="">
<refpurpose></refpurpose>
<refdescription>
<para></para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="currentpage.marker" select="'@'"/>

<doc:param name="currentpage.marker" xmlns="">
<refpurpose></refpurpose>
<refdescription>
<para></para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="banner.before.navigation" select="1"/>

<doc:param name="banner.before.navigation" xmlns="">
<refpurpose></refpurpose>
<refdescription>
<para></para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="table.spacer.image" select="'graphics/spacer.gif'"/>

<doc:param name="table.spacer.image" xmlns="">
<refpurpose>Invisible pixel for tabular accessibility</refpurpose>
<refdescription>
<para>This is the 1x1 pixel, transparent pixel used for
<ulink url="http://diveintoaccessibility.org/day_10_presenting_your_main_content_first.html">the table trick</ulink> to increase the accessibility of the tabular
website presentation.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->

<xsl:param name="tabular.chunk.root.banner.filename" select="'graphics/banner.png'"/>
<xsl:param name="tabular.chunk.root.banner.altval" select="'doc root node'"/>
<xsl:param name="tabular.chunk.toroot.banner.filename" select="'graphics/homebanner.png'"/>
<xsl:param name="tabular.chunk.toroot.banner.altval" select="'to doc root node'"/>

<!-- ==================================================================== -->


<xsl:variable name="autolayout" select="document($autolayout-file,/)/autolayout"/>

<xsl:variable name="src-rootnode" select="/*"/>

<xsl:variable name="src-rootnode-id" select="$src-rootnode/@id"/>

<xsl:variable name="target-dir-path">
  <xsl:message>
    <xsl:text>source rootnode id is: </xsl:text> 
    <xsl:value-of select="$src-rootnode-id"/>
  </xsl:message>
  <xsl:message>
    <xsl:text>autolayout file is: </xsl:text> 
    <xsl:value-of select="$autolayout-file"/>
  </xsl:message>
  <xsl:message>
    <xsl:text>autolayout root node: </xsl:text> 
    <xsl:value-of select="$autolayout/descendant::toc/@id"/>
  </xsl:message>
    <xsl:choose>
      <xsl:when test="$autolayout != '' and $website != ''" >
        <xsl:variable name="temp">
          <xsl:call-template name="root-rel-path">
            <xsl:with-param name="page" select="$autolayout//*[@id = $src-rootnode-id]"/>
          </xsl:call-template>
        </xsl:variable>
  <xsl:message>
    <xsl:text>target-dir-path is: </xsl:text> 
    <xsl:value-of select="$temp"/>
  </xsl:message>
      <xsl:value-of select="$temp"/>

      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$base.dir"/>
  <xsl:message>
    <xsl:text>target-dir-path is: </xsl:text> 
    <xsl:value-of select="$base.dir"/>
  </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
</xsl:variable>


<!--
</xsl:stylesheet>
  -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/website-tabular.xsl
 |
 -->
<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="html doc"
                version="1.0">
 -->

<!-- ==================================================================== -->

<!-- Netscape gets badly confused if it sees a CSS style... -->
<xsl:param name="admon.style" select="''"/>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">graphics/</xsl:param>
<xsl:param name="admon.graphics.extension">.gif</xsl:param>

<xsl:attribute-set name="table.properties">
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">0</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.navigation.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navotocwidth -->
  <xsl:attribute name="bgcolor">
    <xsl:choose>
      <xsl:when test="/webpage/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="/webpage/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/autolayout/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="$autolayout/autolayout/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$navbgcolor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navobodywidth -->
  <xsl:attribute name="bgcolor">
    <xsl:value-of select="$textbgcolor"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="body.columns" select="2"/>

<!-- ==================================================================== -->


<xsl:template name="home.navhead">
  <xsl:text>Navhead</xsl:text>
</xsl:template>

<xsl:template name="home.navhead.upperright">
  <xsl:text>Upper-right</xsl:text>
</xsl:template>

<xsl:template name="home.navhead.cell">
  <td width="50%" valign="middle" align="left">
    <xsl:call-template name="home.navhead"/>
  </td>
</xsl:template>

<xsl:template name="home.navhead.upperright.cell">
  <td width="50%" valign="middle" align="right">
    <xsl:call-template name="home.navhead.upperright"/>
  </td>
</xsl:template>

<xsl:template name="home.navhead.separator">
  <hr/>
</xsl:template>



<xsl:template name="hspacer">
  <!-- nop -->
</xsl:template>

<xsl:template match="config[@param='filename']" mode="head.mode">
</xsl:template>

<xsl:template match="webtoc">
  <!-- nop -->
</xsl:template>

<!--
</xsl:stylesheet>
 -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/website-tabular-toc.xsl
 |         build-navtoc  - what an ugly hack. But it works! 
 |
 -->

<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>
 -->

<xsl:param name="nav.graphics" select="1"/>
<xsl:param name="nav.pointer" select="1"/>
<xsl:param name="nav.revisionflag" select="1"/>

<xsl:param name="toc.spacer.text">&#160;&#160;&#160;</xsl:param>
<xsl:param name="toc.spacer.image">graphics/blank.gif</xsl:param>

<xsl:param name="nav.icon.path">graphics/navicons/</xsl:param>
<xsl:param name="nav.icon.extension">.gif</xsl:param>

<!-- styles: folder, folder16, plusminus, triangle, arrow -->
<xsl:param name="nav.icon.style">triangle</xsl:param>

<xsl:param name="nav.text.spacer">&#160;</xsl:param>
<xsl:param name="nav.text.current.open">+</xsl:param>
<xsl:param name="nav.text.current.page">+</xsl:param>
<xsl:param name="nav.text.other.open">&#160;</xsl:param>
<xsl:param name="nav.text.other.closed">&#160;</xsl:param>
<xsl:param name="nav.text.other.page">&#160;</xsl:param>
<xsl:param name="nav.text.revisionflag.added">New</xsl:param>
<xsl:param name="nav.text.revisionflag.changed">Changed</xsl:param>
<xsl:param name="nav.text.revisionflag.deleted"></xsl:param>
<xsl:param name="nav.text.revisionflag.off"></xsl:param>

<xsl:param name="nav.text.pointer">&lt;-</xsl:param>

<xsl:param name="toc.expand.depth" select="1"/>

<!-- ==================================================================== --> 

<xsl:template match="toc/title|tocentry/title|titleabbrev">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="toc" />
<xsl:template match="tocentry"/>


<!-- ==================================================================== -->

<!-- The build-navtoc recurses, starting from the autolayout/toc node,
     down the tocentry hierarchy before jumping to relevent, chunkable
     first child nodes of the target document being chunked, before 
     progressing recursively down the chapters and sections to the 
     chunk with id $targetid (oh, and its first level children, if any).
  --> 

<xsl:template name="build-navtoc">

  <xsl:param name="context"  select="."/>
  <xsl:param name="targetdepth" select="count(ancestor::*)"/>
  <xsl:param name="docid"    select="$src-rootnode-id"/>
  <xsl:param name="toc"      select="$src-rootnode"/>
  <xsl:param name="node"     select="."/>
  <xsl:param name="toclevel" select="count(ancestor::*)"/>
  <xsl:param name="relpath" select="''"/>

  <xsl:variable name="revisionflag" select="@revisionflag"/>

  <xsl:variable name="page" select="."/>
  <xsl:variable name="pageid">
    <xsl:choose>
      <xsl:when test="not($autolayout)">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$node"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="contextid">
    <xsl:choose>
      <xsl:when test="not($autolayout)">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$context"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$context/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>



               <!-- select this tocentry or first unskipped child --> 
               <!-- or next closest sibbling tocentry -->
               <!-- or any passed in document $node that isn't a tocentry -->
            <!--
               select="($node/descendant-or-self::tocentry[@tocskip = '']
                       |$node/following::tocentry[@tocskip='']
                       |$node[not(name($node) ='tocentry')] )[1]"/>
              -->
  <xsl:variable name="target"
       select="($node/descendant-or-self::tocentry[not(@tocskip) or @tocskip = '']
               |$node/following::tocentry[not(@tocskip) or @tocskip = '']
               |$node[not(name($node) ='tocentry')] )[1]"/>

<!--
  <xsl:message>
    <xsl:text>xxxx </xsl:text>
    <xsl:text>node  </xsl:text>
    <xsl:value-of select="name($node)"/>
    <xsl:text>target  </xsl:text>
    <xsl:value-of select="name($target)"/>
    <xsl:text>value  </xsl:text>
    <xsl:copy-of select="$target"/>
  </xsl:message>
  -->

  <xsl:variable name="isdescendant"> <!-- this node is a descendant of the target node? -->
    <xsl:choose>
      <xsl:when test="$node/ancestor::*[@id=$contextid]">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="hasdescendant">  <!-- this node has chunked or chunkable children? -->
    <xsl:choose>
      <xsl:when test="name($node) = 'toc' ">0</xsl:when>   <!-- it does, but ignore it -->
      <xsl:when test="name($node) = 'tocentry' and $node/descendant::tocentry != ''">1</xsl:when>
      <xsl:when test="name($node) = 'tocentry' and $node/@multisect != ''">1</xsl:when>
      <xsl:when test="name($node) = 'tocentry'"> <!-- its a tocentry leaf and a document root -->
        <xsl:choose>
          <xsl:when test="$pageid != $docid">0</xsl:when>  <!-- HELP! not this doc, so no idea -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="name($src-rootnode)='webpage'">0</xsl:when>
              <xsl:when test="  $src-rootnode/appendix
                               |$src-rootnode/article
                               |$src-rootnode/bibliography
                               |$src-rootnode/book
                               |$src-rootnode/chapter
                               |$src-rootnode/colophon
                               |$src-rootnode/glossary
                               |$src-rootnode/index
                               |$src-rootnode/part
                               |$src-rootnode/preface
                               |$src-rootnode/refentry
                               |$src-rootnode/reference
                               |$src-rootnode/sect1
                               |$src-rootnode/sect2
                               |$src-rootnode/sect3
                               |$src-rootnode/sect4
                               |$src-rootnode/sect5
                               |$src-rootnode/section
                               |$src-rootnode/set
                               |$src-rootnode/setindex">1</xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>  
      <xsl:otherwise>             <!-- $target is in currently being chunked doc -->
        <xsl:choose>
          <xsl:when test="$onechunk != 0">0</xsl:when>
          <xsl:when test="$node/article/bibliography
                             |$node/article/glossary
                             |$node/article/index
                             |$node/book/bibliography
                             |$node/book/glossary
                             |$node/book/index">1</xsl:when>
          <xsl:when test="$node/section 
                               |$node/appendix
                               |$node/article
                               |$node/bibliography[$node[article] or $node[book]]
                               |$node/book
                               |$node/chapter
                               |$node/colophon
                               |$node/glossary[$node[article] or $node[book]]
                               |$node/index[$node[article] or $node[book]]
                               |$node/part
                               |$node/preface
                               |$node/refentry
                               |$node/reference
                               |$node/sect1[$chunk.section.depth &gt; 0]
                               |$node/sect2[$chunk.section.depth &gt; 1]
                               |$node/sect3[$chunk.section.depth &gt; 2]
                               |$node/sect4[$chunk.section.depth &gt; 3]
                               |$node/sect5[$chunk.section.depth &gt; 4]
                           |$node/section[$chunk.section.depth &gt; count($node/ancestor::section)]
                               |$node/set
                               |$node/setindex">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

      <!-- this $target is an ancestor of the $context/@id webpage/chunk -->
  <xsl:variable name="isancestor">
    <xsl:choose>
        <!-- for docid in sub-tocentry or sectionid in subsection -->
      <xsl:when test="name($node)='tocentry' or name($node)='toc'">
        <xsl:choose>
          <xsl:when test="$node/descendant::*[@id=$contextid]">1</xsl:when>
          <xsl:when test="$node/descendant-or-self::*[@id=$docid]">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
        <!-- for  sectionid in  subsection of leaf tocentry doc -->
      <xsl:when test="$context/ancestor::*[@id = $node/@id]">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="use.toc.expand.depth">
    <xsl:variable name="config-param" 
           select="$autolayout/config[@param='toc.expand.depth']/@value"/>
    <xsl:choose>
      <!-- toc.expand.depth attribute is not in DTD -->
      <xsl:when test="ancestor::toc/@toc.expand.depth">
        <xsl:value-of select="ancestor::toc/@toc.expand.depth"/>
      </xsl:when>
      <xsl:when test="floor($config-param) > 0">
        <xsl:value-of select="$config-param"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$toc.expand.depth"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="is.open">
    <xsl:choose>
      <xsl:when test="$contextid = $pageid
                      or $isancestor='1'
                      or $toclevel &lt; $use.toc.expand.depth">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:message>
    <xsl:text>   Navtoc </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> (targetid=</xsl:text>
    <xsl:value-of select="$contextid"/>
    <xsl:text>,docid=</xsl:text>
    <xsl:value-of select="$docid"/>
<!--
    <xsl:text>,toclevel=</xsl:text>
    <xsl:value-of select="$toclevel"/>
    <xsl:text>,relpath=</xsl:text>
    <xsl:value-of select="$relpath"/>
  -->
    <xsl:text>,pageid=</xsl:text>
    <xsl:value-of select="$pageid"/>
<!--
    <xsl:text>,targetdepth=</xsl:text>
    <xsl:value-of select="$targetdepth"/>
  -->
    <xsl:text>) </xsl:text>
  </xsl:message>
  <!-- xsl:message>
    <xsl:text>   Vars:(is.open=</xsl:text>
    <xsl:value-of select="$is.open"/>
    <xsl:text>,isancestor=</xsl:text>
    <xsl:value-of select="$isancestor"/>
    <xsl:text>,isdescendant=</xsl:text>
    <xsl:value-of select="$isdescendant"/>
    <xsl:text>,hasdescendant=</xsl:text>
    <xsl:value-of select="$hasdescendant"/>
    <xsl:text>)</xsl:text>
  </xsl:message -->

  <!-- For any entry in the TOC:
       1. It is the current page
          a. it is a leaf             current/leaf
          b. it is an open page       current/open
       2. It is not the current page
          a. it is a leaf             other/leaf
          b. it is an open page       other/open
          c. it is a closed page      other/closed
  -->

  <xsl:variable name="preceding-icon">
    <xsl:value-of select="$relpath"/>
    <xsl:value-of select="$nav.icon.path"/>
    <xsl:value-of select="$nav.icon.style"/>
    <xsl:choose>
      <xsl:when test="$pageid=$contextid">
        <xsl:choose>
          <xsl:when test="$hasdescendant != 0">
            <xsl:text>/current/open</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>/current/leaf</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$hasdescendant = 0">
            <xsl:text>/other/leaf</xsl:text>
          </xsl:when>
          <xsl:when test="$is.open != 0">
            <xsl:text>/other/open</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>/other/closed</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$nav.icon.extension"/>
  </xsl:variable>

  <xsl:variable name="preceding-text">
    <xsl:choose>
      <xsl:when test="$pageid=$contextid">
        <xsl:choose>
          <xsl:when test="$hasdescendant != 0">
            <xsl:value-of select="$nav.text.current.open"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nav.text.current.page"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$is.open != 0">   <!--  xsl:when test="$isancestor != 0" -->
            <xsl:value-of select="$nav.text.other.open"/>
          </xsl:when>
          <xsl:when test="$hasdescendant != 0">
            <xsl:value-of select="$nav.text.other.closed"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nav.text.other.page"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="following-icon">
    <xsl:value-of select="$relpath"/>
    <xsl:value-of select="$nav.icon.path"/>
    <xsl:value-of select="$nav.icon.style"/>
    <xsl:text>/current/pointer</xsl:text>
    <xsl:value-of select="$nav.icon.extension"/>
  </xsl:variable>

  <xsl:variable name="following-text">
    <xsl:value-of select="$nav.text.pointer"/>
  </xsl:variable>

  <xsl:variable name="revisionflag-icon">
    <xsl:value-of select="$relpath"/>
    <xsl:value-of select="$nav.icon.path"/>
    <xsl:value-of select="$nav.icon.style"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$revisionflag"/>
    <xsl:value-of select="$nav.icon.extension"/>
  </xsl:variable>

  <xsl:variable name="revisionflag-text">
    <xsl:choose>
      <xsl:when test="$revisionflag = 'changed'">
        <xsl:value-of select="$nav.text.revisionflag.changed"/>
      </xsl:when>
      <xsl:when test="$revisionflag = 'added'">
        <xsl:value-of select="$nav.text.revisionflag.added"/>
      </xsl:when>
      <xsl:when test="$revisionflag = 'deleted'">
        <xsl:value-of select="$nav.text.revisionflag.deleted"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nav.text.revisionflag.off"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <span>
    <xsl:if test="$toclevel = 1">
      <xsl:attribute name="class">
        <xsl:text>toplevel</xsl:text>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$toclevel &gt; 1">
      <xsl:attribute name="class">
        <xsl:text>shrink</xsl:text>
        <xsl:value-of select="$toclevel - 1"/>
      </xsl:attribute>
    </xsl:if>

    <!-- recursively add relpath/graphic for each toclevel -->
    <xsl:call-template name="insert.spacers"> 
      <xsl:with-param name="count" select="$toclevel - 1"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:call-template>


    <xsl:variable name="href.target">
      <xsl:choose>
        <xsl:when test="name($target) = 'tocentry' and $target/@href != ''">
          <xsl:value-of select="$target/@href"/>
          <xsl:if test="$target/@filename != ''">
            <xsl:message terminate="yes">
             <xsl:text>Cannot have @href and @filename in one autolayout//tocentry.</xsl:text>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:choose>
      <xsl:when test="$nav.graphics != 0">
        <xsl:call-template name="link.to.page">
          <xsl:with-param name="href" select="$href.target"/>
          <xsl:with-param name="framelink" select="$target/@framelink"/>
          <xsl:with-param name="linktext">
            <img src="{$preceding-icon}" alt="{$preceding-text}" border="0"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$preceding-text"/>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:choose>
      <xsl:when test="$pageid = $contextid and 
                    not ((name($node) = 'tocentry' or 
                          name($node) = 'toc' ) and $pageid != $docid) ">
        <span class="curpage">
          <xsl:choose>
            <xsl:when test="$node/titleabbrev">
                  <xsl:for-each select="$node/titleabbrev[1]">
                     <xsl:apply-templates/>
                  </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                  <xsl:for-each select="$node/title[1]">
                     <xsl:apply-templates/>
                  </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="$nav.revisionflag != '0' and $revisionflag">
            <xsl:value-of select="$nav.text.spacer"/>
            <xsl:choose>
              <xsl:when test="$nav.graphics = '1'">
                <img src="{$revisionflag-icon}" alt="{$revisionflag-text}" align="bottom"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="$revisionflag-text"/>
                <xsl:text>)</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
	  </xsl:if>

          <xsl:if test="$nav.pointer != '0'">
            <xsl:value-of select="$nav.text.spacer"/>
            <xsl:choose>
              <xsl:when test="$nav.graphics = '1'">
                <img src="{$following-icon}" alt="{$following-text}"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$following-text"/>
              </xsl:otherwise>
            </xsl:choose>
	  </xsl:if>
        </span>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:choose>
            <xsl:when test="$isdescendant='0'">
              <xsl:choose>
                <xsl:when test="$isancestor='1'">
                  <xsl:attribute name="class">ancestor</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">otherpage</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <!-- IS a descendant of curpage -->
              <xsl:attribute name="class">descendant</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:call-template name="link.to.page">
            <xsl:with-param name="href" select="$href.target"/>
            <xsl:with-param name="page" select="$target"/>
            <xsl:with-param name="framelink" select="$target/@framelink"/>
            <xsl:with-param name="linktext">
              <xsl:choose>
                <xsl:when test="$node/titleabbrev">
                  <xsl:for-each select="$node/titleabbrev[1]">
                     <xsl:apply-templates/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$node/title[1]">
                     <xsl:apply-templates/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:if test="$nav.revisionflag != '0' and $revisionflag">
            <xsl:value-of select="$nav.text.spacer"/>
            <xsl:choose>
              <xsl:when test="$nav.graphics = '1'">
                <img src="{$revisionflag-icon}" alt="{$revisionflag-text}"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="$revisionflag-text"/>
                <xsl:text>)</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
	  </xsl:if>

        </span>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </span>


  <xsl:if test="$is.open != 0">       <!-- recurse down hierarchy -->
    <xsl:choose>
      <xsl:when test="$node/tocentry">
        <xsl:for-each select= "$node/tocentry">
          <xsl:call-template name="build-navtoc">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="targetdepth" select="$targetdepth"/>
            <xsl:with-param name="docid"  select="$docid"/>
            <xsl:with-param name="toc"    select="$toc"/>
            <xsl:with-param name="node"   select="."/>
            <xsl:with-param name="toclevel" select="$toclevel + 1"/>
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="name($node)='tocentry' and name($src-rootnode)='webpage'"/>
      <xsl:when test="name($node)='tocentry' and $isancestor='1'">
                          <!-- no children so look at document -->
        <xsl:for-each select="$src-rootnode/section 
                               |$src-rootnode/appendix
                               |$src-rootnode/article
                               |$src-rootnode/bibliography
                               |$src-rootnode/book
                               |$src-rootnode/chapter
                               |$src-rootnode/colophon
                               |$src-rootnode/glossary
                               |$src-rootnode/index
                               |$src-rootnode/part
                               |$src-rootnode/preface
                               |$src-rootnode/refentry
                               |$src-rootnode/reference
                               |$src-rootnode/sect1
                               |$src-rootnode/sect2
                               |$src-rootnode/sect3
                               |$src-rootnode/sect4
                               |$src-rootnode/sect5
                               |$src-rootnode/section
                               |$src-rootnode/set
                               |$src-rootnode/setindex">
          <xsl:call-template name="build-navtoc">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="targetdepth" select="$targetdepth"/>
            <xsl:with-param name="docid"  select="$docid"/>
            <xsl:with-param name="toc"    select="$toc"/>
            <xsl:with-param name="node"   select="."/> 
            <xsl:with-param name="toclevel" select="$toclevel + 1"/>
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>        <!-- search immediate children in chunked doc -->
        <xsl:for-each select= "$node/set| $node/book| $node/part| $node/preface| $node/chapter| $node/appendix| $node/article| $node/reference| $node/refentry| $node/bibliography| $node/colophon| $node/index| $node/setindex| $node/section | $node/sect1 | $node/sect2 | $node/sect3 | $node/sect4 | $node/sect5 | $node/sect6" >
          <xsl:call-template name="build-navtoc">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="targetdepth" select="$targetdepth"/>
            <xsl:with-param name="docid"  select="$docid"/>
            <xsl:with-param name="toc"    select="$toc"/>
            <xsl:with-param name="node"   select="."/>
            <xsl:with-param name="toclevel" select="$toclevel + 1"/>
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

</xsl:template>


<xsl:template name="insert.spacers">
  <xsl:param name="count" select="0"/>
  <xsl:param name="relpath"/>
  <xsl:if test="$count>0">
    <xsl:choose>
      <xsl:when test="$nav.graphics != 0">
        <img src="{$relpath}{$toc.spacer.image}" alt="{$toc.spacer.text}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$toc.spacer.text"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="insert.spacers">
      <xsl:with-param name="count" select="$count - 1"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="toc|tocentry|notoc" mode="toc-rel-path">
  <xsl:call-template name="toc-rel-path"/>
</xsl:template>


<xsl:template name="toc-rel-path">
  <xsl:param name="pageid" select="@id"/>
  <xsl:variable name="entry" select="$autolayout//*[@id=$pageid]"/>
  <xsl:variable name="filename" select="concat($entry/@dir,$entry/@filename)"/>

  <xsl:variable name="slash-count">
    <xsl:call-template name="toc-directory-depth">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth">
    <xsl:choose>
      <xsl:when test="starts-with($filename, '/')">
        <xsl:value-of select="$slash-count - 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$slash-count"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:value-of select="$filename"/>
    <xsl:text> depth=</xsl:text>
    <xsl:value-of select="$depth"/>
  </xsl:message>
-->

  <xsl:if test="$depth > 0">
    <xsl:call-template name="copy-string">
      <xsl:with-param name="string">../</xsl:with-param>
      <xsl:with-param name="count" select="$depth"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="toc-directory-depth">
  <xsl:param name="filename"></xsl:param>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test='contains($filename,"/")'>
      <xsl:call-template name="toc-directory-depth">
        <xsl:with-param name="filename"
                        select="substring-after($filename,'/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
</xsl:stylesheet>
 -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/website-common.xsl
 |       
 |
 -->

<!--
<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version='1.0'>
  -->

<!-- ********************************************************************

     This file is part of the WebSite distribution.
     See ../README or http://nwalsh.com/website/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- must wait until xml catalogs are working...-->
<!-- <xsl:import href="https://cdn.docbook.org/release/xsl/current/html/docbook.xsl"/> -->

<!--
<xsl:include href="website-tabular.xsl"/>
<xsl:include href="website-tabular-toc.xsl"/>
  -->

<!--
<xsl:import href="xbel.xsl"/>
<xsl:include href="VERSION"/>
<xsl:include href="head.xsl"/>
<xsl:include href="rss.xsl"/>
<xsl:include href="olink.xsl"/>
  -->
<!--
<xsl:preserve-space elements="*"/>
<xsl:strip-space elements="website webpage"/>

<xsl:output method="html"
            indent="no"/>
 -->

<!-- ==================================================================== -->

<!-- admon.graphic had a name collision with the admon.xsl templates
     might have to fix this ...
  -->
<!--
<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="root-rel-path"/>
  <xsl:value-of select="$admon.graphics.path"/>
  <xsl:choose>
    <xsl:when test="name($node)='note'">note</xsl:when>
    <xsl:when test="name($node)='warning'">warning</xsl:when>
    <xsl:when test="name($node)='caution'">caution</xsl:when>
    <xsl:when test="name($node)='tip'">tip</xsl:when>
    <xsl:when test="name($node)='important'">important</xsl:when>
    <xsl:otherwise>note</xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$admon.graphics.extension"/>
</xsl:template>

<doc:template name="admon.graphic">
<refpurpose>Select appropriate admonition graphic</refpurpose>
<refdescription>
<para>Selects the appropriate admonition graphic file and returns the
fully qualified path to it.</para>
</refdescription>
<refparam>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The source node to use for the purpose of selection. It should
be one of the admonition elements (<sgmltag>note</sgmltag>,
<sgmltag>warning</sgmltag>, etc.). The default node is the context
node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparam>
<refreturns>
<para>The fully qualified path to the admonition graphic. If the
<varname>node</varname> is not an admonition element, the
  <quote>note</quote> graphic is returned.</para>
</refreturns>
</doc:template>
 -->

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="allpages.banner"/>

<!-- ==================================================================== -->

<xsl:template name="webpage.table.footer"/>


<xsl:template name="webpage.footer">
  <xsl:param name="doc" select="."/>
  <xsl:param name="page" select="."/>
  <xsl:param name="prev" />
  <xsl:param name="next" />
  <xsl:variable name="footers" select="$doc/config[@param='footer']
                                       |$doc/config[@param='footlink']
                                       |$autolayout/config[@param='footer']
                                       |$autolayout/config[@param='footlink']"/>

  <xsl:variable name="tocentry" select="$autolayout//*[@id = $doc/@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]
                                   | $autolayout//toc[1])[last()]"/>

  <xsl:variable name="feedback">
    <xsl:choose>
      <xsl:when test="$doc/config[@param='feedback.href']">
        <xsl:value-of select="($doc/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/config[@param='feedback.href']">
        <xsl:value-of select="($autolayout/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$feedback.href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <div class="navfoot">
    <xsl:if test="$footer.hr != 0"><hr/></xsl:if>
    <table width="100%" border="0" summary="Footer navigation">
      <tr>
        <td width="33%" align="left">
          <span class="footdate">
            <xsl:call-template name="rcsdate.format">
              <xsl:with-param name="rcsdate"
                              select="$doc/config[@param='rcsdate']/@value"/>
            </xsl:call-template>
          </span>
        </td>
        <td width="34%" align="center">
          <xsl:choose>
            <xsl:when test="not($toc)">
              <xsl:message>
                <xsl:text>Cannot determine TOC for </xsl:text>
                <xsl:value-of select="$doc/@id"/>
              </xsl:message>
            </xsl:when>
            <xsl:when test="$toc/@id = $doc/@id">
              <!-- nop; this is the home page -->
            </xsl:when>
            <xsl:otherwise>
              <span class="foothome">
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="homeuri"/>
                  </xsl:attribute>
                  <xsl:text>Home</xsl:text>
                </a>
                <xsl:if test="$footers">
                  <xsl:text> | </xsl:text>
                </xsl:if>
              </span>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:apply-templates select="$footers" mode="footer.link.mode"/>
        </td>
        <td width="33%" align="right">
            <xsl:choose>
              <xsl:when test="$feedback != ''">
                <span class="footfeed">
                  <a>
                    <xsl:choose>
                      <xsl:when test="$feedback.with.ids != 0">
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                          <xsl:value-of select="$page/@id"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$feedback.link.text"/>
                  </a>
                </span>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
        </td>
      </tr>
      <tr>
        <td colspan="3" align="right">
          <span class="footcopy">
            <xsl:choose>
              <xsl:when test="$doc/head/copyright">
                <xsl:apply-templates select="$doc/head/copyright" mode="footer.mode"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="footer.mode"
                                     select="$autolayout/copyright"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </td>
      </tr>
      <xsl:if test="$sequential.links != 0">
        <tr>
          <td align="left" valign="top">
            <xsl:choose>
              <xsl:when test="$prev != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="href"> 
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$prev"/>
                      <xsl:with-param name="context" select="$page"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="linktext" select="'Prev'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="ptoc">
                  <xsl:call-template name="prev.page">
                    <xsl:with-param name="page" select="$doc"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$ptoc != ''">
                    <xsl:call-template name="link.to.page">
                      <xsl:with-param name="frompage" select="$tocentry"/>
                      <xsl:with-param name="page" select="$autolayout//*[$ptoc=@id]"/>
                      <xsl:with-param name="linktext" select="'Prev'"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>&#160;</td>
          <td align="right" valign="top">
            <xsl:choose>
              <xsl:when test="$next != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="href"> 
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$next"/>
                      <xsl:with-param name="context" select="$page"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="linktext" select="'Next'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="ntoc">
                  <xsl:call-template name="next.page">
                    <xsl:with-param name="page" select="$doc"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$ntoc != ''">
                    <xsl:call-template name="link.to.page">
                      <xsl:with-param name="frompage" select="$tocentry"/>
                      <xsl:with-param name="page" select="$autolayout//*[$ntoc=@id]"/>
                      <xsl:with-param name="linktext" select="'Next'"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
    </table>
  </div>
</xsl:template>

<xsl:template name="rcsdate.format">
  <xsl:param name="rcsdate" select="./config[@param='rcsdate']/@value"/>
  <xsl:value-of select="$rcsdate"/>
</xsl:template>

<xsl:template match="config" mode="footer.link.mode">
  <span class="foothome">
    <xsl:if test="position() &gt; 1">
      <xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@param='footlink'">
        <xsl:variable name="id" select="@value"/>
        <xsl:variable name="tocentry"
                      select="$autolayout//*[@id=$id]"/>
        <xsl:if test="count($tocentry) != 1">
          <xsl:message>
            <xsl:text>Footlink to </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> does not id a unique page.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:variable name="dir">
          <xsl:choose>
            <xsl:when test="starts-with($tocentry/@dir, '/')">
              <xsl:value-of select="substring($tocentry/@dir, 2)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$tocentry/@dir"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="root-rel-path"/>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@value}">
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="homeuri">
  <xsl:param name="page" select="ancestor-or-self::webpage | / "/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>
  <xsl:variable name="toc" select="$tocentry/ancestor::toc"/>
  <xsl:variable name="first-toc"
                select="$autolayout/toc[1]"/>

  <xsl:call-template name="root-rel-path"/>

  <xsl:choose>
    <xsl:when test="$toc">
      <xsl:choose>
        <xsl:when test="starts-with($toc/@dir, '/')">
          <xsl:value-of select="substring($toc/@dir, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$toc/@dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$filename-prefix"/>
      <xsl:value-of select="$toc/@filename"/>
      <xsl:value-of select="$html.ext"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="starts-with($first-toc/@dir, '/')">
          <xsl:value-of select="substring($first-toc/@dir, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$first-toc/@dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$filename-prefix"/>
      <xsl:value-of select="$first-toc/@filename"/>
      <xsl:value-of select="$html.ext"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="copyright" mode="footer.mode">
  <span class="{name(.)}">
    <xsl:call-template name="gentext.element.name"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="year" mode="footer.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="holder" mode="footer.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="year" mode="footer.mode">
  <xsl:apply-templates/>
  <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
</xsl:template>
<!--
<xsl:template match="year[position()=last()]" mode="footer.mode">
  <xsl:apply-templates/>
</xsl:template>
 -->

<xsl:template match="holder" mode="footer.mode">
  <xsl:apply-templates/>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="directory-depth">
  <xsl:param name="dir"></xsl:param>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test='contains($dir,"/")'>
      <xsl:call-template name="directory-depth">
        <xsl:with-param name="dir" select="substring-after($dir,'/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test='$dir=""'>
          <xsl:value-of select="$count"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$count + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="root-rel-path">
  <xsl:param name="page" select="ancestor-or-self::*[position()=last()]"/>
  <xsl:variable name="tocentry" select="$autolayout//*[$page/@id = @id]"/>
  <xsl:apply-templates select="$tocentry" mode="toc-rel-path"/>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="footnote" mode="footnote.number">
  <xsl:choose>
    <xsl:when test="ancestor::table|ancestor::informaltable">
      <xsl:number level="any" from="table|informaltable" format="a"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="any" from="webpage| /" format="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


  <!-- 
    gunna have to fix this. it used to be just process.footnotes
    but there was a name collision
    -->
<xsl:template name="process.webpage.footnotes">
  <!-- we're only interested in footnotes that occur on this page, not
       on descendants of this page (which will be similarly processed) -->
  <xsl:variable name="thispage"
                select="(ancestor-or-self::*)[last()]"/>
  <!--  
                select="ancestor-or-self::webpage"/>
     -->
  <xsl:variable name="footnotes"
                select=".//footnote[(ancestor-or-self::*)[last()]=$thispage]"/>
  <xsl:variable name="table.footnotes"
                select=".//table//footnote[(ancestor-or-self::*)[last()]=$thispage]
                        |.//informaltable//footnote[(ancestor-or-self::*)[last()]
                                    =$thispage]"/>

  <!-- Only bother to do this if there's at least one non-table footnote -->
  <xsl:if test="count($footnotes)>count($table.footnotes)">
    <div class="footnotes">
      <hr width="100" align="left"/>
      <xsl:apply-templates select="$footnotes" mode="process.footnote.mode"/>
    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="@*" mode="copy">
  <xsl:attribute name="{local-name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="html:*">
  <xsl:element name="{local-name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('php')">
  <xsl:processing-instruction name="php">
    <xsl:value-of select="."/>
  </xsl:processing-instruction>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="rddl:*" xmlns:rddl='http://www.rddl.org/'>
  <xsl:element name="{name(.)}">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="section[@rddl]" xmlns:rddl='http://www.rddl.org/'>
  <xsl:variable name="rddl" select="id(@rddl)"/>
  <xsl:choose>
    <xsl:when test="local-name($rddl) != 'resource'">
      <xsl:message>
        <xsl:text>Warning: section rddl isn't an rddl:resource: </xsl:text>
        <xsl:value-of select="@rddl"/>
      </xsl:message>
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{name($rddl)}">
        <xsl:apply-templates select="$rddl/@*" mode="copy"/>
        <xsl:apply-imports/>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="page.uri">
  <xsl:param name="href" select="''"/>
  <xsl:param name="page" select="ancestor-or-self::tocentry"/>
  <xsl:param name="filename" select="''"/>
  <xsl:param name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$page/@id"/>
    </xsl:call-template>
  </xsl:param>

<!--
  <xsl:message><xsl:value-of select="$page/@id"/>: <xsl:value-of select="$relpath"/></xsl:message>
-->

  <xsl:variable name="html.href">
    <xsl:choose>
      <xsl:when test="$href != ''">
        <xsl:value-of select="$href"/>
      </xsl:when>
      <xsl:otherwise>

        <xsl:variable name="dir">
          <xsl:choose>
            <xsl:when test="starts-with($page/@dir, '/')">
              <xsl:value-of select="substring($page/@dir, 2)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$page/@dir"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="concat($relpath,$dir,$filename-prefix)"/>
        <xsl:choose>
          <xsl:when test="$filename != ''">
            <xsl:value-of select="$filename"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$page/@filename"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$html.ext"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>HTML file is: </xsl:text>
    <xsl:value-of select="$html.href"/>
  </xsl:message>
  -->


  <xsl:value-of select="$html.href"/>
</xsl:template>

<xsl:template name="local.relative.path">
  <xsl:param name="frompage"/>
  <xsl:param name="page" select="ancestor-or-self::tocentry"/>

    <xsl:choose>
      <xsl:when test="$frompage">
        <xsl:call-template name="toc-rel-path">
          <xsl:with-param name="pageid" select="$frompage/@id"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="toc-rel-path">
          <xsl:with-param name="pageid" select="$page/@id"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="link.to.page">
  <xsl:param name="href" select="''"/>
  <xsl:param name="filename" select="''"/>
  <xsl:param name="frompage"/>
  <xsl:param name="page" select="ancestor-or-self::tocentry"/>
  <xsl:param name="relpath">
    <xsl:call-template name="local.relative.path">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="frompage" select="$frompage"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:param name="linktext" select="'???'"/>
  <xsl:param name="framelink"  select="''"/>
  <a>
    <xsl:attribute name="href">
      <xsl:choose> 
        <xsl:when test="$href != ''">
          <xsl:value-of select="$href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="page.uri">
            <xsl:with-param name="href" select="$href"/>
            <xsl:with-param name="page" select="$page"/>
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose> 
    </xsl:attribute>
    <xsl:if test="$framelink != ''">
       <xsl:attribute name="target">
         <xsl:value-of select="'$framelink'"/>
       </xsl:attribute>
    </xsl:if>
    <xsl:if test="$page/summary">
      <xsl:attribute name="title">
        <xsl:value-of select="$page/summary"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$linktext"/>
  </a>
</xsl:template>

<xsl:template name="next.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>
  <xsl:variable name="next-following"
                select="$tocentry/following::tocentry[1]"/>
  <xsl:variable name="next-child"
                select="$tocentry/descendant::tocentry[1]"/>

  <xsl:variable name="nextid">
    <xsl:choose>
      <xsl:when test="$next-child">
        <xsl:value-of select="$next-child/@id"/>
      </xsl:when>
      <xsl:when test="$next-following">
        <xsl:value-of select="$next-following/@id"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$nextid"/>
</xsl:template>

<xsl:template name="prev.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>
  <xsl:variable name="prev-ancestor"
                select="($tocentry/ancestor::tocentry
                        |$tocentry/ancestor::toc)[last()]"/>
  <xsl:variable name="prev-sibling"
                select="$tocentry/preceding-sibling::tocentry[1]"/>

  <xsl:variable name="previd">
    <xsl:choose>
      <xsl:when test="$prev-sibling">
        <xsl:value-of select="$prev-sibling/@id"/>
      </xsl:when>
      <xsl:when test="$prev-ancestor">
        <xsl:value-of select="$prev-ancestor/@id"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$previd"/>
</xsl:template>

<xsl:template name="top.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>

  <xsl:value-of select="$tocentry/ancestor::toc/@id"/>
</xsl:template>

<xsl:template name="up.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>

  <xsl:choose>
    <xsl:when test="$tocentry/ancestor::tocentry">
      <xsl:value-of select="$tocentry/ancestor::tocentry[1]/@id"/>
    </xsl:when>
    <xsl:when test="$tocentry/ancestor::toc">
      <xsl:value-of select="$tocentry/ancestor::toc[1]/@id"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="first.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>

  <xsl:value-of select="$tocentry/preceding-sibling::tocentry[last()]/@id"/>
</xsl:template>

<xsl:template name="last.page">
  <!-- xsl:param name="page" select="ancestor-or-self::webpage"/ -->
  <xsl:param name="page" select="(ancestor-or-self::*)[last()]"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>

  <xsl:variable name="prev-sibling"
                select="$tocentry/preceding-sibling::tocentry[1]"/>

  <xsl:value-of select="$tocentry/following-sibling::tocentry[last()]/@id"/>
</xsl:template>

<xsl:template match="autolayout" mode="collect.targets">
  <targetset>
    <xsl:apply-templates mode="olink.mode"/>
  </targetset>
</xsl:template>

<xsl:template match="toc|tocentry|notoc" mode="olink.mode">
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="tocentry"/>
    <xsl:apply-templates select="tocentry" mode="olink.mode"/>
</xsl:template>


<xsl:template name="tocentry" mode="olink.mode">
  <xsl:choose>
    <xsl:when test="@href">
      <!-- no op -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not(@page)">
        <xsl:message terminate="yes">
          <xsl:text>All toc entries must have a page attribute.</xsl:text>
        </xsl:message>
      </xsl:if>
    
      <xsl:variable name="page" select="document(@page,.)"/>
    
      <xsl:if test="not($page/*[1]/@id)">
        <xsl:message terminate="yes">
          <xsl:value-of select="@page"/>
          <xsl:text>: missing ID.</xsl:text>
        </xsl:message>
      </xsl:if>
    
      <xsl:variable name="id" select="$page/*[1]/@id"/>
    
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="@filename">
            <xsl:value-of select="@filename"/>
          </xsl:when>
          <xsl:when test="/layout/config[@param='default-filename']">
            <xsl:value-of select="(/layout/config[@param='default-filename'])[1]/@value"/>
          </xsl:when>
          <xsl:otherwise>index.html</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <xsl:variable name="dir" select="@dir"/>
    
      <xsl:if test="$filename = ''">
        <xsl:message terminate="yes">
          <xsl:value-of select="@page"/>
          <xsl:text>: missing filename.</xsl:text>
        </xsl:message>
      </xsl:if>
    
    <!--
      <xsl:message>
        <xsl:value-of select="@page"/>
        <xsl:text>: </xsl:text>
        <xsl:if test="$dir != ''">
          <xsl:value-of select="$dir"/>
        </xsl:if>
        <xsl:value-of select="$filename"/>
      </xsl:message>
    -->
    
      <document>
        <xsl:attribute name="targetdoc">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
        <xsl:attribute name="baseuri">
          <xsl:value-of select="$filename"/>
        </xsl:attribute>
        <xsl:if test="$dir != ''">
          <xsl:attribute name="dir">
            <xsl:value-of select="$dir"/>
          </xsl:attribute>
        </xsl:if>
    
        <xsl:apply-templates select="$page" mode="olink.mode"/>
      </document>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="webpage" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="webpage" mode="xref-to" >
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
  <!-- FIXME: What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="webpage" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select=".//head/title"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>


<!--
<xsl:param name="local.l10n.xml" select="document('')" />

<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"> 
  <l:l10n language="en">
    <l:context name="title">
      <l:template name="webpage" text="%t"/>
    </l:context>
    <l:context name="xref">
      <l:template name="webpage" text="%t"/>
    </l:context>
  </l:l10n>
</l:i18n>

</xsl:stylesheet>
  -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/website-head.xsl
 |
 -->

<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
 -->

<xsl:template match="head" mode="head.mode">
  <xsl:variable name="nodes" select="*"/>
  <head>
    <meta name="generator" content="DocBook HTML XSL Stylesheet V{$VERSION}"/>
    <xsl:if test="$html.stylesheet != ''">
      <link rel="stylesheet" href="{$html.stylesheet}" type="text/css">
	<xsl:if test="$html.stylesheet.type != ''">
	  <xsl:attribute name="type">
	    <xsl:value-of select="$html.stylesheet.type"/>
	  </xsl:attribute>
	</xsl:if>
      </link>
    </xsl:if>

    <xsl:variable name="thisid" select="((ancestor-or-self::*)[last()])/@id"/>
    <xsl:variable name="thisrelpath">
      <xsl:apply-templates select="$autolayout//*[@id=$thisid]" mode="toc-rel-path"/>
    </xsl:variable>

    <xsl:variable name="topid">
      <xsl:call-template name="top.page"/>
    </xsl:variable>

    <xsl:if test="$topid != ''">
      <link rel="home">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$topid]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$topid]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:variable name="upid">
      <xsl:call-template name="up.page"/>
    </xsl:variable>

    <xsl:if test="$upid != ''">
      <link rel="up">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$upid]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$upid]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:variable name="previd">
      <xsl:call-template name="prev.page"/>
    </xsl:variable>

    <xsl:if test="$previd != ''">
      <link rel="previous">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$previd]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$previd]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:variable name="nextid">
      <xsl:call-template name="next.page"/>
    </xsl:variable>

    <xsl:if test="$nextid != ''">
      <link rel="next">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$nextid]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$nextid]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:variable name="firstid">
      <xsl:call-template name="first.page"/>
    </xsl:variable>

    <xsl:if test="$firstid != ''">
      <link rel="first">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$firstid]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$firstid]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:variable name="lastid">
      <xsl:call-template name="last.page"/>
    </xsl:variable>

    <xsl:if test="$lastid != ''">
      <link rel="last">
        <xsl:attribute name="href">
          <xsl:call-template name="page.uri">
            <xsl:with-param name="page" select="$autolayout//*[@id=$lastid]"/>
            <xsl:with-param name="relpath" select="$thisrelpath"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$autolayout//*[@id=$lastid]/title"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:apply-templates select="$autolayout/style
                                 |$autolayout/script
                                 |$autolayout/headlink"
                         mode="head.mode">
      <xsl:with-param name="webpage" select="ancestor::webpage"/>
    </xsl:apply-templates>
    <xsl:apply-templates mode="head.mode"/>
    <xsl:call-template name="user.head.content">
      <xsl:with-param name="node" select="ancestor::webpage"/>
    </xsl:call-template>
  </head>
</xsl:template>

<xsl:template match="title" mode="head.mode">
  <title><xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="titleabbrev" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="subtitle" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="summary" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="base" mode="head.mode">
  <base href="{@href}">
    <xsl:if test="@target">
      <xsl:attribute name="target">
        <xsl:value-of select="@target"/>
      </xsl:attribute>
    </xsl:if>
  </base>
</xsl:template>

<xsl:template match="keywords" mode="head.mode">
  <meta name="keyword" content="{.}"/>
</xsl:template>

<xsl:template match="copyright" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="author" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="edition" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="meta" mode="head.mode">
  <xsl:choose>
    <xsl:when test="@http-equiv">
      <meta http-equiv="{@http-equiv}" content="{@content}"/>
    </xsl:when>
    <xsl:otherwise>
      <meta name="{@name}" content="{@content}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="script" mode="head.mode">
  <script>
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:attribute name="language">
	  <xsl:value-of select="@language"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="language">JavaScript</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@type">
	<xsl:attribute name="type">
	  <xsl:value-of select="@type"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="type">text/javascript</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </script>
</xsl:template>

<xsl:template match="script[@src]" mode="head.mode" priority="2">
  <xsl:param name="webpage" select="ancestor::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="page" select="$webpage"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="language">
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>JavaScript</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="@type">
	<xsl:value-of select="@type"/>
      </xsl:when>
      <xsl:otherwise>text/javascript</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <script src="{$relpath}{@src}" language="{$language}" type="{$type}"/>
</xsl:template>

<xsl:template match="style" mode="head.mode">
  <style>
    <xsl:if test="@type">
      <xsl:attribute name="type">
	<xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates/>

  </style>
</xsl:template>

<xsl:template match="style[@src]" mode="head.mode" priority="2">
  <xsl:param name="webpage" select="ancestor::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="page" select="$webpage"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="starts-with(@src, '/')">
      <link rel="stylesheet" href="{@src}">
        <xsl:if test="@type">
          <xsl:attribute name="type">
            <xsl:value-of select="@type"/>
          </xsl:attribute>
        </xsl:if>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <link rel="stylesheet" href="{$relpath}{@src}">
        <xsl:if test="@type">
          <xsl:attribute name="type">
            <xsl:value-of select="@type"/>
          </xsl:attribute>
        </xsl:if>
      </link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="headlink" mode="head.mode">
  <link>
    <xsl:copy-of select="@*"/>
  </link>
</xsl:template>

<xsl:template match="abstract" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="revhistory" mode="head.mode">
  <!--nop-->
</xsl:template>

<xsl:template match="rddl:*" mode="head.mode"
              xmlns:rddl='http://www.rddl.org/'>
  <!--nop-->
</xsl:template>


<!--
</xsl:stylesheet>
 -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/website.xsl
 |         handles webpage documents and all chunkable sections
 |          by building a tabular navigation TOC (tabular.page.construction).
 |
 -->

<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  -->

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.


     ******************************************************************** -->

<!-- ==================================================================== -->

<!--
<xsl:include href="website-common.xsl"/>
<xsl:include href="website-head.xsl"/>
 -->


<!-- ==================================================================== -->

<xsl:template match="config">
  <!-- nop -->
</xsl:template>

<xsl:template name="user.preroot">
  <!-- nop -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="head">
  <!-- nop -->
</xsl:template>

<xsl:template match="head/title" mode="title.mode">
  <h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="title" mode="title.mode">
  <h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="head/title">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="webpage" mode="title.markup">
  <xsl:apply-templates select="head/title"/>
</xsl:template>

<xsl:template match="webpage">
  <xsl:call-template name="process-chunk">
    <xsl:with-param name="content">
      <xsl:apply-templates select="child::*[not(name() = head) and not(name() = config)]"/>
    </xsl:with-param >
  </xsl:call-template>
</xsl:template>


<!-- called by chunk-element-content -->

<xsl:template name="tabular.page.construction">

  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>


  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
   </xsl:variable>


  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="page" select="$src-rootnode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="tocentry" select="$autolayout//*[$src-rootnode-id=@id]"/>

  <xsl:variable name="toc" 
      select="($tocentry/ancestor-or-self::toc | $autolayout//toc[1])[last()]"/>

    <!-- assume context node and content param are the same !!! -->
  <xsl:variable name="srcdepth" select="count(ancestor::*)"/>
  <xsl:variable name="autolaydepth" select="count($tocentry/ancestor::*[toc|tocentry])"/>

  <xsl:variable name="targetdepth">
    <xsl:value-of select="$autolaydepth + $srcdepth "/> 
  </xsl:variable>

<xsl:message>
    <xsl:text>Chunking </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:value-of select="$nav.context"/>
    <xsl:text> (id=</xsl:text>
    <xsl:value-of select="$id"/>
    <xsl:text>,relpath=</xsl:text>
    <xsl:value-of select="$relpath"/>
    <xsl:text>,tocentryid=</xsl:text>
    <xsl:value-of select="$tocentry/@id"/>
    <xsl:text>,tocid=</xsl:text>
    <xsl:value-of select="$toc/@id"/>
    <xsl:text>,targetdepth=</xsl:text>
    <xsl:value-of select="$targetdepth"/>
    <xsl:text>,srcdepth=</xsl:text>
    <xsl:value-of select="$srcdepth"/>
    <xsl:text>,autolaydepth=</xsl:text>
    <xsl:value-of select="$autolaydepth"/>
    <xsl:text>)</xsl:text>
  </xsl:message>

      <xsl:call-template name="user.preroot"/>

      <html>

        <xsl:choose>
          <xsl:when test="ancestor-or-self::webpage">
            <xsl:apply-templates select="ancestor-or-self::webpage/head" mode="head.mode"/>
            <xsl:apply-templates select="ancestor-or-self::webpage/config" mode="head.mode"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="html.head">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

        <body class="tabular">
          <xsl:call-template name="body.attributes"/>
          <a class="skiplink" href="#startcontent">Skip over navigation</a>
    
          <div class="{name(.)}">
            <a name="{$id}"></a>
            <xsl:call-template name="allpages.banner">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>
            
    
            <table xsl:use-attribute-sets="table.properties" border="0">
              <xsl:if test="$nav.table.summary!=''">
                <xsl:attribute name="summary">
                  <xsl:value-of select="$nav.table.summary"/>
                </xsl:attribute>
              </xsl:if>
              <tr>
                <td xsl:use-attribute-sets="table.navigation.cell.properties">
                <img src="{$relpath}{$table.spacer.image}" alt=" " width="1" height="1"/></td>
                <xsl:call-template name="hspacer"/>
                <td class="webpage-body" rowspan="2" xsl:use-attribute-sets="table.body.cell.properties">
                  <xsl:if test="$navbodywidth != ''">
                    <xsl:attribute name="width">
                      <xsl:value-of select="$navbodywidth"/>
                    </xsl:attribute>
                  </xsl:if>
    
                  <xsl:if test="$autolayout//toc[1]/@id = $id or 
                               (not($autolayout) and . = /*[1])">
                    <table border="0" summary="home page extra headers"
                           cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <xsl:call-template name="home.navhead.cell"/>
                        <xsl:call-template name="home.navhead.upperright.cell"/>
                      </tr>
                    </table>
                    <xsl:call-template name="home.navhead.separator"/>
                  </xsl:if>

                  <a name="startcontent"></a>
                  <xsl:if test="($autolayout//toc[1]/@id != $id
                                or $suppress.homepage.title = 0 ) and 
                                ancestor-or-self::webpage">
                    <xsl:apply-templates select="./head/title| ./title" 
                              mode="title.mode"/>
                  </xsl:if>

                  <!-- Add content to the page -->
                  <xsl:copy-of select="$content"/>

                  <xsl:call-template name="process.footnotes"/>
                  <br/>
                </td>
              </tr>
              <tr>
                <td xsl:use-attribute-sets="table.navigation.cell.properties">
                  <xsl:if test="$navtocwidth != ''">
                    <xsl:attribute name="width">
                      <xsl:choose>
                        <xsl:when test="$src-rootnode/config[@param='navtocwidth']/@value[. != '']">
                          <xsl:value-of select="$src-rootnode/config[@param='navtocwidth']/@value"/>
                        </xsl:when>
                        <xsl:when test="$autolayout/config[@param='navtocwidth']/@value[. != '']">
                          <xsl:value-of select="$autolayout/config[@param='navtocwidth']/@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$navtocwidth"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </xsl:if>

                  <xsl:choose>
                    <xsl:when test="( $toc != '' and $nav.context != 'toc') or 
                                     (not($autolayout) ) ">
                      <p class="navtoc">

                        <xsl:choose>
                          <xsl:when test="$toc/@id = $id">     <!-- website homepage --> 
                            <xsl:variable name="homebanner"
                                select="$autolayout/config[@param='homebanner-tabular'][1]"/>

                            <img align="left" border="0">
                              <xsl:attribute name="src">
                                <xsl:value-of select="$relpath"/>
                                <xsl:value-of select="$homebanner/@value"/>
                              </xsl:attribute>
                              <xsl:attribute name="alt">
                                <xsl:value-of select="$homebanner/@altval"/>
                              </xsl:attribute>
                            </img>
                          </xsl:when>

                          <xsl:when test="not($autolayout) and . = /*[1]"> <!--  book cover --> 
                            <img align="left" border="0">
                              <xsl:attribute name="src">
                                <xsl:value-of select="$relpath"/>
                                <xsl:value-of select="$tabular.chunk.root.banner.filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="alt">
                                <xsl:value-of select="$tabular.chunk.root.banner.altval"/>
                              </xsl:attribute>
                            </img>
                          </xsl:when>

                          <xsl:when test="not($autolayout) or $autolayout=''">   <!-- shortcut to book cover --> 
                            <a>
                              <xsl:attribute name="href">
                                <xsl:value-of select="concat($relpath,$filename-prefix)"/>
                                <xsl:call-template name="href.target">
                                  <xsl:with-param name="object" select="/*[1]"/>
                                </xsl:call-template>
                              </xsl:attribute>
                              <img align="left" border="0">
                                <xsl:attribute name="src">
                                  <xsl:value-of select="$relpath"/>
                                  <xsl:value-of select="$tabular.chunk.toroot.banner.filename"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                  <xsl:value-of select="$tabular.chunk.toroot.banner.altval"/>
                                </xsl:attribute>
                              </img>
                            </a>
                          </xsl:when>

                          <xsl:otherwise>             <!-- shortcut to website homepage --> 
                            <xsl:variable name="banner"
                               select="$autolayout/config[@param='banner-tabular'][1]"/>
                            <a href="{$relpath}{$toc/@dir}{$filename-prefix}{$toc/@filename}{$html.ext}">
                              <img align="left" border="0">
                                <xsl:attribute name="src">
                                  <xsl:value-of select="$relpath"/>
                                  <xsl:value-of select="$banner/@value"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                  <xsl:value-of select="$banner/@altval"/>
                                </xsl:attribute>
                              </img>
                            </a>
                          </xsl:otherwise>
                        </xsl:choose>

                        <br clear="all"/>
                        <br/>

                        <xsl:variable name="context" select="."/>
                        <xsl:choose>
                          <xsl:when test="$toc != '' ">
                            <xsl:for-each select="$toc/tocentry"> 
                              <xsl:call-template name="build-navtoc">
                                <xsl:with-param name="context"  select="$context"/>
                                <xsl:with-param name="targetdepth" select="$targetdepth"/>
                                <xsl:with-param name="docid"  select="$src-rootnode-id"/>
                                <xsl:with-param name="toc"    select="$toc"/>
                                <xsl:with-param name="node"   select="."/>
                                <xsl:with-param name="toclevel" select="1"/>
                                <xsl:with-param name="relpath">
                                  <xsl:call-template name="toc-rel-path"> <!-- reads from $autolayout -->
                                    <!-- current page id -->
                                    <xsl:with-param name="pageid" select="$src-rootnode-id"/>  
                                  </xsl:call-template>
                                </xsl:with-param>
                              </xsl:call-template>
                            </xsl:for-each>
                          </xsl:when>
  
                          <xsl:otherwise>
                                 <!-- Just the chunkable children. Skip the root node. -->
                            <xsl:for-each select="/*[1]/*">  
                              <xsl:variable name="ischunk">
                                <xsl:call-template name="chunk"/>
                              </xsl:variable>
                              <xsl:if test="$ischunk !='0'">
                                <xsl:call-template name="build-navtoc">
                                  <xsl:with-param name="context"  select="$context"/>
                                  <xsl:with-param name="targetdepth" select="$targetdepth"/>
                                  <xsl:with-param name="docid"  select="$src-rootnode-id"/>
                                  <!-- xsl:with-param name="toc"    select=""/ -->
                                  <xsl:with-param name="node"   select="."/>
                                  <xsl:with-param name="toclevel" select="1"/>
                                  <xsl:with-param name="relpath">
                                    <xsl:call-template name="toc-rel-path"> 
                                               <!-- reads from $autolayout -->
                                      <!-- current page id -->
                                      <xsl:with-param name="pageid" select="$src-rootnode-id"/>  
                                    </xsl:call-template>
                                  </xsl:with-param>
                                </xsl:call-template>
                              </xsl:if>
                            </xsl:for-each> 
                          </xsl:otherwise>

                        </xsl:choose>

                        <br/>
                      </p>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </td>
                <xsl:call-template name="hspacer"/>
              </tr>
              <xsl:call-template name="webpage.table.footer"/>
            </table>
            <a name="pagefooter"></a>

            <xsl:call-template name="webpage.footer">
              <xsl:with-param name="doc" select="$src-rootnode"/> 
              <xsl:with-param name="page" select="."/> 
              <xsl:with-param name="prev" select="$prev"/> 
              <xsl:with-param name="next" select="$next"/> 
            </xsl:call-template>
          </div>

        </body>
      </html>

</xsl:template>


<!-- ==================================================================== -->

<xsl:template name="target.doc.dir.path">
  <xsl:param name="doc.node" select="."/>
  <xsl:value-of select="$base.dir"/>  
  <xsl:if test="$autolayout != ''">
    <xsl:choose>       <!-- in the autolayout document -->
      <xsl:when test="name($doc.node)='toc' or name($doc.node)='tocentry'">
        <xsl:apply-templates select="$autolayout//*[@id = $doc.node/@id]" 
            mode="calculate-webpage-dir"/>
      </xsl:when>
      <xsl:otherwise>  <!-- in a particular document -->
        <xsl:variable name="doc.root" select="$doc.node/ancestor-or-self::*[last()]"/>
        <xsl:if test="count($autolayout//*[@id = $doc.root/@id]) = 0" >
          <xsl:message terminate="yes">
<xsl:text>Fatal mismatch between document rootnode ID and corresponding autolayout ID</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="$autolayout//*[@id = $doc.root/@id]" 
            mode="calculate-webpage-dir"/>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="calculate-webpage-dir">
  <xsl:choose>
    <xsl:when test="@dir">
      <!-- if there's a directory, use it -->
      <xsl:choose>
        <xsl:when test="starts-with(@dir, '/')">
          <!-- if the directory on this begins with a "/", we're done... -->
          <xsl:value-of select="substring-after(@dir, '/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@dir"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="calculate-webpage-dir"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
</xsl:stylesheet>
 -->
<!--  ======================================================================  -->
<!--
 |
 |file:  html/admon.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="root-rel-path">
    <xsl:with-param name="page" select="$node/ancestor-or-self::*[position()=last()]"/>
  </xsl:call-template>
  <xsl:value-of select="$admon.graphics.path"/>
  <xsl:choose>
    <xsl:when test="local-name($node)='note'">note</xsl:when>
    <xsl:when test="local-name($node)='warning'">warning</xsl:when>
    <xsl:when test="local-name($node)='caution'">caution</xsl:when>
    <xsl:when test="local-name($node)='tip'">tip</xsl:when>
    <xsl:when test="local-name($node)='important'">important</xsl:when>
    <xsl:otherwise>note</xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$admon.graphics.extension"/>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/autotoc.xsl
 |       (remove simplesect)
 -->

<xsl:template match="preface|chapter|appendix|article" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="section|sect1|refentry
                                         |glossary|bibliography|index
                                         |bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/chunk-code.xsl
 |    (replace base.dir" with "$target.doc.dir.path")
 |     chunk bibliography children of part
 |     chunk to within "-ive" chunk.section.depth of section leaves
 |               - only works for -1.
 |
 -->

<xsl:template name="process-chunk">
  <xsl:param name="prev" select="."/>
  <xsl:param name="next" select="."/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:variable name="chunkfn">
    <xsl:if test="$ischunk='1'"> <!-- compute the filename or use the id -->
      <xsl:apply-templates mode="chunk-filename" select="."/>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="$ischunk='0'">
    <xsl:message>
      <xsl:text>Error </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text> is not a chunk!</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="target.doc.dir.path">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="."/>
    </xsl:call-template>
  </xsl:variable>

    <xsl:message>
      <xsl:text>dumping to path: </xsl:text>
      <xsl:value-of select="$target.doc.dir.path"/>
      <xsl:text> with filename: </xsl:text>
      <xsl:value-of select="$chunkfn"/>
    </xsl:message>

  <xsl:variable name="filename">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir" select="$target.doc.dir.path"/>
      <xsl:with-param name="base.name" select="$chunkfn"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="content">
      <xsl:call-template name="chunk-element-content">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>
<xsl:template name="chunk-first-section-with-parent">
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <!-- These xpath expressions are really hairy. The trick is to pick sections -->
  <!-- that are not first children and are not the children of first children -->

  <!-- Break these variables into pieces to work around
       http://nagoya.apache.org/bugzilla/show_bug.cgi?id=6063 -->

  <xsl:variable name="prev-v1"
     select="(ancestor::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |ancestor::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |ancestor::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::section[$chunk.section.depth &gt; count(ancestor::section)
                                and not(ancestor::section[not(preceding-sibling::section)])][1])[last()]"/>

  <xsl:variable name="prev-v2"
     select="(preceding::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |preceding::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |preceding::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])][1])[last()]"/>

  <xsl:variable name="prev"
    select="(preceding::book[1]
             |preceding::preface[1]
             |preceding::chapter[1]
             |preceding::appendix[1]
             |preceding::part[1]
             |preceding::reference[1]
             |preceding::refentry[1]
             |preceding::colophon[1]
             |preceding::article[1]
             |preceding::bibliography[parent::article or parent::book or parent::part][1]
             |preceding::glossary[parent::article or parent::book][1]
             |preceding::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |preceding::setindex[$generate.index != 0][1]
             |ancestor::set
             |ancestor::book[1]
             |ancestor::preface[1]
             |ancestor::chapter[1]
             |ancestor::appendix[1]
             |ancestor::part[1]
             |ancestor::reference[1]
             |ancestor::article[1]
             |$prev-v1
             |$prev-v2)[last()]"/>

  <xsl:variable name="next-v1"
    select="(following::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |following::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |following::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])][1])[1]"/>

  <xsl:variable name="next-v2"
    select="(descendant::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |descendant::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |descendant::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])])[1]"/>

  <xsl:variable name="next"
    select="(following::book[1]
             |following::preface[1]
             |following::chapter[1]
             |following::appendix[1]
             |following::part[1]
             |following::reference[1]
             |following::refentry[1]
             |following::colophon[1]
             |following::bibliography[parent::article or parent::book or parent::part][1]
             |following::glossary[parent::article or parent::book][1]
             |following::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |following::article[1]
             |following::setindex[$generate.index != 0][1]
             |descendant::book[1]
             |descendant::preface[1]
             |descendant::chapter[1]
             |descendant::appendix[1]
             |descendant::article[1]
             |descendant::bibliography[parent::article or parent::book or parent::part][1]
             |descendant::glossary[parent::article or parent::book][1]
             |descendant::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |descendant::colophon[1]
             |descendant::setindex[$generate.index != 0][1]
             |descendant::part[1]
             |descendant::reference[1]
             |descendant::refentry[1]
             |$next-v1
             |$next-v2)[1]"/>

  <xsl:call-template name="process-chunk">
    <xsl:with-param name="prev" select="$prev"/>
    <xsl:with-param name="next" select="$next"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>
<xsl:template name="chunk-all-sections">
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:variable name="sub-section-depth">
    <xsl:if test="$chunk.section.depth &lt; 0">
      <xsl:apply-templates select="." mode="sub-section-depth"/>
    </xsl:if>
  </xsl:variable>


  <xsl:variable name="prev-v1"
    select="(preceding::sect1[$chunk.section.depth &gt; 0][1]
             |preceding::sect2[$chunk.section.depth &gt; 1][1]
             |preceding::sect3[$chunk.section.depth &gt; 2][1]
             |preceding::sect4[$chunk.section.depth &gt; 3][1]
             |preceding::sect5[$chunk.section.depth &gt; 4][1]
             |preceding::section[$chunk.section.depth &gt; count(ancestor::section)][1]
             |preceding::section[$chunk.section.depth &lt; 0 and 
                                 (- count(descendant::section)) &lt;= $chunk.section.depth ][1]
                                                              )[last()]"/>
       <!--
                                  $sub-section-depth &lt;= $chunk.section.depth][1]
         -->

  <xsl:variable name="prev-v2"
    select="(ancestor::sect1[$chunk.section.depth &gt; 0][1]
             |ancestor::sect2[$chunk.section.depth &gt; 1][1]
             |ancestor::sect3[$chunk.section.depth &gt; 2][1]
             |ancestor::sect4[$chunk.section.depth &gt; 3][1]
             |ancestor::sect5[$chunk.section.depth &gt; 4][1]
             |ancestor::section[$chunk.section.depth &gt; count(ancestor::section)][1]
             |ancestor::section[$chunk.section.depth &lt; 0 and 
                                 (- count(descendant::section)) &lt;= $chunk.section.depth ][1]
                                                             )[last()]"/>
       <!--
                                  $sub-section-depth &lt;= $chunk.section.depth][1]
         -->

  <xsl:variable name="prev"
    select="(preceding::book[1]
             |preceding::preface[1]
             |preceding::chapter[1]
             |preceding::appendix[1]
             |preceding::part[1]
             |preceding::reference[1]
             |preceding::refentry[1]
             |preceding::colophon[1]
             |preceding::article[1]
             |preceding::bibliography[parent::article or parent::book or parent::part ][1]
             |preceding::glossary[parent::article or parent::book][1]
             |preceding::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |preceding::setindex[$generate.index != 0][1]
             |ancestor::set
             |ancestor::book[1]
             |ancestor::preface[1]
             |ancestor::chapter[1]
             |ancestor::appendix[1]
             |ancestor::part[1]
             |ancestor::reference[1]
             |ancestor::article[1]
             |$prev-v1
             |$prev-v2)[last()]"/>

  <xsl:variable name="next-v1"
    select="(following::sect1[$chunk.section.depth &gt; 0][1]
             |following::sect2[$chunk.section.depth &gt; 1][1]
             |following::sect3[$chunk.section.depth &gt; 2][1]
             |following::sect4[$chunk.section.depth &gt; 3][1]
             |following::sect5[$chunk.section.depth &gt; 4][1]
             |following::section[$chunk.section.depth &gt; count(ancestor::section)][1]
             |following::section[$chunk.section.depth &lt; 0 and 
                                 (- count(descendant::section)) &lt;= $chunk.section.depth ][1]
                                                              )[1]"/>  
       <!--
                                 (- count(descendant::section)) &lt;= $chunk.section.depth ][1]
                                  $sub-section-depth &lt; $chunk.section.depth][1]
         -->

  <xsl:variable name="next-v2"
    select="(descendant::sect1[$chunk.section.depth &gt; 0][1]
             |descendant::sect2[$chunk.section.depth &gt; 1][1]
             |descendant::sect3[$chunk.section.depth &gt; 2][1]
             |descendant::sect4[$chunk.section.depth &gt; 3][1]
             |descendant::sect5[$chunk.section.depth &gt; 4][1]
             |descendant::section[$chunk.section.depth 
                                  &gt; count(ancestor::section)][1]
             |descendant::section[$chunk.section.depth &lt; 0 and 
                                 (- count(descendant::section)) &lt;= $chunk.section.depth ][1]
                                                              )[1]"/>  
       <!--
                                  $sub-section-depth &lt;= $chunk.section.depth][1]
                                  $sub-section-depth &lt; $chunk.section.depth][1]
         -->

  <xsl:variable name="next"
    select="(following::book[1]
             |following::preface[1]
             |following::chapter[1]
             |following::appendix[1]
             |following::part[1]
             |following::reference[1]
             |following::refentry[1]
             |following::colophon[1]
             |following::bibliography[parent::article or parent::book or parent::part][1]
             |following::glossary[parent::article or parent::book][1]
             |following::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |following::article[1]
             |following::setindex[$generate.index != 0][1]
             |descendant::book[1]
             |descendant::preface[1]
             |descendant::chapter[1]
             |descendant::appendix[1]
             |descendant::article[1]
             |descendant::bibliography[parent::article or parent::book or parent::part][1]
             |descendant::glossary[parent::article or parent::book][1]
             |descendant::index[$generate.index != 0]
	                       [parent::article or parent::book][1]
             |descendant::colophon[1]
             |descendant::setindex[$generate.index != 0][1]
             |descendant::part[1]
             |descendant::reference[1]
             |descendant::refentry[1]
             |$next-v1
             |$next-v2)[1]"/>

  <xsl:message>
   <xsl:text> chunking with next: </xsl:text>
   <xsl:value-of select="name($next)"/> 
   <xsl:text> with id: </xsl:text>
   <xsl:value-of select="$next/@id"/> 
   <xsl:text>  and subsection depth: </xsl:text>
   <xsl:value-of select="$sub-section-depth"/> 
  </xsl:message>

  <xsl:call-template name="process-chunk">
    <xsl:with-param name="prev" select="$prev"/>
    <xsl:with-param name="next" select="$next"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="set|book|part|preface|chapter|appendix
                     |article
                     |reference|refentry
                     |book/glossary|article/glossary|part/glossary
                     |book/bibliography|article/bibliography|part/bibliography
                     |colophon">
  <xsl:choose>
    <xsl:when test="$onechunk != 0 and parent::*">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-chunk-element"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="make.lots">
  <xsl:param name="toc.params" select="''"/>
  <xsl:param name="toc"/>

  <xsl:variable name="lots">
    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:copy-of select="$toc"/>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'figure')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'figure'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'figure'"/>
                <xsl:with-param name="nodes" select=".//figure"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'figure'"/>
            <xsl:with-param name="nodes" select=".//figure"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'table')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'table'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'table'"/>
                <xsl:with-param name="nodes" select=".//table"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'table'"/>
            <xsl:with-param name="nodes" select=".//table"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'example')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'example'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'example'"/>
                <xsl:with-param name="nodes" select=".//example"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'example'"/>
            <xsl:with-param name="nodes" select=".//example"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'equation')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'equation'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'equation'"/>
                <xsl:with-param name="nodes" select=".//equation"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'equation'"/>
            <xsl:with-param name="nodes" select=".//equation"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'procedure')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'procedure'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'procedure'"/>
                <xsl:with-param name="nodes" select=".//procedure[title]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'procedure'"/>
            <xsl:with-param name="nodes" select=".//procedure[title]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="target.doc.dir.path">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="string($lots) != ''">
    <xsl:choose>
      <xsl:when test="$chunk.tocs.and.lots != 0 and not(parent::*)">
        <xsl:call-template name="write.chunk">

          <xsl:with-param name="filename">
            <xsl:call-template name="make-relative-filename">
              <xsl:with-param name="base.dir" select="$target.doc.dir.path"/>
              <xsl:with-param name="base.name">
                <xsl:call-template name="dbhtml-dir"/>
                <xsl:apply-templates select="." mode="recursive-chunk-filename">
                  <xsl:with-param name="recursive" select="true()"/>
                </xsl:apply-templates>
                <xsl:text>-toc</xsl:text>
                <xsl:value-of select="$html.ext"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="content">
            <xsl:call-template name="chunk-element-content">
              <xsl:with-param name="prev" select="/foo"/>
              <xsl:with-param name="next" select="/foo"/>
              <xsl:with-param name="nav.context" select="'toc'"/>
              <xsl:with-param name="content">
                <h1>
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </h1>
                <xsl:copy-of select="$lots"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="quiet" select="$chunk.quietly"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$lots"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>



<xsl:template name="make.lot.chunk">
  <xsl:param name="type" select="''"/>
  <xsl:param name="lot"/>

  <xsl:variable name="target.doc.dir.path">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="string($lot) != ''">
    <xsl:variable name="filename">
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.dir" select="$target.doc.dir.path"/>
        <xsl:with-param name="base.name">
          <xsl:call-template name="dbhtml-dir"/>
          <xsl:value-of select="$type"/>
          <xsl:text>-toc</xsl:text>
          <xsl:value-of select="$html.ext"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="href">
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.name">
          <xsl:call-template name="dbhtml-dir"/>
          <xsl:value-of select="$type"/>
          <xsl:text>-toc</xsl:text>
          <xsl:value-of select="$html.ext"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="content">
        <xsl:call-template name="chunk-element-content">
          <xsl:with-param name="prev" select="/foo"/>
          <xsl:with-param name="next" select="/foo"/>
          <xsl:with-param name="nav.context" select="'toc'"/>
          <xsl:with-param name="content">
            <xsl:copy-of select="$lot"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
    </xsl:call-template>
    <!-- And output a link to this file -->
    <div>
      <xsl:attribute name="class">
        <xsl:text>ListofTitles</xsl:text>
      </xsl:attribute>
      <a href="{$href}">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">
            <xsl:choose>
              <xsl:when test="$type='table'">ListofTables</xsl:when>
              <xsl:when test="$type='figure'">ListofFigures</xsl:when>
              <xsl:when test="$type='equation'">ListofEquations</xsl:when>
              <xsl:when test="$type='example'">ListofExamples</xsl:when>
              <xsl:when test="$type='procedure'">ListofProcedures</xsl:when>
              <xsl:otherwise>ListofUnknown</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </a>
    </div>
  </xsl:if>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/chunk-common.xsl
 |        chunk a part/bibliography
 |        dont chunk a webpage
 |        reuse  href.target.uri  within obscure website build-navtoc instances
 |        conditionally ($website != '') hijack chunk-element-content 
 |           to create a website webpage  by calling  "tabular.page.construction"
 -->

<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <!-- returns 1 if $node is a chunk -->

  <!-- ==================================================================== -->
  <!-- What's a chunk?
       

       The root element
       webpage       (but no subsections)
       appendix
       article
       bibliography  in article or book or part
       book
       chapter
       colophon
       glossary      in article or book
       index         in article or book
       part
       preface
       refentry
       reference
       sect{1,2,3,4,5}  if position()>1 && depth < chunk.section.depth
       section          if position()>1 && depth < chunk.section.depth
       set
       setindex
                                                                            -->
  <!-- ==================================================================== -->

<!--
  <xsl:message>
    <xsl:text>chunk: </xsl:text>
    <xsl:value-of select="name($node)"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$node/@id"/>
    <xsl:text>)</xsl:text>
    <xsl:text> csd: </xsl:text>
    <xsl:value-of select="$chunk.section.depth"/>
    <xsl:text> cfs: </xsl:text>
    <xsl:value-of select="$chunk.first.sections"/>
    <xsl:text> ps: </xsl:text>
    <xsl:value-of select="count($node/parent::section)"/>
    <xsl:text> prs: </xsl:text>
    <xsl:value-of select="count($node/preceding-sibling::section)"/>
  </xsl:message>
-->

  <xsl:variable name="sub-section-depth">
    <xsl:if test="section and $chunk.section.depth &lt; 0">
      <xsl:apply-templates select="." mode="sub-section-depth"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not($node/parent::*)">1</xsl:when>

    <xsl:when test="$node/ancestor::webpage"> <xsl:text>0</xsl:text> </xsl:when>

    <xsl:when test="section and $chunk.section.depth &lt; 0 and 
             $sub-section-depth &lt;= $chunk.section.depth">
        <xsl:text>1</xsl:text>
    </xsl:when>

    <xsl:when test="local-name($node) = 'sect1'
                    and $chunk.section.depth &gt;= 1
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect1) &gt; 0)">
      <xsl:text>1</xsl:text>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect2'
                    and $chunk.section.depth &gt;= 2
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect2) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect3'
                    and $chunk.section.depth &gt;= 3
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect3) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect4'
                    and $chunk.section.depth &gt;= 4
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect4) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect5'
                    and $chunk.section.depth &gt;= 5
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect5) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'section'
                    and $chunk.section.depth &gt;= count($node/ancestor::section)+1
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::section) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="name($node)='preface'">1</xsl:when>
    <xsl:when test="name($node)='chapter'">1</xsl:when>
    <xsl:when test="name($node)='appendix'">1</xsl:when>
    <xsl:when test="name($node)='article'">1</xsl:when>
    <xsl:when test="name($node)='part'">1</xsl:when>
    <xsl:when test="name($node)='reference'">1</xsl:when>
    <xsl:when test="name($node)='refentry'">1</xsl:when>
    <xsl:when test="name($node)='index' and $generate.index != 0
                    and (   name($node/parent::*) = 'article'
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='bibliography'
                    and (   name($node/parent::*) = 'article'
                         or name($node/parent::*) = 'part'
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='glossary'
                    and (   name($node/parent::*) = 'article'
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='colophon'">1</xsl:when>
    <xsl:when test="name($node)='book'">1</xsl:when>
    <xsl:when test="name($node)='set'">1</xsl:when>
    <xsl:when test="name($node)='setindex'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="*" mode="sub-section-depth">
  <xsl:param name="sub-sect-depth" select="'0'"/>

  <xsl:variable name="current-depth" select="count(ancestor-or-self::*)"/>

  <xsl:variable name="deepest-sub-sect">
    <xsl:for-each select="//section"> 
      <xsl:sort select="count(ancestor-or-self::*)" order="descending"/>
      <xsl:if test="position()=1">
        <xsl:value-of select="count(ancestor-or-self::*)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <!-- negative for -ive $chunk.section.depth comparisons -->
  <xsl:value-of select="$current-depth - $deepest-sub-sect"/> 
 
</xsl:template>


<xsl:template match="*" mode="recursive-chunk-filename">
  <xsl:param name="recursive" select="false()"/>

  <!-- returns the filename of a chunk -->
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:variable name="dbhtml-filename">
    <xsl:call-template name="dbhtml-filename"/>
  </xsl:variable>

  <xsl:variable name="thisid" select="@id"/>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$dbhtml-filename != ''">
        <xsl:value-of select="$dbhtml-filename"/>
      </xsl:when>
      <!-- if this is the root element and autolayout filename is defined  -->
      <xsl:when test="not(parent::*) and $autolayout and $thisid != '' and 
                       $autolayout//*[@id= $thisid]/@filename != '' ">
        <xsl:value-of select="$autolayout//*[@id= $thisid]/@filename"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <!-- if this is the root element, use the root.filename -->
      <xsl:when test="not(parent::*) and $root.filename !=''">
        <xsl:value-of select="$root.filename"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <!-- if there's no dbhtml filename, and if we're to use IDs as -->
      <!-- filenames, then use the ID to generate the filename. -->
      <xsl:when test="@id and $use.id.as.filename != 0">
        <xsl:value-of select="@id"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk='0'">
      <!-- if called on something that isn't a chunk, walk up... -->
      <xsl:choose>
        <xsl:when test="count(parent::*)>0">
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="$recursive"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- unless there is no up, in which case return "" -->
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not($recursive) and $filename != ''">
      <!-- if this chunk has an explicit name, use it -->
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <xsl:when test="self::set">
      <xsl:value-of select="$root.filename"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::book">
      <xsl:text>bk</xsl:text>
      <xsl:number level="any" format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::article">
      <xsl:if test="/set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ar</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::preface">
      <xsl:if test="/set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>pr</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::chapter">
      <xsl:if test="/set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ch</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::appendix">
      <xsl:if test="/set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ap</xsl:text>
      <xsl:number level="any" format="a" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::part">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>pt</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::reference">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>rn</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::refentry">
      <xsl:choose>
        <xsl:when test="parent::reference">
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>re</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::colophon">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>co</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::sect1
                    or self::sect2
                    or self::sect3
                    or self::sect4
                    or self::sect5
                    or self::section">
      <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
        <xsl:with-param name="recursive" select="true()"/>
      </xsl:apply-templates>
      <xsl:text>s</xsl:text>
      <xsl:number format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::bibliography">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>bi</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::glossary">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>go</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::index">
      <xsl:choose>
        <xsl:when test="/set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>ix</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::setindex">
      <xsl:text>si</xsl:text>
      <xsl:number level="any" format="01" from="set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text>chunk-filename-error-</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:number level="any" format="01" from="set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="href.target.uri">
  <xsl:param name="object" select="."/>

  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk">
      <xsl:with-param name="node" select="$object"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$object/ancestor-or-self::autolayout and 
                $object/@href != '' and $object/@filename !='' " >
        <!-- actually I think this will never happen -->
    <xsl:message terminate="yes">
      <xsl:text>Cannot have @href and @filename in one autolayout//tocentry.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
      <!-- actually I think this will never happen -->
    <xsl:when test="$object/ancestor-or-self::autolayout and $object/@href !='' " >
         <xsl:value-of select="$object/@href"/>
    </xsl:when>
    <xsl:otherwise>

      <!-- prepend entire document path -->
      <xsl:call-template name="target.doc.dir.path">
        <xsl:with-param name="doc.node" select="$object"/>
      </xsl:call-template>
      <!-- dir/file separator ??? -->
      <!-- ahead of chunked filename -->

      <xsl:choose>
        <xsl:when test="$object/ancestor-or-self::autolayout and 
               (name($object)='toc' or name($object)='tocentry')">
          <!-- reading the autolayout file --> 
          <xsl:choose>       
            <xsl:when test="$object/@filename !='' " >
              <xsl:value-of select="$filename-prefix"/>
              <xsl:value-of select="$object/@filename"/>
              <xsl:value-of select="$html.ext"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$filename-prefix"/>
              <xsl:text>index</xsl:text>
              <xsl:value-of select="$html.ext"/>
            </xsl:otherwise>
          </xsl:choose>  
        </xsl:when>

        <xsl:otherwise>        
          <!--  build chunked filename from sections --> 
          <xsl:apply-templates mode="chunk-filename" select="$object"/>

          <xsl:if test="$ischunk='0'"> <!--  append subdoc section reference --> 
            <xsl:text>#</xsl:text>
            <xsl:call-template name="object.id">
              <xsl:with-param name="object" select="$object"/>
            </xsl:call-template>
          </xsl:if>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="chunk-element-content">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>


  <xsl:choose>

    <xsl:when test="$website != ''" >   <!--   its a tabular style webpage -->
       <xsl:call-template name="tabular.page.construction">
         <xsl:with-param name="prev" select="$prev"/>
         <xsl:with-param name="next" select="$next"/>
         <xsl:with-param name="nav.context" select="$nav.context"/>
         <xsl:with-param name="content" select="$content"/>
       </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="user.preroot"/>

      <html>
        <xsl:call-template name="html.head">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
        </xsl:call-template>
    
        <body>
          <xsl:call-template name="body.attributes"/>
          <xsl:call-template name="user.header.navigation"/>
    
          <xsl:call-template name="header.navigation">
	    <xsl:with-param name="prev" select="$prev"/>
	    <xsl:with-param name="next" select="$next"/>
	    <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
    
          <xsl:call-template name="user.header.content"/>
    
          <xsl:copy-of select="$content"/>
    
          <xsl:call-template name="user.footer.content"/>
    
          <xsl:call-template name="footer.navigation">
	    <xsl:with-param name="prev" select="$prev"/>
	    <xsl:with-param name="next" select="$next"/>
	    <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
    
          <xsl:call-template name="user.footer.navigation"/>
        </body>
      </html>
    </xsl:otherwise> 
  </xsl:choose>

</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/graphics.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template name="longdesc.uri">
  <xsl:param name="mediaobject" select="."/>

  <xsl:if test="$html.longdesc">
    <xsl:if test="$mediaobject/textobject[not(phrase)]">
      <xsl:variable name="image-id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$mediaobject"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="dbhtml.dir">
        <xsl:call-template name="dbhtml-dir"/>
      </xsl:variable>

      <xsl:variable name="target.doc.dir.path">
        <xsl:call-template name="target.doc.dir.path">
          <xsl:with-param name="doc.node" select="."/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir">
            <xsl:choose>
              <xsl:when test="$dbhtml.dir != ''">
                <xsl:value-of select="$dbhtml.dir"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$target.doc.dir.path"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="base.name"
                          select="concat('ld-',$image-id,$html.ext)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select="$filename"/>
    </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template name="longdesc.link">
  <xsl:param name="longdesc.uri" select="''"/>

  <xsl:variable name="target.doc.dir.path">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="this.uri">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir" select="$target.doc.dir.path"/>
      <xsl:with-param name="base.name">
        <xsl:call-template name="href.target.uri"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="href.to">
    <xsl:call-template name="trim.common.uri.paths">
      <xsl:with-param name="uriA" select="$longdesc.uri"/>
      <xsl:with-param name="uriB" select="$this.uri"/>
      <xsl:with-param name="return" select="'A'"/>
    </xsl:call-template>
  </xsl:variable>

  <div class="longdesc-link" align="right">
    <br clear="all"/>
    <span class="longdesc-link">
      <xsl:text>[</xsl:text>
      <a href="{$href.to}" target="longdesc">D</a>
      <xsl:text>]</xsl:text>
    </span>
  </div>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/html.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template name="href.target.with.base.dir">
  <xsl:param name="object" select="."/>
  <xsl:if test="$manifest.in.base.dir = 0">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="$object"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:call-template name="href.target">
    <xsl:with-param name="object" select="$object"/>
  </xsl:call-template>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/titlepage.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template match="legalnotice" mode="titlepage.mode">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$generate.legalnotice.link != 0">
      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir">
	    <xsl:call-template name="target.doc.dir.path">
              <xsl:with-param name="doc.node" select="."/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="base.name" select="concat('ln-',$id,$html.ext)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="title">
        <xsl:apply-templates select="." mode="title.markup"/>
      </xsl:variable>

      <a href="{concat('ln-',$id,$html.ext)}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content"/>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <div class="{local-name(.)}">
                <xsl:apply-templates mode="titlepage.mode"/>
              </div>
            </body>
          </html>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <div class="{local-name(.)}">
        <a name="{$id}"/>
        <xsl:apply-templates mode="titlepage.mode"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/xref.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |       and added the framelink="_blank" (linktarget) modifications for  
 |       autolayout.xml that were posted by Denis Bradford 
 |
 -->

<xsl:template match="ulink" name="ulink">
  <xsl:param name="linktarget">
    <xsl:choose>
      <xsl:when test="@role !=''">
        <xsl:value-of select="@role"/>
      </xsl:when>

      <xsl:when test="$ulink.target != ''">
        <xsl:value-of select="$ulink.target"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="link">
    <a>
      <xsl:if test="@id">
        <xsl:attribute name="name">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
      <xsl:if test="$linktarget != ''">
        <xsl:attribute name="target">
          <xsl:value-of select="$linktarget"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="olink" name="olink">
  <xsl:param name="context" select="/"/>

  <xsl:call-template name="anchor"/>

  <xsl:variable name="localinfo" select="@localinfo"/>

  <xsl:choose>
    <!-- olinks resolved by stylesheet and target database -->
    <xsl:when test="@targetdoc or @targetptr" >
      <xsl:variable name="targetdoc.att" select="@targetdoc"/>
      <xsl:variable name="targetptr.att" select="@targetptr"/>

      <xsl:variable name="olink.lang">
        <xsl:call-template name="l10n.language">
          <xsl:with-param name="xref-context" select="true()"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database.filename">
        <xsl:call-template name="select.target.database">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="context" select="$context"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database" 
          select="document($target.database.filename,$context)"/>
    
      <xsl:if test="$olink.debug != 0">
        <xsl:message>
          <xsl:text>Olink debug: root element of target.database '</xsl:text>
          <xsl:value-of select="$target.database.filename"/>
	  <xsl:text>' is '</xsl:text>
          <xsl:value-of select="local-name($target.database/*[1])"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
      </xsl:if>
    
      <xsl:variable name="olink.key">
        <xsl:call-template name="select.olink.key">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="href">
        <xsl:call-template name="make.olink.href">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="hottext">
        <xsl:call-template name="olink.hottext">
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="olink.docname.citation">
        <xsl:call-template name="olink.document.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="olink.page.citation">
        <xsl:call-template name="olink.page.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$href != ''">
          <a href="{$href}">
            <xsl:copy-of select="$hottext"/>
          </a>
          <xsl:copy-of select="$olink.page.citation"/>
          <xsl:copy-of select="$olink.docname.citation"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$hottext"/>
          <xsl:copy-of select="$olink.page.citation"/>
          <xsl:copy-of select="$olink.docname.citation"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:when>

    <!-- Or use old olink mechanism -->
    <xsl:otherwise>
      <xsl:variable name="href">
        <xsl:choose>
          <xsl:when test="@linkmode">
            <!-- use the linkmode to get the base URI, use localinfo as fragid -->
            <xsl:variable name="modespec" select="key('id',@linkmode)"/>
            <xsl:if test="count($modespec) != 1
                          or local-name($modespec) != 'modespec'">
              <xsl:message>Warning: olink linkmode pointer is wrong.</xsl:message>
            </xsl:if>
            <xsl:value-of select="$modespec"/>
            <xsl:if test="@localinfo">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="@localinfo"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="@type = 'href'">
            <xsl:call-template name="olink.outline">
              <xsl:with-param name="outline.base.uri"
                              select="unparsed-entity-uri(@targetdocent)"/>
              <xsl:with-param name="localinfo" select="@localinfo"/>
              <xsl:with-param name="return" select="'href'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$olink.resolver"/>
            <xsl:text>?</xsl:text>
            <xsl:value-of select="$olink.sysid"/>
            <xsl:value-of select="unparsed-entity-uri(@targetdocent)"/>
            <!-- XSL gives no access to the public identifier (grumble...) -->
            <xsl:if test="@localinfo">
              <xsl:text>&amp;</xsl:text>
              <xsl:value-of select="$olink.fragid"/>
              <xsl:value-of select="@localinfo"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <xsl:choose>
        <xsl:when test="$href != ''">
          <a href="{$href}">
            <xsl:call-template name="olink.hottext"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="olink.hottext"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  html/manifest.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template name="generate.manifest">
  <xsl:param name="node" select="/"/>
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:call-template name="target.doc.dir.path">
          <xsl:with-param name="doc.node" select="$node"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="$manifest"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:apply-templates select="$node" mode="enumerate-files"/>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="set|book|part|preface|chapter|appendix
                     |article
                     |reference|refentry
                     |sect1|sect2|sect3|sect4|sect5
                     |section
                     |book/glossary|article/glossary
                     |book/bibliography|article/bibliography
                     |book/index|article/index
                     |colophon"
              mode="enumerate-files">
  <xsl:variable name="ischunk"><xsl:call-template name="chunk"/></xsl:variable>
  <xsl:if test="$ischunk='1'">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir">
        <xsl:if test="$manifest.in.base.dir = 0">
          <xsl:call-template name="target.doc.dir.path">
            <xsl:with-param name="doc.node" select="."/>
          </xsl:call-template>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="base.name">
        <xsl:apply-templates mode="chunk-filename" select="."/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="*" mode="enumerate-files"/>
</xsl:template>

<xsl:template match="legalnotice" mode="enumerate-files">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:if test="$generate.legalnotice.link != 0">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir">
        <xsl:if test="$manifest.in.base.dir = 0">
          <xsl:call-template name="target.doc.dir.path">
            <xsl:with-param name="doc.node" select="."/>
          </xsl:call-template>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="base.name" select="concat('ln-',$id,$html.ext)"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  common/olink.xsl
 |       supply a context for processing olinks within temporary result trees
 |       AND  importantly, set current.docid to the document rootnode ID
 |            rather than setting it manually from the command line.
 -->

<xsl:template name="select.target.database">
  <xsl:param name="targetdoc.att" select="''"/>
  <xsl:param name="targetptr.att" select="''"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="context" select="/"/>

  <!-- This selection can be customized if needed -->
  <xsl:variable name="target.database.filename" 
      select="$target.database.document"/>

  <xsl:variable name="target.database" 
      select="document($target.database.filename,$context)"/>

  <xsl:choose>
    <!-- Was the database document parameter not set? -->
    <xsl:when test="$target.database.document = ''">
      <xsl:message>
        <xsl:text>Olinks not processed: must specify a </xsl:text>
        <xsl:text>$target.database.document parameter&#10;</xsl:text>
        <xsl:text>when using olinks with targetdoc </xsl:text>
        <xsl:text>and targetptr attributes.</xsl:text>
      </xsl:message>
    </xsl:when>
    <!-- Did it not open? Should be a targetset element -->
    <xsl:when test="not($target.database/*)">
      <xsl:message>
        <xsl:text>Olink error: could not open target database '</xsl:text>
        <xsl:value-of select="$target.database.filename"/>
        <xsl:text>'.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$target.database.filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Returns the complete olink href value if found -->
<xsl:template name="make.olink.href">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="target.database"/>

  <xsl:param name="current.docid"> <!-- ddb -->
    <xsl:value-of select="$src-rootnode-id"/>
  </xsl:param>

  <xsl:if test="$olink.key != ''">
    <xsl:variable name="target.href" >
      <xsl:for-each select="$target.database" >
        <xsl:value-of select="key('targetptr-key', $olink.key)/@href" />
      </xsl:for-each>
    </xsl:variable>
  
    <xsl:variable name="targetdoc">
      <xsl:value-of select="substring-before($olink.key, '/')"/>
    </xsl:variable>
  
    <!-- Does the target database use a sitemap? -->
    <xsl:variable name="use.sitemap">
      <xsl:choose>
        <xsl:when test="$target.database//sitemap">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
  
    <!-- Get the baseuri for this targetptr -->
    <xsl:variable name="baseuri" >
      <xsl:choose>
        <!-- Does the database use a sitemap? -->
        <xsl:when test="$use.sitemap != 0" >
          <xsl:choose>
            <!-- Was current.docid parameter set? -->
            <xsl:when test="$current.docid != ''">
              <!-- Was it found in the database? -->
              <xsl:variable name="currentdoc.key" >
                <xsl:for-each select="$target.database" >
                  <xsl:value-of select="key('targetdoc-key',
                                        $current.docid)/@targetdoc" />
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$currentdoc.key != ''">
                  <xsl:for-each select="$target.database" >
                    <xsl:call-template name="targetpath" >
                      <xsl:with-param name="dirnode" 
                          select="key('targetdoc-key', $current.docid)/parent::dir"/>
                      <xsl:with-param name="targetdoc" select="$targetdoc"/>
                    </xsl:call-template>
                  </xsl:for-each >
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>
                    <xsl:text>Olink error: cannot compute relative </xsl:text>
                    <xsl:text>sitemap path because $current.docid '</xsl:text>
                    <xsl:value-of select="$current.docid"/>
                    <xsl:text>' not found in target database.</xsl:text>
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Olink warning: cannot compute relative </xsl:text>
                <xsl:text>sitemap path without $current.docid parameter</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose> 
          <!-- In either case, add baseuri from its document entry-->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key', $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''" >
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:when>
        <!-- No database sitemap in use -->
        <xsl:otherwise>
          <!-- Just use any baseuri from its document entry -->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key', $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''" >
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <!-- Form the href information -->
    <xsl:if test="$olink.base.uri != ''">
      <xsl:value-of select="$olink.base.uri"/>
    </xsl:if>
    <xsl:if test="$baseuri != ''">
      <xsl:value-of select="$baseuri"/>
      <xsl:if test="substring($target.href,1,1) != '#'">
        <!--xsl:text>/</xsl:text-->
      </xsl:if>
    </xsl:if>
    <!-- optionally turn off frag for PDF references -->
    <xsl:if test="not($insert.olink.pdf.frag = 0 and
          translate(substring($baseuri, string-length($baseuri) - 3),
                    'PDF', 'pdf') = '.pdf'
          and starts-with($target.href, '#') )">
      <xsl:value-of select="$target.href"/>
    </xsl:if>
  </xsl:if>
</xsl:template>
<!--  ======================================================================  -->
<!--
 |
 |file:  common/en.xml
 |
 -->

<!--
<l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" 
              language="en" 
              english-language-name="English">
 -->

<xsl:param name="local.l10n.xml" select="document('')" />

<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">

   <l:context name="title">
      <l:template name="abstract" text="%t"/>
      <l:template name="answer" text="%t"/>
      <l:template name="appendix" text="Appendix&#160;%n.&#160;%t"/>
      <l:template name="article" text="%t"/>
      <l:template name="authorblurb" text="%t"/>
      <l:template name="bibliodiv" text="%t"/>
      <l:template name="biblioentry" text="%t"/>
      <l:template name="bibliography" text="%t"/>
      <l:template name="bibliolist" text="%t"/>
      <l:template name="bibliomixed" text="%t"/>
      <l:template name="bibliomset" text="%t"/>
      <l:template name="biblioset" text="%t"/>
      <l:template name="blockquote" text="%t"/>
      <l:template name="book" text="%t"/>
      <l:template name="calloutlist" text="%t"/>
      <l:template name="caution" text="%t"/>
      <l:template name="chapter" text="Chapter&#160;%n.&#160;%t"/>
      <l:template name="colophon" text="%t"/>
      <l:template name="dedication" text="%t"/>
      <l:template name="equation" text="Equation&#160;%n.&#160;%t"/>
      <l:template name="example" text="Example&#160;%n.&#160;%t"/>
      <l:template name="figure" text="Figure&#160;%n.&#160;%t"/>
      <l:template name="formalpara" text="%t"/>
      <l:template name="glossary" text="%t"/>
      <l:template name="glossdiv" text="%t"/>
      <l:template name="glosslist" text="%t"/>
      <l:template name="glossentry" text="%t"/>
      <l:template name="important" text="%t"/>
      <l:template name="index" text="%t"/>
      <l:template name="indexdiv" text="%t"/>
      <l:template name="itemizedlist" text="%t"/>
      <l:template name="legalnotice" text="%t"/>
      <l:template name="listitem" text=""/>
      <l:template name="lot" text="%t"/>
      <l:template name="msg" text="%t"/>
      <l:template name="msgexplan" text="%t"/>
      <l:template name="msgmain" text="%t"/>
      <l:template name="msgrel" text="%t"/>
      <l:template name="msgset" text="%t"/>
      <l:template name="msgsub" text="%t"/>
      <l:template name="note" text="%t"/>
      <l:template name="orderedlist" text="%t"/>
      <l:template name="part" text="Part&#160;%n.&#160;%t"/>
      <l:template name="partintro" text="%t"/>
      <l:template name="preface" text="%t"/>
      <l:template name="procedure" text="%t"/>
      <l:template name="procedure.formal" text="Procedure&#160;%n.&#160;%t"/>
      <l:template name="productionset" text="%t"/>
      <l:template name="productionset.formal" text="Production&#160;%n"/>
      <l:template name="qandadiv" text="%t"/>
      <l:template name="qandaentry" text="%t"/>
      <l:template name="qandaset" text="%t"/>
      <l:template name="question" text="%t"/>
      <l:template name="refentry" text="%t"/>
      <l:template name="reference" text="%t"/>
      <l:template name="refsection" text="%t"/>
      <l:template name="refsect1" text="%t"/>
      <l:template name="refsect2" text="%t"/>
      <l:template name="refsect3" text="%t"/>
      <l:template name="refsynopsisdiv" text="%t"/>
      <l:template name="refsynopsisdivinfo" text="%t"/>
      <l:template name="segmentedlist" text="%t"/>
      <l:template name="set" text="%t"/>
      <l:template name="setindex" text="%t"/>
      <l:template name="sidebar" text="%t"/>
      <l:template name="step" text="%t"/>
      <l:template name="table" text="Table&#160;%n.&#160;%t"/>
      <l:template name="task" text="%t"/>
      <l:template name="tip" text="%t"/>
      <l:template name="toc" text="%t"/>
      <l:template name="variablelist" text="%t"/>
      <l:template name="varlistentry" text=""/>
      <l:template name="warning" text="%t"/>
      <l:template name="webpage" text="%t"/>
   </l:context>

   <l:context name="xref">
      <l:template name="abstract" text="%t"/>
      <l:template name="answer" text="A:&#160;%n"/>
      <l:template name="appendix" text="%t"/>
      <l:template name="article" text="%t"/>
      <l:template name="authorblurb" text="%t"/>
      <l:template name="bibliodiv" text="%t"/>
      <l:template name="bibliography" text="%t"/>
      <l:template name="bibliomset" text="%t"/>
      <l:template name="biblioset" text="%t"/>
      <l:template name="blockquote" text="%t"/>
      <l:template name="book" text="%t"/>
      <l:template name="calloutlist" text="%t"/>
      <l:template name="caution" text="%t"/>
      <l:template name="chapter" text="%t"/>
      <l:template name="colophon" text="%t"/>
      <l:template name="constraintdef" text="%t"/>
      <l:template name="dedication" text="%t"/>
      <l:template name="equation" text="%t"/>
      <l:template name="example" text="%t"/>
      <l:template name="figure" text="%t"/>
      <l:template name="formalpara" text="%t"/>
      <l:template name="glossary" text="%t"/>
      <l:template name="glossdiv" text="%t"/>
      <l:template name="important" text="%t"/>
      <l:template name="index" text="%t"/>
      <l:template name="indexdiv" text="%t"/>
      <l:template name="itemizedlist" text="%t"/>
      <l:template name="legalnotice" text="%t"/>
      <l:template name="listitem" text="%n"/>
      <l:template name="lot" text="%t"/>
      <l:template name="msg" text="%t"/>
      <l:template name="msgexplan" text="%t"/>
      <l:template name="msgmain" text="%t"/>
      <l:template name="msgrel" text="%t"/>
      <l:template name="msgset" text="%t"/>
      <l:template name="msgsub" text="%t"/>
      <l:template name="note" text="%t"/>
      <l:template name="orderedlist" text="%t"/>
      <l:template name="part" text="%t"/>
      <l:template name="partintro" text="%t"/>
      <l:template name="preface" text="%t"/>
      <l:template name="procedure" text="%t"/>
      <l:template name="productionset" text="%t"/>
      <l:template name="qandadiv" text="%t"/>
      <l:template name="qandaentry" text="Q:&#160;%n"/>
      <l:template name="qandaset" text="%t"/>
      <l:template name="question" text="Q:&#160;%n"/>
      <l:template name="reference" text="%t"/>
      <l:template name="refsynopsisdiv" text="%t"/>
      <l:template name="segmentedlist" text="%t"/>
      <l:template name="set" text="%t"/>
      <l:template name="setindex" text="%t"/>
      <l:template name="sidebar" text="%t"/>
      <l:template name="table" text="%t"/>
      <l:template name="tip" text="%t"/>
      <l:template name="toc" text="%t"/>
      <l:template name="variablelist" text="%t"/>
      <l:template name="varlistentry" text="%n"/>
      <l:template name="warning" text="%t"/>
      <l:template name="olink.document.citation" text=" in %o"/>
      <l:template name="olink.page.citation" text=" (page %p)"/>
      <l:template name="page.citation" text=" [%p]"/>
      <l:template name="page" text="(page %p)"/>
      <l:template name="docname" text=" in %o"/>
      <l:template name="docnamelong" text=" in the document titled %o"/>
      <l:template name="pageabbrev" text="(p. %p)"/>
      <l:template name="Page" text="Page %p"/>
      <l:template name="bridgehead" text="the section called &#8220;%t&#8221;"/>
      <l:template name="refsection" text="the section called &#8220;%t&#8221;"/>
      <l:template name="refsect1" text="the section called &#8220;%t&#8221;"/>
      <l:template name="refsect2" text="the section called &#8220;%t&#8221;"/>
      <l:template name="refsect3" text="the section called &#8220;%t&#8221;"/>
      <l:template name="sect1" text="the section called &#8220;%t&#8221;"/>
      <l:template name="sect2" text="the section called &#8220;%t&#8221;"/>
      <l:template name="sect3" text="the section called &#8220;%t&#8221;"/>
      <l:template name="sect4" text="the section called &#8220;%t&#8221;"/>
      <l:template name="sect5" text="the section called &#8220;%t&#8221;"/>
      <l:template name="section" text="the section called &#8220;%t&#8221;"/>
      <l:template name="simplesect" text="the section called &#8220;%t&#8221;"/>
      <l:template name="webpage" text="%t"/>
    </l:context>
  </l:l10n>
</l:i18n>

</xsl:stylesheet>
