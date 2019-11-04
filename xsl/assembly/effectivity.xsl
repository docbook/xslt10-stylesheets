<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns="http://docbook.org/ns/docbook"
  exclude-result-prefixes="exsl d xlink d"
  version="1.0">
  
  <xsl:param name="effectivity.arch" />
  <xsl:param name="effectivity.audience" />
  <xsl:param name="effectivity.condition" />
  <xsl:param name="effectivity.conformance" />
  <xsl:param name="effectivity.os" />
  <xsl:param name="effectivity.outputformat" />
  <xsl:param name="effectivity.revision" />
  <xsl:param name="effectivity.security" />
  <xsl:param name="effectivity.userlevel" />
  <xsl:param name="effectivity.vendor" />
  <xsl:param name="effectivity.wordsize" />

  <xsl:template match="d:module[@resourceref] | d:structure[@resourceref]" mode="evaluate.effectivity">
    <xsl:apply-templates mode="evaluate.effectivity" />
  </xsl:template>
  
  <xsl:template match="d:filterout" mode="evaluate.effectivity">
    
    <xsl:variable name="effectivity.attribute.arch" select="@arch" />
    <xsl:variable name="effectivity.attribute.audience" select="@audience" />
    <xsl:variable name="effectivity.attribute.condition" select="@condition" />
    <xsl:variable name="effectivity.attribute.conformance" select="@conformance" />
    <xsl:variable name="effectivity.attribute.os" select="@os" />
    <xsl:variable name="effectivity.attribute.outputformat" select="@outputformat" />
    <xsl:variable name="effectivity.attribute.revision" select="@revision" />
    <xsl:variable name="effectivity.attribute.security" select="@security" />
    <xsl:variable name="effectivity.attribute.userlevel" select="@userlevel" />
    <xsl:variable name="effectivity.attribute.vendor" select="@vendor" />
    <xsl:variable name="effectivity.attribute.wordsize" select="@wordsize" />

    <xsl:choose>
      <xsl:when test="$effectivity.attribute.arch = $effectivity.arch">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.audience = $effectivity.audience">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.condition = $effectivity.condition">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.conformance = $effectivity.conformance">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.os = $effectivity.os">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.outputformat = $effectivity.outputformat">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.revision = $effectivity.revision">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.security = $effectivity.security">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.userlevel = $effectivity.userlevel">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.vendor = $effectivity.vendor">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:when test="$effectivity.attribute.wordsize = $effectivity.wordsize">
        <xsl:text>false</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because of an effectivity attribute.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <!-- Do nothing. There's no reason to filter out the module or 
        structure because the effectivity parameters passed into the 
        stylesheet do not match any of the effectivity attributes for 
        this filterout element. -->
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template match="d:filterin" mode="evaluate.effectivity">
    <xsl:message>INFO: processing a filterout element.</xsl:message>
    
    <xsl:variable name="effectivity.attribute.condition" select="@condition" />

    <xsl:choose>
      <xsl:when test="$effectivity.attribute.condition = $effectivity.condition">
        <xsl:text>false</xsl:text>
        <xsl:message>Omitting: <xsl:value-of select="$effectivity.attribute.condition" /> is <xsl:value-of select="$effectivity.condition" /></xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>INFO: no effectivity parameter values matched effectivity attributes of this filterout element.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
