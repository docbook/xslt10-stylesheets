<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template name="formal.object">
  <xsl:param name="placement" select="'before'"/>

  <div class="{name(.)}">
    <xsl:call-template name="anchor"/>
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
        <xsl:call-template name="formal.object.heading"/>
        <xsl:apply-templates/>
        <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
        <xsl:apply-templates/>
        <xsl:call-template name="formal.object.heading"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template name="formal.object.heading">
  <p class="title">
    <b>
      <xsl:apply-templates select="." mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </b>
  </p>
</xsl:template>

<xsl:template name="informal.object">
  <div class="{name(.)}">
    <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
    <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
  </div>
</xsl:template>

<xsl:template name="semiformal.object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:choose>
    <xsl:when test="title">
      <xsl:call-template name="formal.object">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="informal.object"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure|table|example">
  <xsl:variable name="param.placement"
                select="substring-after(normalize-space($formal.title.placement),
                                        concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="formal.object">
    <xsl:with-param name="placement" select="$placement"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="equation">
  <xsl:variable name="param.placement"
                select="substring-after(normalize-space($formal.title.placement),
                                        concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="semiformal.object">
    <xsl:with-param name="placement" select="$placement"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="figure/title"></xsl:template>
<xsl:template match="table/title"></xsl:template>
<xsl:template match="example/title"></xsl:template>
<xsl:template match="equation/title"></xsl:template>

<xsl:template match="informalfigure">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="informaltable">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="informalequation">
  <xsl:call-template name="informal.object"/>
</xsl:template>

</xsl:stylesheet>
