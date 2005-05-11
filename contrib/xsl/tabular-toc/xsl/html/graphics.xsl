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
