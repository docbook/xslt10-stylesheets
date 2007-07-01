<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  <xsl:import href=".identity.xsl"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:param name="filename"/>
  <xsl:template match="/">
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * This is a static copy of the <xsl:value-of select="$filename"/> file from the litprog module. </xsl:comment>
    <xsl:comment> * It *MAY NOT BE UP TO DATE*. It is provided for the convenience of </xsl:comment>
    <xsl:comment> * developers who don't want to generate the file themselves from </xsl:comment>
    <xsl:comment> * the sources in the ../litprog directory. To create a fresh up-to-date </xsl:comment>
    <xsl:comment> * copy of the file, check out that directory from the source repository </xsl:comment>
    <xsl:comment> * and build it. </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- * some of the litprog files contain an xsl:include that -->
  <!-- * references the litprog VERSION file; those aren't necessary for -->
  <!-- * our purposes, so let's just omit them from our copies -->
  <xsl:template match="*[local-name() = 'include']"/>
</xsl:stylesheet>
