<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template match="inlineequation">
  <xsl:choose>
    <xsl:when test="$passivetex.extensions != 0 and $tex.math.in.alt != ''">
      <xsl:apply-templates select="alt"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equation/mediaobject | informalequation/mediaobject">
  <xsl:if test="$passivetex.extensions = 0 or $tex.math.in.alt = ''">
    <fo:block>
      <xsl:call-template name="select.mediaobject"/>
      <xsl:apply-templates select="caption"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="equation/graphic | informalequation/graphic">
  <xsl:if test="$passivetex.extensions = 0 or $tex.math.in.alt = ''">
    <fo:block>
      <xsl:call-template name="process.image"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="inlineequation/alt">
  <xsl:if test="$passivetex.extensions != 0 and $tex.math.in.alt != ''">
    <xsl:processing-instruction name="xmltex">
      <xsl:text>$</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>$</xsl:text>
    </xsl:processing-instruction>
  </xsl:if>
</xsl:template>

<xsl:template match="equation/alt | informalequation/alt">
  <xsl:if test="$passivetex.extensions != 0 and $tex.math.in.alt != ''">
    <xsl:processing-instruction name="xmltex">
      <xsl:text>$$</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>$$</xsl:text>
    </xsl:processing-instruction>
  </xsl:if>
</xsl:template>

<xsl:template match="alt">
  <xsl:if test="$passivetex.extensions != 0 and $tex.math.in.alt != ''">
    <xsl:message>
      Your equation is misplaced. It should be in inlineequation, equation or informalequation.
    </xsl:message>
  </xsl:if>
</xsl:template>

<!-- just send the MathML all the way through... -->
<xsl:template match="mml:*">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
