<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:param name="website.database.document"
           select="'website.database.xml'"/>

<xsl:template match="olink" name="olink">
  <xsl:choose>
    <xsl:when test="@targetdoc != '' or @targetptr != ''">
      <xsl:call-template name="olink-xsl"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="olink-entity"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink-entity">
  <xsl:variable name="xmlfile"
                select="document(unparsed-entity-uri(@targetdocent),$autolayout)"/>
  <xsl:variable name="webpage"
                select="$xmlfile/webpage"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[$webpage/@id=@id]"/>

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

<!-- debug
  <xsl:message>Olink for <xsl:value-of select="unparsed-entity-uri(@targetdocent)"/></xsl:message>
  <xsl:message>Page id <xsl:value-of select="$webpage/@id"/></xsl:message>
-->

  <xsl:choose>
    <xsl:when test="@type = 'embed'">
      <xsl:apply-templates select="$xmlfile"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- @type = 'replace' or @type = 'new' -->
      <a>
        <xsl:if test="@id">
          <xsl:attribute name="name">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </xsl:if>

<!-- debug
        <xsl:message>
          <xsl:text>href: </xsl:text>
          <xsl:call-template name="root-rel-path"/>
          <xsl:text>::</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>::</xsl:text>
          <xsl:value-of select="$filename-prefix"/>
          <xsl:text>::</xsl:text>
          <xsl:value-of select="$tocentry/@filename"/>
          <xsl:text>::</xsl:text>
          <xsl:if test="@localinfo">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@localinfo"/>
          </xsl:if>
        </xsl:message>
-->

        <xsl:attribute name="href">
          <xsl:call-template name="root-rel-path"/>
          <xsl:value-of select="$dir"/>
          <xsl:value-of select="$filename-prefix"/>
          <xsl:value-of select="$tocentry/@filename"/>
          <xsl:if test="@localinfo">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@localinfo"/>
          </xsl:if>
        </xsl:attribute>

        <xsl:if test="@type = 'new'">
          <xsl:attribute name="target">_blank</xsl:attribute>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="count(node()) = 0">
            <xsl:apply-templates select="$webpage/head/title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink-xsl">
  <xsl:param name="offsite.target.database" 
      select="document($target.database.document, /)"/>
  <xsl:param name="website.target.database" 
      select="document($website.database.document, /)"/>

<!-- debug 
<xsl:message>In olink, $website.database.document is <xsl:value-of
select="$website.database.document"/>
</xsl:message>

<xsl:message>In olink, $target.database.document is <xsl:value-of
select="$target.database.document"/>
</xsl:message>

-->

  <xsl:variable name="seek.targetdoc" select="@targetdoc"/>
  <xsl:variable name="seek.targetptr" select="@targetptr"/>

  <xsl:variable name="website.targetdoc.key" >
    <xsl:for-each select="$website.target.database" >
      <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/@targetdoc" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="website.targetptr.key" >
    <xsl:for-each select="$website.target.database" >
      <xsl:value-of select="key('targetptr-key', concat($seek.targetdoc,
                                '/', $seek.targetptr))/@targetptr" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="offsite.targetdoc.key" >
    <xsl:for-each select="$offsite.target.database" >
      <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/@targetdoc" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="offsite.targetptr.key" >
    <xsl:for-each select="$offsite.target.database" >
      <xsl:value-of select="key('targetptr-key', concat($seek.targetdoc,
                                '/', $seek.targetptr))/@targetptr" />
    </xsl:for-each>
  </xsl:variable>

