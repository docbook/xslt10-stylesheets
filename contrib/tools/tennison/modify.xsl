<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY tab "&#x9;">
<!ENTITY lf "&#xA;">
<!ENTITY cr "&#xD;">
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  version='1.0'>

  <xsl:output method="xml"
    indent="no"/>

  <xsl:template match="/">
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * This is a MODIFIED version of markup.xsl; original is at: </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:comment> *   http://www.jenitennison.com/xslt/utilities/markup.xsl</xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * This modified version of markup.xsl is used as part of </xsl:comment>
    <xsl:comment> * the internal build of the DocBook Project XSL Stylesheets </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:comment> *   https://cdn.docbook.org/release/xsl/current/ </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * Copyright 2007 The DocBook Project &lt;docbook-developers@sf.net> </xsl:comment>
    <xsl:comment> * </xsl:comment>
    <xsl:comment> * This modified version may be redistributed and modified </xsl:comment>
    <xsl:comment> * under the same terms as the original (see detals below) </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- * this template modifies the value of the "punctuation" variable -->
  <!-- * from the original markup.xsl so that it does not contain the -->
  <!-- * dot/period character, and adds "/", "=", and "*" -->
  <xsl:template match="*[local-name() = 'variable'][@name = 'punctuation']">
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">punctuation</xsl:attribute>
      <xsl:text>,:;!?&tab;&cr;&lf;&nbsp; &quot;'()[]&lt;>{}/=*</xsl:text>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
