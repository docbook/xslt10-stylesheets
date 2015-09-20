<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nl "<xsl:text>&#xA;</xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
                version="1.0">

<xsl:preserve-space elements="*"/>

<xsl:output method="xml"/>

<xsl:param name="top" select="'xtop'"/>

<xsl:template match="/">
  <xsl:apply-templates select="//src:fragment[@id=$top]"/>
</xsl:template>

<xsl:template match="text()"/>

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="src:fragment">
  <xsl:apply-templates mode="copy"/>
</xsl:template>

<xsl:template match="*" mode="copy">
  <!--
  <xsl:message><xsl:value-of select="name(.)"/></xsl:message>
  -->
  <xsl:element name="{name(.)}">
    <xsl:for-each select="namespace::*">
      <!--
      <xsl:message><xsl:value-of select="."/></xsl:message>
      -->
      <xsl:copy/>
    </xsl:for-each>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="src:passthrough" mode="copy">
  <xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>

<xsl:template match="src:fragref" mode="copy">
  <xsl:choose>
    <xsl:when test="@disable-output-escaping='yes'">
      <xsl:element name="{name(.)}">
        <xsl:for-each select="namespace::*">
          <xsl:copy/>
        </xsl:for-each>
        <xsl:for-each select="@*">
          <xsl:if test="not(name(.) = 'disable-output-escaping')">
            <xsl:copy/>
          </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates mode="copy"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="linkend" select="@linkend"/>
      <xsl:variable name="fragment" select="//src:fragment[@id=$linkend]"/>
      <xsl:apply-templates select="$fragment"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="src:comment" mode="copy">
  <xsl:comment>
    <xsl:value-of select="."/>
  </xsl:comment>
</xsl:template>

</xsl:stylesheet>
