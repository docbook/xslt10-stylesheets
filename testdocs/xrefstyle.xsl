<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="../xsl/html/docbook.xsl"/>

<xsl:output method="html"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
   <l:context name="xref">
      <l:template name="chapter" style="title" text="Chapter %n, %t"/>
      <l:template name="chapter" text="Chapter %n"/>
    </l:context>
  </l:l10n>
</l:i18n>

</xsl:stylesheet>
