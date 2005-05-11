<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
<!-- ideally debian post 1.66.0
<xsl:include href="/usr/share/xml/docbook/stylesheet/nwalsh/html/chunk.xsl"/>
 -->
<xsl:import href="/home/timeout/ddb/junk/docbook-xsl-1.66.0/html/chunk.xsl"/>
<xsl:import href="../../../xsl/tabular-docbook.xsl"/>


<!-- styles: folder, folder16, plusminus, triangle, arrow -->

<xsl:param name="nav.text.spacer">&#160;</xsl:param>
<xsl:param name="nav.text.current.open">-</xsl:param>
<xsl:param name="nav.text.current.page">+</xsl:param>
<xsl:param name="nav.text.other.open">-</xsl:param>
<xsl:param name="nav.text.other.closed">+</xsl:param>
<xsl:param name="nav.text.other.page">&#160;</xsl:param>

<!-- Add other variable definitions here -->


</xsl:stylesheet>
