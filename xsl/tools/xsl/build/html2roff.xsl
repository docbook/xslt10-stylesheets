<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl db ng"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or https://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * Standalone stylesheet for doing "HTML to roff" transformation of a -->
<!-- * stylesheet; which currently means that it transforms: -->
<!-- *  -->
<!-- *   - any <br/> instance into a line break -->
<!-- *   - any <pre></pre> instance into roff "no fill region" markup -->

<!-- ==================================================================== -->

  <xsl:output method="xml"
              encoding="UTF-8"
              indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template match="br">
    <xsl:element name="xsl:text">&#10;.&#10;</xsl:element>
  </xsl:template>

  <xsl:template match="pre">
    <xsl:element name="xsl:text">.sp&#10;</xsl:element>
    <xsl:element name="xsl:text">.nf&#10;</xsl:element>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    <xsl:element name="xsl:text">&#10;</xsl:element>
    <xsl:element name="xsl:text">.fi&#10;</xsl:element>
  </xsl:template>

</xsl:stylesheet>