<!-- debug 
<xsl:message>In olink, $website.targetptr.key is <xsl:value-of
select="$website.targetptr.key"/>
</xsl:message>
<xsl:message>In olink, $offsite.targetptr.key is <xsl:value-of
select="$offsite.targetptr.key"/>
</xsl:message>
-->

  <xsl:call-template name="anchor"/>

  <!-- Is the reference in the website or offsite database? -->
  <xsl:variable name="targetdb">  
    <xsl:choose>
      <!-- Check for olink attributes -->
      <xsl:when test="@targetdoc and not(@targetptr)" >
        <xsl:message>Olink missing @targetptr attribute value</xsl:message>
      </xsl:when>
      <xsl:when test="not(@targetdoc) and @targetptr" >
        <xsl:message>Olink missing @targetdoc attribute value</xsl:message>
      </xsl:when>
      <xsl:when test="@targetdoc and @targetptr">

        <xsl:choose>
          <xsl:when test="$website.targetptr.key != ''">
            <xsl:value-of select="$website.database.document"/>
          </xsl:when>
          <xsl:when test="$offsite.targetptr.key != ''">
            <xsl:value-of select="$target.database.document"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

<!-- debug
<xsl:message>In olink, $targetdb is <xsl:value-of
select="$targetdb"/>
</xsl:message>
-->

  <xsl:choose>
    <xsl:when test="$targetdb != ''">
      <xsl:call-template name="process.olink">
        <xsl:with-param name="this.database.document">
          <xsl:value-of select="$targetdb"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Olink error: targetptr "<xsl:value-of select="@targetptr"/>" not found for targetdoc "<xsl:value-of select="@targetdoc"/>".</xsl:message>
      <xsl:choose>
        <xsl:when test="$target.database.document = '' 
                        and $website.database.document = ''">
          <xsl:message>
            <xsl:text>No olink database specified: must specify either a $target.database.document or $website.database.document parameter
            </xsl:text>
            <xsl:text>when using olinks with targetdoc and targetptr attributes.</xsl:text>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
        <xsl:if test="$website.database.document != ''">
          <xsl:choose>
            <!-- Did it not open? Should be a targetset element -->
           <xsl:when test="not($website.target.database/targetset)">
              <xsl:message>    details: could not open website target database <xsl:value-of select="$website.database.document"/>.  </xsl:message>
            </xsl:when>
            <!-- Does it not have this document id? -->
            <xsl:when test="$website.targetdoc.key = ''" >
              <xsl:message>    details: targetdoc "<xsl:value-of select="$seek.targetdoc"/>" not in website target database.</xsl:message>
            </xsl:when>
            <!-- Does this document not have this targetptr? -->
           <xsl:when test="$website.targetptr.key = ''" >
              <!-- Does this document have *any* content? -->
               <xsl:variable name="document.root">
                <xsl:for-each select="$website.target.database" >
                 <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/div/@element"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$document.root = ''">
                  <xsl:message>    details: could not open data file for website document id '<xsl:value-of select="$seek.targetdoc"/>'.</xsl:message>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>    details: targetptr "<xsl:value-of select="$seek.targetptr"/>" not found for website targetdoc "<xsl:value-of select="$seek.targetdoc"/>".</xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="$target.database.document != ''">
          <xsl:choose>
            <!-- Did it not open? Should be a targetset element -->
           <xsl:when test="not($offsite.target.database/targetset)">
              <xsl:message>    details: could not open offsite target database <xsl:value-of select="$target.database.document"/>.  </xsl:message>
            </xsl:when>
            <!-- Does it not have this document id? -->
            <xsl:when test="$offsite.targetdoc.key = ''" >
              <xsl:message>    details: targetdoc "<xsl:value-of select="$seek.targetdoc"/>" not in offsite target database.</xsl:message>
            </xsl:when>
            <!-- Does this document not have this targetptr? -->
           <xsl:when test="$offsite.targetptr.key = ''" >
              <!-- Does this document have *any* content? -->
               <xsl:variable name="document.root">
                <xsl:for-each select="$offsite.target.database" >
                 <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/div/@element"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$document.root = ''">
                  <xsl:message>    details: could not open data file for offsite targetdoc "<xsl:value-of select="$seek.targetdoc"/>".</xsl:message>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>    details: targetptr "<xsl:value-of select="$seek.targetptr"/>" not found in offsite targetdoc "<xsl:value-of select="$seek.targetdoc"/>".</xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="process.olink">
  <xsl:param name="this.database.document"/>
  <xsl:param name="target.database"
             select="document($this.database.document, /)"/>
  <xsl:param name="seek.targetdoc" select="@targetdoc"/>
  <xsl:param name="seek.targetptr" select="@targetptr"/>

  <xsl:variable name="targetdoc.key" >
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/@targetdoc" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="targetptr.key" >
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetptr-key',
          concat($seek.targetdoc, '/', $seek.targetptr))/@targetptr" />
    </xsl:for-each>
  </xsl:variable>

