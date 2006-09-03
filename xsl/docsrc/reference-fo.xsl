<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">
  <xsl:import href="../fo/docbook.xsl"/>
  <xsl:param name="xep.extensions">1</xsl:param>
  <xsl:param name="paper.type">A4</xsl:param>
  <xsl:param name="draft.watermark.image"></xsl:param>
  <xsl:param name="hyphenation">false</xsl:param>
  <xsl:param name="hyphenate.verbatim">1</xsl:param>
  <xsl:param name="alignment">left</xsl:param>
  <xsl:param name="refentry.generate.name">1</xsl:param>
  <xsl:param name="refentry.generate.title">0</xsl:param>
  <xsl:param name="refentry.pagebreak">0</xsl:param>
  <xsl:param name="shade.verbatim">1</xsl:param>
  <xsl:param name="variablelist.as.blocks">1</xsl:param>
  <xsl:param name="ulink.show">1</xsl:param>
  <xsl:param name="ulink.footnotes">1</xsl:param>
  <xsl:param name="index.on.type">1</xsl:param>
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color">blue</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">\#E0E0E0</xsl:attribute>
    <xsl:attribute name="padding-left">4pt</xsl:attribute>
    <xsl:attribute name="padding-right">4pt</xsl:attribute>
    <xsl:attribute name="padding-top">4pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.5"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.3"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.1"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.5"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">\</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.8"></xsl:value-of>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
