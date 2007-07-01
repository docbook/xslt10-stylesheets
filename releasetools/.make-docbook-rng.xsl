<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  <xsl:import href=".identity.xsl"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="/">
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * This is a static copy of the latest DocBook RELAXNG schema and it </xsl:comment>
    <xsl:comment> * *MAY NOT BE UP TO DATE*. It is provided for the convenience of </xsl:comment>
    <xsl:comment> * developers who don't want to generate the schema themselves from </xsl:comment>
    <xsl:comment> * the sources, which are in the ../docbook/relaxng/docbook </xsl:comment>
    <xsl:comment> * directory. To create a fresh up-to-date copy of the schema, check </xsl:comment>
    <xsl:comment> * out that directory from the source repository and build it. </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
