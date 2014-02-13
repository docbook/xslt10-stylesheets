<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		exclude-result-prefixes="dbs db"
                version="1.0">

<xsl:template name="get.title">
  <xsl:param name="ctx" select="."/>

  <xsl:value-of select="($ctx/d:info/d:titleabbrev|$ctx/d:titleabbrev|$ctx/d:info/d:title|$ctx/d:title)[1]"/>
</xsl:template>

<xsl:template name="get.subtitle">
  <xsl:param name="ctx" select="."/>

  <xsl:value-of select="($ctx/d:info/d:subtitle|$ctx/d:subtitle)[1]"/>
</xsl:template>
</xsl:stylesheet>
