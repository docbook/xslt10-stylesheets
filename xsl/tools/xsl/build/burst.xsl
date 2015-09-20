<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
		version='1.0'>
  <xsl:import href="../../../html/chunker.xsl"/>
  <xsl:output method="xml"
              />
  <xsl:template match="refentry">
    <xsl:param name="content">
      <xsl:copy-of select="."/>
    </xsl:param>
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="filename" select="concat(@id,'.xml')"/>
      <xsl:with-param name="encoding">ascii</xsl:with-param>
      <xsl:with-param name="method">xml</xsl:with-param>
      <xsl:with-param name="saxon.character.representation">ASCII</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
