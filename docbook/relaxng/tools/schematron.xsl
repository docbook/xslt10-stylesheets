<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <s:schema>
      <s:pattern name="Mutually exclusive attributes">
	<xsl:apply-templates select="//ctrl:other-attribute"/>
      </s:pattern>
      <s:pattern name="Required titles">
	<xsl:apply-templates select="//rng:ref[@name='docbook.info.titlereq']"
			     mode="requireTitle"/>
      </s:pattern>
      <s:pattern name="Required titles (without subtitles)">
	<xsl:apply-templates select="//rng:ref[@name='docbook.info.titleonlyreq']"
			     mode="requireTitleOnly"/>
      </s:pattern>
      <s:pattern name="Forbidden titles">
	<xsl:apply-templates select="//rng:ref[@name='docbook.info.titleforbidden']"
			     mode="refuseTitle"/>
      </s:pattern>
    </s:schema>
  </xsl:template>

  <xsl:template match="ctrl:other-attribute">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="enumDef" select="key('defs', @enum-name)"/>
    <xsl:variable name="otherDef" select="key('defs', @other-name)"/>
    <xsl:variable name="enumName" select="$enumDef//rng:attribute[1]/@name"/>
    <xsl:variable name="otherValue"
		  select="$otherDef//rng:attribute[@name=$enumName][1]//rng:value[1]"/>
    <xsl:variable name="otherAttr"
		  select="$otherDef//rng:attribute[@name!=$enumName][1]/@name"/>
    <xsl:variable name="classes"
		  select="//rng:define[.//rng:ref[@name=$name]]"/>

    <xsl:choose>
      <xsl:when test="count($classes) = 0">
	<xsl:call-template name="makeRule">
	  <xsl:with-param name="name" select="@name"/>
	  <xsl:with-param name="enumName" select="$enumName"/>
	  <xsl:with-param name="otherAttr" select="$otherAttr"/>
	  <xsl:with-param name="otherValue" select="$otherValue"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="$classes">
	  <xsl:call-template name="makeRule">
	    <xsl:with-param name="name" select="@name"/>
	    <xsl:with-param name="enumName" select="$enumName"/>
	    <xsl:with-param name="otherAttr" select="$otherAttr"/>
	    <xsl:with-param name="otherValue" select="$otherValue"/>
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="makeRule">
    <xsl:param name="name"/>
    <xsl:param name="enumName"/>
    <xsl:param name="otherAttr"/>
    <xsl:param name="otherValue"/>

    <xsl:variable name="elemName" select="substring-before($name, '.')"/>

    <s:rule context="{$elemName}">
      <s:assert test="(@{$enumName} = '{$otherValue}' and @{$otherAttr}) or (@{$enumName} != '{$otherValue}' and not(@{$otherAttr}))">
	<xsl:text>Conflicting values for @</xsl:text>
	<xsl:value-of select="$enumName"/>
	<xsl:text> and @</xsl:text>
	<xsl:value-of select="$otherAttr"/>
	<xsl:text> on </xsl:text>
	<xsl:value-of select="$elemName"/>
      </s:assert>
    </s:rule>
  </xsl:template>

  <xsl:template match="rng:ref" mode="requireTitle">
    <xsl:variable name="elemName"
		  select="substring-before(ancestor::rng:define/@name, '.')"/>
    <xsl:if test="key('defs', concat('db.', $elemName))">
      <s:rule context="{$elemName}">
	<s:assert test="title|info/title">
	  <xsl:text>title is required on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
	<s:assert test="count(info/title) &lt;= 1">
	  <xsl:text>title must appear only once on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
      </s:rule>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:ref" mode="requireTitleOnly">
    <xsl:variable name="elemName"
		  select="substring-before(ancestor::rng:define/@name, '.')"/>
    <xsl:if test="key('defs', concat('db.', $elemName))">
      <s:rule context="{$elemName}">
	<s:assert test="title|info/title">
	  <xsl:text>title is required on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
	<s:assert test="count(info/title) &lt;= 1">
	  <xsl:text>title must appear only once on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
	<s:assert test="not(subtitle|info/subtitle)">
	  <xsl:text>subtitle is not allowed on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
      </s:rule>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:ref" mode="refuseTitle">
    <xsl:variable name="elemName"
		  select="substring-before(ancestor::rng:define/@name, '.')"/>
    <xsl:if test="key('defs', concat('db.', $elemName))">
      <s:rule context="{$elemName}">
	<s:assert test="not(title|info/title)">
	  <xsl:text>title is not allowed on </xsl:text>
	  <xsl:value-of select="$elemName"/>
	</s:assert>
      </s:rule>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
