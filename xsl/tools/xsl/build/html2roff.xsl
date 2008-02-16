<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl db ng"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * Standalone stylesheet for doing "HTML to roff" transformation of a -->
<!-- * stylesheet; which currently means that it transforms: -->
<!-- *  -->
<!-- *   - any <br/> instance into a line break -->
<!-- *   - any <pre></pre> instance into roff "no fill region" markup -->
<!-- *   - HTML table markup for <funcprototype> into tbl(1) markup -->

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

  <!-- ==================================================================== -->

  <xsl:template match="*[@match = 'funcprototype']/table">
    <xsl:text>&#10;</xsl:text>
    <xsl:element name="text">.TS&#10;</xsl:element>
    <xsl:text>&#10;</xsl:text>
    <xsl:element name="text">tab(:);</xsl:element>
    <xsl:text>&#10;</xsl:text>
    <!-- * create the format section for this table by writing one line -->
    <!-- * for each void|varargs|paramdef instance; the line specifies -->
    <!-- * 3 cells because the HTML stylesheets generate 3 cells, the 3rd -->
    <!-- * of which seems to always be empty... -->
    <xsl:element name="xsl:for-each">
      <xsl:attribute name="select">(void|varargs|paramdef)</xsl:attribute>
      <xsl:element name="text">&#10;l l l</xsl:element>
    </xsl:element>
    <!-- * close out the format section -->
    <xsl:element name="text">.&#10;</xsl:element>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    <xsl:element name="text">&#10;.TE&#10;</xsl:element>
    <xsl:element name="xsl:if">
      <!-- * if this funcprototype has no paramdef children, then we -->
      <!-- * generate a blank line after it; otherwise, we surpress the -->
      <!-- * blank line because the table will be followed by another -->
      <!-- * table this lists the paramdef contents -->
      <xsl:attribute name="test">not(paramdef)</xsl:attribute>
      <xsl:element name="text">.sp 1&#10;</xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@match = 'funcprototype']/*[@test = 'paramdef']/table">
    <!-- * this is the table that lists the paramdef contents -->
    <xsl:text>&#10;</xsl:text>
    <xsl:element name="text">.TS&#10;</xsl:element>
    <xsl:text>&#10;</xsl:text>
    <xsl:element name="text">tab(:);</xsl:element>
    <xsl:text>&#10;</xsl:text>
    <!-- * create the format section for this table by writing one line -->
    <!-- * for each void|varargs|paramdef instance -->
    <xsl:element name="xsl:for-each">
      <xsl:attribute name="select">(void|varargs|paramdef)</xsl:attribute>
      <xsl:element name="text">&#10;l l</xsl:element>
    </xsl:element>
    <!-- * close out the format section -->
    <xsl:element name="text">.&#10;</xsl:element>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    <xsl:element name="text">&#10;.TE&#10;</xsl:element>
    <xsl:element name="text">.sp 1&#10;</xsl:element>
  </xsl:template>

  <xsl:template match="*[@match = 'funcprototype']//td
    |*[@match = 'void' or @match = 'varargs']//td[position() > 1]
    |*[@match = 'paramdef'][contains(@mode,'funcsynopsis')]//td[1]">
    <xsl:call-template name="format-funcprototype-cell"/>
  </xsl:template>

  <xsl:template match="*[@match = 'void' or @match = 'varargs']//td[1]
    |*[@match = 'paramdef'][not(contains(@mode,'funcsynopsis'))]//td[1]">
    <xsl:call-template name="format-funcprototype-cell">
      <!-- * we shift the contents of these cells over to the left to -->
      <!-- * close up space that’s otherwise added by tbl(1) -->
      <xsl:with-param name="horizontal-adjust">3</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*[@match = 'paramdef'][not(contains(@mode,'funcsynopsis'))]//td[position() > 1]">
    <xsl:call-template name="format-funcprototype-cell">
      <xsl:with-param name="is-closing-cell">1</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*[@match = 'paramdef'][contains(@mode,'funcsynopsis')]//td[position() > 1]">
    <xsl:call-template name="format-funcprototype-cell">
      <!-- * we shift the contents of these cells over to the left to -->
      <!-- * close up space that’s otherwise added by tbl(1) -->
      <xsl:with-param name="horizontal-adjust">4</xsl:with-param>
      <xsl:with-param name="is-closing-cell">1</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="format-funcprototype-cell">
    <xsl:param name="horizontal-adjust">0</xsl:param>
    <xsl:param name="is-closing-cell">0</xsl:param>
    <xsl:element name="text">T{&#10;</xsl:element>
    <!-- * wrap all content in these cells in no-fill sections, to -->
    <!-- * prevent groff from adding undesirable line breaks -->
    <xsl:element name="text">.nf&#10;</xsl:element>
    <xsl:if test="not($horizontal-adjust = 0)">
      <xsl:element name="text">\h'-<xsl:value-of select="$horizontal-adjust"/>'</xsl:element>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    <xsl:element name="text">&#10;.fi</xsl:element>
    <xsl:choose>
      <xsl:when test="not($is-closing-cell = 0)">
        <xsl:element name="text">&#10;T}&#10;</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="text">&#10;T}:</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
