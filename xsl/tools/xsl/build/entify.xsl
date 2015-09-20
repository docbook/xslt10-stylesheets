<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
		version='1.0'>
  <xsl:import href="identity.xsl"/>
  <xsl:output method="xml"
              />
  <xsl:template match="refentry"
                ><xsl:value-of select="concat('&lt;!ENTITY ', @id, ' SYSTEM ',
                '&quot;../params/', @id, '.xml&quot;>')"/></xsl:template>
  
</xsl:stylesheet>
