<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://sagehill.net/xsl/target/1.0"
                version="1.0">

<!-- Extracts cross reference target information from
     a document that is going to be output non-chunked in HTML.

     Adjust this relative reference for importing the
     standard docbook.xsl file.
-->

<xsl:import href="../../docbook-xsl-1.45/html/docbook.xsl"/>
<xsl:include href="olink-common.xsl"/>

<xsl:output method="xml" indent="yes" />

<xsl:param name="base-uri" select="''"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:l10n language="en" xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:context name="xref">
    <l:template name="refentry" text="%t"/>
  </l:context>
</l:l10n>

<xsl:template match="refentry" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>



<xsl:template name="olink.href.target">
  <xsl:param name="nd" select="."/>

  <xsl:value-of select="$base-uri"/>
  <xsl:call-template name="href.target">
    <xsl:with-param name="obj" select="$nd"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
