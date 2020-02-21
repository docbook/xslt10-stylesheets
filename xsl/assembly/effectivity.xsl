<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns="http://docbook.org/ns/docbook"
  exclude-result-prefixes="exsl d xlink d"
  version="1.0">

<xsl:include href="../profiling/profile-mode.xsl"/>
<xsl:include href="../common/addns.xsl"/>
  
<!-- NOTE: If a structure or module is filtered out due to a matching effectivity attribute, children of that structure or module cannot be filtered in using another effectivity attribute. -->

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
  <xsl:param name="effectivity.separator">;</xsl:param> 
  <!-- NOTE: The separator param is set to ; by default; this is ensure the conditional processing will work even if user does not pass in a 
  separator -->

  <xsl:param name="profile.arch" select="$effectivity.arch"/>
  <xsl:param name="profile.audience" select="$effectivity.audience"/>
  <xsl:param name="profile.condition" select="$effectivity.condition" />
  <xsl:param name="profile.conformance" select="$effectivity.conformance"/>
  <xsl:param name="profile.os" select="$effectivity.os"/>
  <xsl:param name="profile.outputformat" select="$effectivity.outputformat"/>
  <xsl:param name="profile.revision" select="$effectivity.revision"/>
  <xsl:param name="profile.security" select="$effectivity.security"/>
  <xsl:param name="profile.userlevel" select="$effectivity.userlevel"/>
  <xsl:param name="profile.vendor" select="$effectivity.vendor"/>
  <xsl:param name="profile.wordsize" select="$effectivity.wordsize"/>
  <xsl:param name="profile.lang"/>
  <xsl:param name="profile.revisionflag"/>
  <xsl:param name="profile.role"/>
  <xsl:param name="profile.status"/>
  <xsl:param name="profile.attribute"/>
  <xsl:param name="profile.value"/>
  <xsl:param name="profile.separator" select="$effectivity.separator" />



  <xsl:template match="d:module[@resourceref] | d:structure[@resourceref]" mode="evaluate.effectivity">
    <xsl:apply-templates mode="evaluate.effectivity" />
  </xsl:template>
  
  <xsl:template match="d:filterout" mode="evaluate.effectivity">
    
    <xsl:variable name="effectivity.match.arch">
      <!-- <xsl:message>INFO: The value of effectivity.arch as passed in is <xsl:value-of select="$effectivity.arch" /> ... </xsl:message>
      <xsl:message>INFO: The value of @arch as read from the XML file is <xsl:value-of select="@arch" /> ... </xsl:message> -->
    <xsl:if test="@arch">  
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.arch" />
        <xsl:with-param name="b" select="@arch" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.audience">
      <!-- <xsl:if test="effectivity.audience">
        <xsl:message>INFO: The value of effectivity.audience as passed in is <xsl:value-of select="$effectivity.audience" /> ... </xsl:message>
        <xsl:message>INFO: The value of @audience as read from the XML file is <xsl:value-of select="@audience" /> ... </xsl:message>
      </xsl:if> -->
    <xsl:if test="@audience">
      <xsl:message>INFO: The value of effectivity.audience as passed in is <xsl:value-of select="$effectivity.audience" /> ... </xsl:message>
      <xsl:message>INFO: The value of @audience as read from the XML file is <xsl:value-of select="@audience" /> ... </xsl:message>
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.audience" />
        <xsl:with-param name="b" select="@audience" />
        <xsl:with-param name="sep" select="effectivity.separator" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.condition">
      <!-- <xsl:message>INFO: The value of effectivity.condition as passed in is <xsl:value-of select="$effectivity.condition" /> ... </xsl:message>
      <xsl:message>INFO: The value of @condition as read from the XML file is <xsl:value-of select="@condition" /> ... </xsl:message> -->
    <xsl:if test="@condition">  
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.condition" />
        <xsl:with-param name="b" select="@condition" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.conformance">
      <!-- <xsl:message>INFO: The value of effectivity.conformance as passed in is <xsl:value-of select="$effectivity.conformance" /> ... </xsl:message>
      <xsl:message>INFO: The value of @conformance as read from the XML file is <xsl:value-of select="@conformance" /> ... </xsl:message> -->
    <xsl:if test="@conformance">  
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.conformance" />
        <xsl:with-param name="b" select="@conformance" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.os">
      <!-- <xsl:message>INFO: The value of effectivity.os as passed in is <xsl:value-of select="$effectivity.os" /> ... </xsl:message>
      <xsl:message>INFO: The value of @os as read from the XML file is <xsl:value-of select="@os" /> ... </xsl:message> -->
    <xsl:if test="@os">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.os" />
        <xsl:with-param name="b" select="@os" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.outputformat">
      <xsl:message>INFO: The value of effectivity.outputformat as passed in is <xsl:value-of select="$effectivity.outputformat" /> ... </xsl:message>
      <xsl:message>INFO: The value of @outputformat as read from the XML file is <xsl:value-of select="@outputformat" /> ... </xsl:message>
    <xsl:if test="@outputformat">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.outputformat" />
        <xsl:with-param name="b" select="@outputformat" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.revision">
      <!-- <xsl:message>INFO: The value of effectivity.revision as passed in is <xsl:value-of select="$effectivity.revision" /> ... </xsl:message>
      <xsl:message>INFO: The value of @revision as read from the XML file is <xsl:value-of select="@revision" /> ... </xsl:message> -->
    <xsl:if test="@revision">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.revision" />
        <xsl:with-param name="b" select="@revision" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.security">
      <!-- <xsl:message>INFO: The value of effectivity.security as passed in is <xsl:value-of select="$effectivity.security" /> ... </xsl:message>
      <xsl:message>INFO: The value of @security as read from the XML file is <xsl:value-of select="@security" /> ... </xsl:message> -->
    <xsl:if test="@security">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.security" />
        <xsl:with-param name="b" select="@security" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.userlevel">
      <!-- <xsl:message>INFO: The value of effectivity.userlevel as passed in is <xsl:value-of select="$effectivity.userlevel" /> ... </xsl:message>
      <xsl:message>INFO: The value of @userlevel as read from the XML file is <xsl:value-of select="@userlevel" /> ... </xsl:message> -->
      <xsl:if test="@userlevel">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.userlevel" />
        <xsl:with-param name="b" select="@userlevel" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.vendor">
      <!-- <xsl:message>INFO: The value of effectivity.vendor as passed in is <xsl:value-of select="$effectivity.vendor" /> ... </xsl:message>
      <xsl:message>INFO: The value of @vendor as read from the XML file is <xsl:value-of select="@vendor" /> ... </xsl:message> -->
    <xsl:if test="@vendor">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.vendor" />
        <xsl:with-param name="b" select="@vendor" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.wordsize">
      <!-- <xsl:message>INFO: The value of effectivity.wordsize as passed in is <xsl:value-of select="$effectivity.wordsize" /> ... </xsl:message>
      <xsl:message>INFO: The value of @wordize as read from the XML file is <xsl:value-of select="@wordsize" /> ... </xsl:message> -->
    <xsl:if test="@wordsize">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.wordsize" />
        <xsl:with-param name="b" select="@wordsize" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$effectivity.match.arch != ''">
        <xsl:text>exclude</xsl:text>        
        <xsl:message>INFO: filtering out a module or structure because the arch attribute value is set to <xsl:value-of select="$effectivity.arch" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.audience != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the audience attribute value is set to <xsl:value-of select="$effectivity.audience" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.condition != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the condition attribute value is set to <xsl:value-of select="$effectivity.condition" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.conformance != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the conformance attribute value is set to <xsl:value-of select="$effectivity.conformance" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.os != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the os attribute value is set to <xsl:value-of select="$effectivity.os" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.outputformat != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the outputformat attribute value is set to <xsl:value-of select="$effectivity.outputformat" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.revision != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the revision attribute value is set to <xsl:value-of select="$effectivity.revision" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.security != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the security attribute value is set to <xsl:value-of select="$effectivity.security" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.userlevel != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the userlevel attribute value is set to <xsl:value-of select="$effectivity.userlevel" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.vendor != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the vendor attribute value is set to <xsl:value-of select="$effectivity.vendor" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.wordsize != ''">
        <xsl:text>exclude</xsl:text>
        <xsl:message>INFO: filtering out a module or structure because the wordsize attribute value is set to <xsl:value-of select="$effectivity.wordsize" />.</xsl:message>
      </xsl:when>

      <xsl:otherwise>
        <xsl:message>INFO: no filterout attributes matched.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <!-- filterin logic -->
  <xsl:template match="d:filterin" mode="evaluate.effectivity">

    <xsl:variable name="effectivity.match.arch">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.arch as passed in is <xsl:value-of select="$effectivity.arch" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @arch as read from the XML file is <xsl:value-of select="@arch" /> ... </xsl:message> -->
    <xsl:if test="@arch">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.arch" />
        <xsl:with-param name="b" select="@arch" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.audience">
       <!-- <xsl:message>INFO (filterin): The value of effectivity.audience as passed in is <xsl:value-of select="$effectivity.audience" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @audience as read from the XML file is <xsl:value-of select="@audience" /> ... </xsl:message> -->
    <xsl:if test="@audience">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.audience" />
        <xsl:with-param name="b" select="@audience" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.condition">
       <!-- <xsl:message>INFO (filterin): The value of effectivity.condition as passed in is <xsl:value-of select="$effectivity.condition" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @condition as read from the XML file is <xsl:value-of select="@condition" /> ... </xsl:message> -->
    <xsl:if test="@condition">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.condition" />
        <xsl:with-param name="b" select="@condition" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.conformance">
       <!-- <xsl:message>INFO (filterin): The value of effectivity.conformance as passed in is <xsl:value-of select="$effectivity.conformance" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @conformance as read from the XML file is <xsl:value-of select="@conformance" /> ... </xsl:message> -->
    <xsl:if test="@conformance">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.conformance" />
        <xsl:with-param name="b" select="@conformance" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.os">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.os as passed in is <xsl:value-of select="$effectivity.os" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @os as read from the XML file is <xsl:value-of select="@os" /> ... </xsl:message> -->
      <xsl:if test="@os">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.os" />
        <xsl:with-param name="b" select="@os" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.outputformat">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.outputformat as passed in is <xsl:value-of select="$effectivity.outputformat" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @outputformat as read from the XML file is <xsl:value-of select="@outputformat" /> ... </xsl:message> -->
    <xsl:if test="@outputformat">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.outputformat" />
        <xsl:with-param name="b" select="@outputformat" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.revision">
       <!-- <xsl:message>INFO (filterin): The value of effectivity.revision as passed in is <xsl:value-of select="$effectivity.revision" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @revision as read from the XML file is <xsl:value-of select="@revision" /> ... </xsl:message> -->
    <xsl:if test="@revision">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.revision" />
        <xsl:with-param name="b" select="@revision" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.security">
       <!-- <xsl:message>INFO (filterin): The value of effectivity.security as passed in is <xsl:value-of select="$effectivity.security" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @security as read from the XML file is <xsl:value-of select="@security" /> ... </xsl:message> -->
    <xsl:if test="@security">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.security" />
        <xsl:with-param name="b" select="@security" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.userlevel">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.userlevel as passed in is <xsl:value-of select="$effectivity.userlevel" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @userlevel as read from the XML file is <xsl:value-of select="@userlevel" /> ... </xsl:message> -->
    <xsl:if test="@userlevel">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.userlevel" />
        <xsl:with-param name="b" select="@userlevel" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.vendor">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.vendor as passed in is <xsl:value-of select="$effectivity.vendor" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @vendor as read from the XML file is <xsl:value-of select="@vendor" /> ... </xsl:message> -->
    <xsl:if test="@vendor">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.vendor" />
        <xsl:with-param name="b" select="@vendor" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:variable name="effectivity.match.wordsize">
      <!-- <xsl:message>INFO (filterin): The value of effectivity.wordsize as passed in is <xsl:value-of select="$effectivity.wordsize" /> ... </xsl:message>
      <xsl:message>INFO (filterin): The value of @wordsize as read from the XML file is <xsl:value-of select="@wordsize" /> ... </xsl:message> -->
    <xsl:if test="@wordsize">
      <xsl:call-template name="cross.compare">
        <xsl:with-param name="a" select="$effectivity.wordsize" />
        <xsl:with-param name="b" select="@wordsize" />
      </xsl:call-template>
    </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$effectivity.match.arch != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO (filterin): including a module or structure because the arch attribute value is set to <xsl:value-of select="$effectivity.arch" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.audience != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the audience attribute value is set to <xsl:value-of select="$effectivity.audience" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.condition != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the condition attribute value is set to <xsl:value-of select="$effectivity.condition" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.conformance != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the conformance attribute value is set to <xsl:value-of select="$effectivity.conformance" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.os != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the os attribute value is set to <xsl:value-of select="$effectivity.os" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.outputformat != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the outputformat attribute value is set to <xsl:value-of select="$effectivity.outputformat" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.revision != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the revision attribute value is set to <xsl:value-of select="$effectivity.revision" />.</xsl:message> 
      </xsl:when>

      <xsl:when test="$effectivity.match.security != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the security attribute value is set to <xsl:value-of select="$effectivity.security" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.userlevel != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the userlevel attribute value is set to <xsl:value-of select="$effectivity.userlevel" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.vendor != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the vendor attribute value is set to <xsl:value-of select="$effectivity.vendor" />.</xsl:message>
      </xsl:when>

      <xsl:when test="$effectivity.match.wordsize != ''">
        <xsl:text>include</xsl:text>
        <xsl:message>INFO: including a module or structure because the wordsize attribute value is set to <xsl:value-of select="$effectivity.wordsize" />.</xsl:message>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>exclude</xsl:text>
        <!-- <xsl:message>INFO: No modules or structures matched attributes for inclusion.</xsl:message> -->
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
