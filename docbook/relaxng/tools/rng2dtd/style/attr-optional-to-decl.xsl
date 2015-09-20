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

<!-- move the optionality of attributes back up into the declarations -->

<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:key name="ref" match="dtx:ref|dtx:attref" use="@name"/>
<xsl:key name="pe" match="dtx:pe" use="@name"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dtx:pe[dtx:attdecl and count(*) = 1]">
  <xsl:variable name="refs" select="key('ref', @name)"/>

  <xsl:choose>
    <xsl:when test="count($refs[@optional = 'true']) != count($refs)
                    and count($refs[@optional = 'true']) != 0">
<!--
      <xsl:message>Splitting <xsl:value-of select="@name"/></xsl:message>
-->

      <pe name="{@name}.REQ">
        <attdecl>
          <xsl:copy-of select="dtx:attdecl/@*[local-name(.) != 'optional']"/>
          <xsl:apply-templates select="dtx:attdecl/*"/>
        </attdecl>
      </pe>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
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
</xsl:template>

<xsl:template match="dtx:attref[not(@optional='true')]">
  <xsl:variable name="refs" select="key('ref', @name)"/>
  <xsl:variable name="target" select="key('pe', @name)"/>

  <!-- The and $target/dtx:attdecl test avoids a bug where db.html.attributes
       appears sometimes required and sometimes optional but really doesn't
       matter -->

  <xsl:choose>
    <xsl:when test="count($refs[@optional = 'true']) != count($refs)
                    and count($refs[@optional = 'true']) != 0
                    and $target/dtx:attdecl">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name" select="concat(@name,'.REQ')"/>
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
</xsl:template>

<xsl:template match="dtx:attref[@optional='true']">
  <xsl:copy>
    <xsl:copy-of select="@*[local-name(.) != 'optional']"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="dtx:attdecl">
  <xsl:variable name="pe" select="ancestor::dtx:pe"/>
  <xsl:variable name="refs" select="key('ref', $pe/@name)"/>

  <xsl:if test="not($pe)">
    <xsl:message terminate="yes">
      <xsl:text>dtx:attdecl not an ancestor of a dtx:pe?</xsl:text>
    </xsl:message>
  </xsl:if>

<!--
  <xsl:if test="count($refs[@optional = 'true']) != count($refs)
                and count($refs[@optional = 'true']) != 0">
    <xsl:message>
      <xsl:text>Attribute </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> (on </xsl:text>
      <xsl:value-of select="$pe/@name"/>
      <xsl:text>) is sometimes optional and sometimes not?</xsl:text>
    </xsl:message>
    <xsl:for-each select="$refs">
      <xsl:message>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="@optional"/>
      </xsl:message>
    </xsl:for-each>
  </xsl:if>
-->

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:if test="$refs[@optional = 'true']">
      <xsl:attribute name="optional" select="'true'"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:copy>
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
