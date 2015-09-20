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