<!-- debug 
<xsl:message>In process.olink and target.database.document is
<xsl:value-of select="$this.database.document"/>
</xsl:message>
<xsl:message>In process.olink and targetdoc.key is
<xsl:value-of select="$targetdoc.key"/>
</xsl:message>
<xsl:message>In process.olink and targetptr.key is
<xsl:value-of select="$targetptr.key"/>
</xsl:message>
-->

  <!-- Does the target database use a sitemap? -->
  <!-- That is, does this key have a <dir> parent? -->
  <xsl:variable name="use.sitemap">
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetdoc-key',
                   $targetdoc.key)/parent::dir/@name"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="target.href" >
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetptr-key', concat($targetdoc.key,
                                '/', $targetptr.key))/@href" />

    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="target.element" >
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetptr-key', concat($targetdoc.key,
                                '/', $targetptr.key))/@element" />

    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="target.dir" >
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetdoc-key', $seek.targetdoc)/@dir" />
    </xsl:for-each>
  </xsl:variable>

  <!-- Get the baseuri for this targetptr -->

  <xsl:variable name="baseuri" >
    <xsl:choose>
      <!-- Does the database use a sitemap? -->
      <xsl:when test="$use.sitemap != ''" >
        <xsl:choose>
          <!-- Was current.docid parameter set? -->
          <xsl:when test="$current.docid != ''">
            <xsl:for-each select="$target.database" >
              <xsl:call-template name="targetpath" >
                <xsl:with-param name="dirnode" select="key('targetdoc-key',
                                     $current.docid)/parent::dir"/>
                <xsl:with-param name="targetdoc" select="$targetdoc.key"/>
              </xsl:call-template>
            </xsl:for-each >
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>Olink warning: cannot compute relative sitemap path without $current.docid parameter</xsl:message>
          </xsl:otherwise>
        </xsl:choose> 
        <!-- In either case, add baseuri from its document entry-->
        <xsl:variable name="docbaseuri">
          <xsl:for-each select="$target.database" >
            <xsl:value-of select="key('targetdoc-key',
                                       $targetdoc.key)/@baseuri" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$docbaseuri != ''" >
          <xsl:value-of select="$docbaseuri"/>
        </xsl:if>
      </xsl:when>
      <!-- No database sitemap in use -->
      <xsl:otherwise>
        <!-- compute a root-relative path if current page has a @dir -->
        <xsl:variable name="root-rel">
          <xsl:call-template name="root-rel-path"/>
        </xsl:variable>
        <xsl:if test="$root-rel != ''">
          <xsl:value-of select="$root-rel"/>
        </xsl:if>
	<!-- Add the target's @dir to the path -->
        <xsl:if test="$target.dir != ''">
          <xsl:value-of select="$target.dir"/>
        </xsl:if>
        <!-- Just use any baseuri from its document entry -->
        <xsl:variable name="docbaseuri">
          <xsl:for-each select="$target.database" >
            <xsl:value-of select="key('targetdoc-key',
                                      $seek.targetdoc)/@baseuri" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$docbaseuri != ''" >
          <xsl:value-of select="$docbaseuri"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Form the href information -->
  <xsl:variable name="href">
    <xsl:if test="$baseuri != ''">
      <xsl:value-of select="$baseuri"/>
      <xsl:if test="substring($target.href,1,1) != '#'">
        <!--xsl:text>/</xsl:text-->
      </xsl:if>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$target.element = 'webpage' and
                      $seek.targetdoc = $seek.targetptr">
	<!-- Don't output #id because not needed -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target.href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$href != ''">
      <a href="{$href}">
        <xsl:call-template name="olink.hottext">
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>

      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="olink.hottext">
        <xsl:with-param name="target.database" select="$target.database"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>
