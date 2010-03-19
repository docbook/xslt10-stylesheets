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

<!-- Common declarations -->

<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

<!-- Common functions -->

<!-- ============================================================ -->

<xsl:function name="f:only-attributes" as="xs:boolean">
  <xsl:param name="elem" as="element(dtx:ref)*"/>

<!--
  <xsl:message>
    <xsl:value-of select="count($elem)"/>
    <xsl:text> </xsl:text>
    <xsl:for-each select="$elem">
      <xsl:value-of select="@name"/>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:message>
-->

  <xsl:variable name="allatts" as="xs:string*">
    <xsl:for-each select="$elem">
      <xsl:variable name="target" select="key('name',@name)"/>
      <xsl:choose>
        <xsl:when test="$target/dtx:attdecl">
          <xsl:text>YES</xsl:text>
        </xsl:when>
        <xsl:when test="$target/dtx:ref
                        and count($target/dtx:ref) = count($target/*)">
          <xsl:choose>
            <xsl:when test="f:only-attributes($target/dtx:ref)">YES</xsl:when>
            <xsl:otherwise>NO</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$target/dtx:choice and count($target/*) = 1
                        and $target/dtx:choice/dtx:ref
                        and count($target/dtx:choice/dtx:ref)
                            = count($target/dtx:choice/*)">
          <xsl:choose>
            <xsl:when test="f:only-attributes($target/dtx:choice/dtx:ref)">YES</xsl:when>
            <xsl:otherwise>NO</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>NO</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:value-of select="not($allatts = 'NO')"/>
</xsl:function>

</xsl:stylesheet>
