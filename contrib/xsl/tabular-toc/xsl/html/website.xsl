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
     $Id$
     ********************************************************************

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
