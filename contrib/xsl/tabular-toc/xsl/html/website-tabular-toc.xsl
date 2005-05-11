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
