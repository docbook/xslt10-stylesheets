<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:param name="filename-prefix" select="''"/>
<xsl:param name="html.ext" select="'.html'"/>
<xsl:param name="output-root" select="''"/>
<xsl:param name="source-dir" select="''"/>

<xsl:output method="text"/>

<xsl:template match="autolayout">
<xsl:message>
    <xsl:text>target dource directory is </xsl:text>
    <xsl:value-of select="$source-dir"/>
</xsl:message>
      <xsl:text>website: </xsl:text>
      <xsl:apply-templates select="toc" mode="all"/>
      <xsl:apply-templates select="notoc" mode="all"/>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:apply-templates select="toc"/>
      <xsl:apply-templates select="notoc"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>distclean: clean
&#9;rm -f </xsl:text>
      <xsl:text>autolayout.xml depends.tabular</xsl:text>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:text>clean:
&#9;rm -f </xsl:text>
      <xsl:apply-templates select="toc" mode="all"/>
      <xsl:apply-templates select="notoc" mode="all"/>
      <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="toc">

<!--
  <xsl:apply-templates select="." mode="calculate-dir"/>
-->
  <xsl:variable name="page-source-dir">
    <xsl:apply-templates select="." mode="calculate-source-dir"/>
  </xsl:variable>
<xsl:message>
    <xsl:text>page-source-dir </xsl:text>
    <xsl:value-of select="$page-source-dir"/>
</xsl:message>
  <xsl:if test="$source-dir ='' or $source-dir = $page-source-dir">
    <xsl:call-template name="output-root"/>
    <xsl:value-of select="@dir"/>
    <xsl:value-of select="$filename-prefix"/>
    <xsl:value-of select="@filename"/>
    <xsl:value-of select="$html.ext"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@page"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select=".//tocentry"/>
</xsl:template>

<xsl:template match="tocentry|notoc">
<!--
  <xsl:apply-templates select="." mode="calculate-dir"/>
-->
  <xsl:variable name="page-source-dir">
    <xsl:apply-templates select="." mode="calculate-source-dir"/>
  </xsl:variable>
<xsl:message>
    <xsl:text>page-source-dir </xsl:text>
    <xsl:value-of select="$page-source-dir"/>
</xsl:message>
  <xsl:if test="$source-dir ='' or $source-dir = $page-source-dir">
    <xsl:if test="@filename">
      <xsl:call-template name="output-root"/>
      <xsl:value-of select="@dir"/>
      <xsl:value-of select="$filename-prefix"/>
      <xsl:value-of select="@filename"/>
      <xsl:value-of select="$html.ext"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@page"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="toc" mode="all">
  <xsl:apply-templates select=".//tocentry" mode="all"/>
<!--
  <xsl:apply-templates select="." mode="calculate-dir"/>
-->
  <xsl:variable name="page-source-dir">
    <xsl:apply-templates select="." mode="calculate-source-dir"/>
  </xsl:variable>
  <xsl:if test="$source-dir ='' or $source-dir = $page-source-dir">
    <xsl:call-template name="output-root"/>
    <xsl:value-of select="@dir"/>
    <xsl:value-of select="$filename-prefix"/>
    <xsl:value-of select="@filename"/>
    <xsl:value-of select="$html.ext"/>
    <xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="tocentry|notoc" mode="all">
<!--
  <xsl:apply-templates select="." mode="calculate-dir"/>
-->

  <xsl:variable name="page-source-dir">
    <xsl:apply-templates select="." mode="calculate-source-dir"/>
  </xsl:variable>
  <xsl:if test="$source-dir ='' or $source-dir = $page-source-dir">

    <xsl:if test="@filename">
      <xsl:call-template name="output-root"/>
      <xsl:value-of select="@dir"/>
      <xsl:value-of select="$filename-prefix"/>
      <xsl:value-of select="@filename"/>
      <xsl:value-of select="$html.ext"/>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:if>

</xsl:template>


<xsl:template match="*" mode="calculate-source-dir">
  <xsl:choose>
    <xsl:when test='contains(@page,"/")'>
      <xsl:call-template name="get-path-component">
        <xsl:with-param name="path" select="@page"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-path-component">
  <xsl:param name="path"></xsl:param>

  <xsl:choose>
    <xsl:when test='contains($path,"/")'>
      <xsl:value-of select="substring-before($path,'/')"/>
      <xsl:text>/</xsl:text>
      <xsl:call-template name="get-path-component">
        <xsl:with-param name="path" select="substring-after($path,'/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="*" mode="calculate-dir">
  <xsl:choose>
    <xsl:when test="starts-with(@dir, '/')">
      <!-- if the directory on this begins with a "/", we're done... -->
      <xsl:value-of select="substring-after(@dir, '/')"/>
<!--
      <xsl:if test="@dir != '/'">
        <xsl:text>/</xsl:text>
      </xsl:if>
-->
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="calculate-dir"/>
      <xsl:if test="@dir">
        <xsl:value-of select="@dir"/>
<!--
        <xsl:text>/</xsl:text>
-->
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="@dir">
        <xsl:value-of select="@dir"/>
<!--
        <xsl:text>/</xsl:text>
-->
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output-root">
  <xsl:if test="$output-root != ''">
    <xsl:value-of select="$output-root"/>
    <xsl:text>/</xsl:text>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
