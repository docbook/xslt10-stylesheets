<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fm="http://freshmeat.net/projects/freshmeat-submit/"
                exclude-result-prefixes="fm"
                version='1.0'>

<xsl:output indent="yes"/>

<!-- ==================================================================== -->

<xsl:include href="VERSION.xsl"/>
<xsl:param name="PROJECT">
  <xsl:value-of select="string(document('VERSION.xsl')//fm:Project[1])"/>
</xsl:param>
<xsl:param name="BRANCH">
  <xsl:value-of select="string(document('VERSION.xsl')//fm:Branch[1])"/>
</xsl:param>
<xsl:param name="URI_BASE">https://cdn.docbook.org/release</xsl:param>
<xsl:param name="DISTRO"/>
<xsl:param name="SUBDIR">current</xsl:param>

<xsl:param name="COMMENT">
  <xsl:text> XML Catalog file for </xsl:text>
  <xsl:value-of select="$PROJECT"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="$BRANCH"/>
  <xsl:text> v</xsl:text><xsl:value-of select="$VERSION"/>
  <xsl:text> </xsl:text>
</xsl:param>

<xsl:template match="/">

  <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <xsl:text>&#10;</xsl:text>
    <xsl:comment><xsl:value-of select="$COMMENT"/></xsl:comment>

    <rewriteURI uriStartString="{$URI_BASE}/{$DISTRO}/{$SUBDIR}/" rewritePrefix="./"/>
    <rewriteSystem systemIdStartString="{$URI_BASE}/{$DISTRO}/{$SUBDIR}/" rewritePrefix="./"/>

    <rewriteURI uriStartString="{$URI_BASE}/{$DISTRO}/{$VERSION}/" rewritePrefix="./"/>
    <rewriteSystem systemIdStartString="{$URI_BASE}/{$DISTRO}/{$VERSION}/" rewritePrefix="./"/>
  </catalog>
  <xsl:text>&#10;</xsl:text>

</xsl:template>

</xsl:stylesheet>
