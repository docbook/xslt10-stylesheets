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
  
  <!--
  
    Evaluate whether an effectivity attribute of a filterin element 
    matches the corresponding effectivity parameter passed to this 
    stylesheet. If it *does not* match, return the string "false" to 
    indicate that the assembly processor should omit the module.
  
  -->
  
  <!--
  
  <xsl:template match="@condition[parent::d:filterin]" mode="evaluate.effectivity">
    <xsl:variable name="this.effectivity.attribute">
      <xsl:value-of select="." />
    </xsl:variable>
    
    <xsl:message>This attribute: <xsl:value-of select="$this.effectivity.attribute" /></xsl:message>
    <xsl:message>The parameter: <xsl:value-of select="$effectivity.condition" /></xsl:message>

    <xsl:if test="$this.effectivity.attribute != $effectivity.condition">
      <xsl:text>false</xsl:text>
      <xsl:message>TEST RESULT: <xsl:value-of select="." /></xsl:message>
    </xsl:if>
  </xsl:template>
  
  -->
  
  <!-- <xsl:template match="@*" mode="evaluate.effectivity" /> -->
  
    <!--
  
    Evaluate whether an effectivity attribute of a filterout element 
    matches the corresponding effectivity parameter passed to this 
    stylesheet. If it *does* match, return the string "false" to 
    indicate that the assembly processor should omit the module.
  
  -->
  
  <!--
  
  <xsl:template match="@d:condition" mode="evaluate.effectivity">
    <xsl:variable name="this.effectivity.attribute">
      <xsl:value-of select="." />
    </xsl:variable>
    
    <xsl:message>This attribute: <xsl:value-of select="$this.effectivity.attribute" /></xsl:message>
    <xsl:message>The parameter: <xsl:value-of select="$effectivity.condition" /></xsl:message>

    <xsl:if test="$this.effectivity.attribute = $effectivity.condition">
      <xsl:text>false</xsl:text>
      <xsl:message>TEST RESULT: <xsl:value-of select="." /></xsl:message>
    </xsl:if>
  </xsl:template>
  
  -->

</xsl:stylesheet>
