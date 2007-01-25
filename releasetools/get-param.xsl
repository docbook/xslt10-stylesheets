<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
  <!-- ********************************************************************
       $Id$
       ******************************************************************** -->
  
  <xsl:output method="text"/>
  <xsl:param name="param"/>
  
  <xsl:template match="/">
    <xsl:param name="target" select="//*[@*[local-name() = 'name'] = $param]"/>
    <xsl:choose>
      <xsl:when test="contains($target, 'Revision')">
        <xsl:value-of select="substring-before(substring-after($target, 'Revision: '), ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>