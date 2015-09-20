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
