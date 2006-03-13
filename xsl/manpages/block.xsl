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

<!-- ==================================================================== -->

<xsl:template match="caution|important|note|tip|warning">
  <xsl:call-template name="nested-section-title"/>
  <xsl:apply-templates/>
</xsl:template> 

<xsl:template match="formalpara">
  <xsl:variable name="title.wrapper">
    <bold><xsl:value-of select="normalize-space(title[1])"/></bold>
  </xsl:variable>
  <xsl:text>.PP&#10;</xsl:text>
  <!-- * don't put linebreak after head; instead render it as a "run in" -->
  <!-- * head, that is, inline, with a period and space following it -->
  <xsl:apply-templates mode="bold" select="exsl:node-set($title.wrapper)"/>
  <xsl:text>. </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="formalpara/para">
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="para">
  <xsl:text>.PP&#10;</xsl:text>
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="simpara">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>.sp&#10;</xsl:text>
</xsl:template>

<xsl:template match="literallayout|programlisting|screen|
                     address|synopsis|funcsynopsisinfo">
  <!-- * Yes, address, synopsis, and funcsynopsisinfo are verbatim environments. -->

  <xsl:choose>
    <!-- * Check to see if this verbatim item is within a parent element that -->
    <!-- * allows mixed content. -->
    <!-- * -->
    <!-- * If it is within a mixed-content parent, then a line space is -->
    <!-- * already added before it by the mixed-block template, so we don't -->
    <!-- * need to add one here. -->
    <!-- * -->
    <!-- * If it is not within a mixed-content parent, then we need to add a -->
    <!-- * line space before it. -->
    <xsl:when test="parent::caption|parent::entry|parent::para|
                    parent::td|parent::th" /> <!-- do nothing -->
    <xsl:otherwise>
      <xsl:text>.sp&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="self::funcsynopsisinfo">
      <!-- * All funcsynopsisinfo content must be rendered in bold -->
      <!-- * The man(7) man page says this: -->
      <!-- * -->
      <!-- *   For functions, the arguments are always specified using -->
      <!-- *   italics, even in the SYNOPSIS section, where the rest of -->
      <!-- *   the function is specified in bold. -->
      <!-- * -->
      <!-- * If you take a look through the contents of the man/man2 -->
      <!-- * directory on your system, you'll see that most existing pages -->
      <!-- * do follow that "bold everything in function synopsis " rule. -->
      <!-- * -->
      <xsl:text>.\" bold on&#10;</xsl:text>
      <xsl:text>.ft B&#10;</xsl:text>
      <xsl:text>.nf&#10;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>.fi&#10;</xsl:text>
      <xsl:text>.\" bold off&#10;</xsl:text>
      <xsl:text>.ft&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- * Other verbatims do not need to get bolded -->
      <xsl:text>.nf&#10;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>.fi&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <!-- * if first following sibling node of this verbatim -->
  <!-- * environment is a text node, output a line of space before it -->
  <xsl:if test="following-sibling::node()[1][name(.) = '']">
    <xsl:text>.sp&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:text>.IP&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<!-- * suppress abstract -->
<xsl:template match="abstract"/>

</xsl:stylesheet>
