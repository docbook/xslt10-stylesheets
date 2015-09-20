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

<!-- Sort the PEs so that they aren't referenced before they're declared -->

<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:key name="pes" match="dtx:pe" use="@name"/>

<xsl:strip-space elements="*"/>

<xsl:variable name="depth"
              select="if (//dtx:pe[@depth])
                      then max(//dtx:pe[@depth]/@depth)
                      else 0"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dtx:pe[not(@depth)]">
  <xsl:choose>
    <xsl:when test="$depth = 0">
      <xsl:choose>
        <xsl:when test="not(.//dtx:ref) and not(.//dtx:attref)">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="depth" select="1"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="depths" as="xs:integer*">
        <xsl:for-each select=".//dtx:ref|.//dtx:attref">
          <xsl:variable name="target" select="key('pes',@name)"/>
          <xsl:choose>
            <xsl:when test="not($target)"/>
            <xsl:when test="$target/@depth">
              <xsl:value-of select="$target/@depth"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$depths = 0">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:when>
        <xsl:when test="empty($depths)">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="depth" select="1"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="depth" select="max($depths)+1"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
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

</xsl:stylesheet>
