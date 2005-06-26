<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * Note: If you are looking for the <synopsis> element, you won't -->
<!-- * find any code here for handling it. It is a _verbatim_ -->
<!-- * environment; check the block.xsl file instead. -->

<xsl:template match="synopfragment">
  <xsl:text>.PP&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="group|arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="position()>1"><xsl:value-of select="$sepchar"/></xsl:if>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <!-- * do nothing -->
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="arg">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="local-name(.) = 'arg' and not(ancestor::arg)">
      <!-- * Prevent arg contents from getting wrapped and broken up -->
      <xsl:variable name="arg.wrapper">
        <Arg><xsl:value-of select="normalize-space($arg)"/></Arg>
      </xsl:variable>
      <xsl:apply-templates mode="prevent.line.breaking"
                           select="exsl:node-set($arg.wrapper)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:if test='arg'>
      <xsl:value-of select="$arg.choice.plain.close.str"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="command">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="function[not(ancestor::command)]">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="parameter[not(ancestor::command)]">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="sbr">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>.br&#10;</xsl:text>
</xsl:template>

<xsl:template match="cmdsynopsis">
  <xsl:text>.ad l&#10;</xsl:text>
  <xsl:text>.hy 0&#10;</xsl:text>
  <xsl:text>.HP </xsl:text>
  <xsl:value-of select="string-length (normalize-space (command)) + 1"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>.ad&#10;</xsl:text>
  <xsl:text>.hy&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcsynopsisinfo">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>.sp&#10;</xsl:text>
</xsl:template>

<!-- * Within funcsynopis output, disable hyphenation, and use -->
<!-- * left-aligned filling for the duration of the synopsis, so that -->
<!-- * line breaks only occur between separate paramdefs. -->
<xsl:template match="funcsynopsis">
  <xsl:text>.ad l&#10;</xsl:text>
  <xsl:text>.hy 0&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>.ad&#10;</xsl:text>
  <xsl:text>.hy&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcprototype">
  <xsl:variable name="funcprototype">
    <xsl:apply-templates select="funcdef"/>
  </xsl:variable>
  <xsl:text>.HP </xsl:text>
  <xsl:value-of select="string-length (normalize-space ($funcprototype)) - 6"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="normalize-space ($funcprototype)"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="*[local-name() != 'funcdef']"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcdef">
  <xsl:apply-templates select="." mode="prevent.line.breaking"/>
</xsl:template>

<xsl:template match="funcdef/function">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="void">
  <xsl:text>void);</xsl:text>
</xsl:template>

<xsl:template match="varargs">
  <xsl:text>...);</xsl:text>
</xsl:template>

<xsl:template match="paramdef">
  <xsl:apply-templates select="." mode="prevent.line.breaking"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="paramdef/parameter">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="funcparams">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- * By default, contents of the <type> element are rendered in bold. But we -->
<!-- * don't want them bolded if theu are inside a funcdef or paramdef; the -->
<!-- * following two templates cause them to be rendered without any special -->
<!-- * formatting when they are inside funcdef or paramdef. -->
<xsl:template match="funcdef/type">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="paramdef/type">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
