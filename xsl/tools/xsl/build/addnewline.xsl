<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version='1.0'>
  <xsl:import href="./identity.xsl"/>

  <xsl:output method="xml"
	      indent="no"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
