<!--  ======================================================================  -->
<!--
 |
 |file:  html/website-tabular.xsl
 |
 -->
<!--
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="html doc"
                version="1.0">
 -->

<!-- ==================================================================== -->

<!-- Netscape gets badly confused if it sees a CSS style... -->
<xsl:param name="admon.style" select="''"/>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">graphics/</xsl:param>
<xsl:param name="admon.graphics.extension">.gif</xsl:param>

<xsl:attribute-set name="table.properties">
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">0</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.navigation.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navotocwidth -->
  <xsl:attribute name="bgcolor">
    <xsl:choose>
      <xsl:when test="/webpage/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="/webpage/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/autolayout/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="$autolayout/autolayout/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$navbgcolor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navobodywidth -->
  <xsl:attribute name="bgcolor">
    <xsl:value-of select="$textbgcolor"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="body.columns" select="2"/>

<!-- ==================================================================== -->


<xsl:template name="home.navhead">
  <xsl:text>Navhead</xsl:text>
</xsl:template>

<xsl:template name="home.navhead.upperright">
  <xsl:text>Upper-right</xsl:text>
</xsl:template>

<xsl:template name="home.navhead.cell">
  <td width="50%" valign="middle" align="left">
    <xsl:call-template name="home.navhead"/>
  </td>
</xsl:template>

<xsl:template name="home.navhead.upperright.cell">
  <td width="50%" valign="middle" align="right">
    <xsl:call-template name="home.navhead.upperright"/>
  </td>
</xsl:template>

<xsl:template name="home.navhead.separator">
  <hr/>
</xsl:template>



<xsl:template name="hspacer">
  <!-- nop -->
</xsl:template>

<xsl:template match="config[@param='filename']" mode="head.mode">
</xsl:template>

<xsl:template match="webtoc">
  <!-- nop -->
</xsl:template>

<!--
</xsl:stylesheet>
 -->
