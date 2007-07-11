<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:saxon="http://icl.com/saxon"
  exclude-result-prefixes="fo"
  >
  <xsl:import href="./identity.xsl"/>

  <xsl:output method="xml"
    encoding="ASCII"
    saxon:character-representation="decimal"
    indent="no"/>

  <xsl:template match="@xml:id">
    <xsl:attribute name="id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
