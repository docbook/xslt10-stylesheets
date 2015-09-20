<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                exclude-result-prefixes="doc"
                version="1.0">

<!-- This stylesheet switches processing so primary input is locale XML and English is specified as parameter for easier invocation from Ant -->

<xsl:import href="xsl.xsl"/>

<xsl:param name="locale" select="/"/>
<xsl:param name="en.locale.file" select="''"/>
<xsl:param name="en.locale" select="document($en.locale.file, /)"/>

<xsl:template match="/">
  <xsl:apply-templates select="$en.locale/*"/>
</xsl:template>

</xsl:stylesheet>
