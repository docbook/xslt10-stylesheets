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
