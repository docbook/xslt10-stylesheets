<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt"
		version="1.0">

<!-- This stylesheet works with XT; for others use chunker.xsl -->

<!-- ==================================================================== -->

<xsl:template name="make-relative-filename">
  <xsl:param name="base.dir" select="'./'"/>
  <xsl:param name="base.name" select="''"/>

  <!-- XT makes chunks relative -->
  <xsl:choose>
    <xsl:when test="count(parent::*) = 0">
      <xsl:value-of select="concat($base.dir,$base.name)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$base.name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="write.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="method" select="'html'"/>
  <xsl:param name="encoding" select="'ISO-8859-1'"/>
  <xsl:param name="content" select="''"/>

  <!-- apparently XT doesn't support AVTs for method and encoding -->
  <xt:document href="{$filename}"
               method="html"
               encoding="ISO-8859-1">
    <xsl:copy-of select="$content"/>
  </xt:document>
</xsl:template>

</xsl:stylesheet>
