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
