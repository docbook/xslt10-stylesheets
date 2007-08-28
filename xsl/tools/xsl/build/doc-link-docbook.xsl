<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../../../html/docbook.xsl"/>
<xsl:include href="tdg-link.xsl"/>
<xsl:include href="xsl-param-link.xsl"/>
<xsl:param name="abstract.notitle.enabled" select="1"/>
<xsl:param name="html.append"><xsl:text>&#x0a;</xsl:text></xsl:param>

</xsl:stylesheet>
