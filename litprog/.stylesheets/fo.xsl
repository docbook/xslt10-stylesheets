<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="/sourceforge/docbook/xsl/fo/docbook.xsl"/>

<xsl:param name="page.margin.outer" select="'1in'"/>
<xsl:param name="title.margin.left" select="'-0pt'"/>

<xsl:template match="revhistory" mode="titlepage.mode"/>

<xsl:template match="affiliation" mode="titlepage.mode">
  <fo:block font-weight="normal" font-size="12pt">
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="phrase[@condition='online']"/>

</xsl:stylesheet>
