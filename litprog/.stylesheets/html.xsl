<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../../xsl/html/docbook.xsl"/>

<xsl:output method="html"/>

<xsl:param name="html.stylesheet" select="'paper.css'"/>

<xsl:template match="revhistory" mode="titlepage.mode"/>

</xsl:stylesheet>
