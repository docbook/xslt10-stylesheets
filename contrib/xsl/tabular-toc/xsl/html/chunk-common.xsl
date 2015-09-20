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
