<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output method="text" indent="no"/>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or https://cdn.docbook.org/release/xsl/current for
     copyright and other information.

     ******************************************************************** -->

<xsl:template match="preface|reference|refentry|appendix">
  <xsl:value-of select="concat(@*[local-name() = 'id'],'.html','&#x0a;')"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>
