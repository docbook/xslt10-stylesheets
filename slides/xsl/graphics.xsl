<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>

<xsl:param name="graphics.dir" select="''"/>

<xsl:param name="bullet.image" select="'bullet.gif'"/>
<xsl:param name="right.image" select="'right.gif'"/>
<xsl:param name="left.image" select="'left.gif'"/>

<xsl:param name="plus.image" select="'plus.gif'"/>
<xsl:param name="minus.image" select="'minus.gif'"/>

<xsl:param name="hidetoc.image" select="'hidetoc.gif'"/>
<xsl:param name="showtoc.image" select="'showtoc.gif'"/>

<xsl:template name="graphics-file">
  <xsl:param name="image" select="'bullet.gif'"/>

  <xsl:variable name="source.graphics.dir">
    <xsl:call-template name="dbhtml-attribute">
      <xsl:with-param name="pis" select="/processing-instruction('dbhtml')"/>
      <xsl:with-param name="attribute" select="'graphics-dir'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$source.graphics.dir != ''">
      <xsl:value-of select="$source.graphics.dir"/>
      <xsl:text>/</xsl:text>
    </xsl:when>
    <xsl:when test="$graphics.dir != ''">
      <xsl:value-of select="$graphics.dir"/>
      <xsl:text>/</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:value-of select="$image"/>
</xsl:template>

<xsl:template name="bullet.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$bullet.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="left.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$left.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="right.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$right.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="plus.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$plus.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="minus.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$minus.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="hidetoc.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$hidetoc.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="showtoc.image">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="$showtoc.image"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="w3c.bleft.image">
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="'bleft.png'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="w3c.left.image">
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="'left.png'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="w3c.bright.image">
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="'bright.png'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="w3c.right.image">
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="'right.png'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="w3c.toc.image">
  <xsl:call-template name="graphics-file">
    <xsl:with-param name="image" select="'toc.png'"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
