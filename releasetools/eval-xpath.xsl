<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sf="http://sourceforge.net/"
  xmlns:dyn="http://exslt.org/dynamic"
  version='1.0'>
  <!-- ********************************************************************
       $Id$
       ******************************************************************** -->

  <xsl:output method="text"/>
  <xsl:param name="expression"/>

  <xsl:template match="/">
    <xsl:choose>
      <!-- * xsltproc and Xalan both support dyn:evaluate() -->
      <xsl:when test="function-available('dyn:evaluate')">
        <xsl:value-of select="dyn:evaluate($expression)"/>
      </xsl:when>
      <!-- * Saxon has its own evaluate() & doesn't support dyn:evaluate() -->
      <xsl:when test="function-available('saxon:evaluate')">
        <xsl:value-of select="saxon:evaluate($expression)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
