<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:s="http://www.ascc.net/xml/schematron"
		xmlns:db="http://docbook.org/ns/docbook"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <s:schema>
      <s:ns prefix="db" uri="http://docbook.org/ns/docbook"/>

      <xsl:apply-templates select="//s:pattern"/>
    </s:schema>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
