<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                version="1.0">

<xsl:key name="defs" match="rng:define" use="@name"/>
<xsl:key name="ctrlname" match="ctrl:other-attribute" use="@name"/>
<xsl:key name="ctrlenum" match="ctrl:other-attribute" use="@enum-name"/>
<xsl:key name="ctrlother" match="ctrl:other-attribute" use="@other-name"/>

<xsl:template match="rng:define" priority="200">
  <xsl:choose>
    <xsl:when test="key('ctrlenum', @name)"/>
    <xsl:when test="key('ctrlother', @name)"/>
    <xsl:when test="key('ctrlname', @name)">
      <xsl:message>Simplify attributes: <xsl:value-of select="@name"/></xsl:message>
      <xsl:variable name="otherattr" select="key('ctrlname', @name)"/>
      <rng:define name="{@name}">
	<rng:optional>
	  <rng:attribute name="{$otherattr/@other-name}"/>
	</rng:optional>
	<rng:optional>
	  <rng:attribute name="{$otherattr/@enum-name}">
	    <choice>
	      <xsl:copy-of select="key('defs', $otherattr/@enum-name)//rng:value"/>
	      <xsl:copy-of select="key('defs', $otherattr/@other-name)//rng:value"/>
	    </choice>
	  </rng:attribute>
	</rng:optional>
      </rng:define>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:choice[rng:ref[@name='docbook.text']]" priority="200">
  <xsl:message>Simplify choice with text</xsl:message>
  <rng:zeroOrMore>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </rng:zeroOrMore>
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
