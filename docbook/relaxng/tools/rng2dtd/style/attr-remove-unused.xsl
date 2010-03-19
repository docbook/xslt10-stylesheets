<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:dtx="http://nwalsh.com/ns/dtd-xml"
                xmlns:f="http://nwalsh.com/functions/dtd-xml"
                xmlns="http://nwalsh.com/ns/dtd-xml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="s a dtx xs f"
                version="2.0">

<xsl:include href="common.xsl"/>

<!-- Remove dtx:pe elements that are unreferenced -->

<xsl:key name="ref" match="dtx:ref" use="@name"/>

<xsl:template match="dtx:pe">
  <xsl:variable name="refs" select="key('ref', @name)"/>

  <xsl:if test="$refs">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
