<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://docbook.sf.net/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <xsl:param name="docbook.rng"/>

  <xsl:output method="text"/>

  <xsl:template match="/">
    <!-- * Get the value of the first tagdatetag element in the document -->
    <!-- * that starts with a "V" (V1691, etc.). That is, hopefully, the -->
    <!-- * tag for the previous release. -->
    <xsl:for-each select="//*[local-name() = 'element'][@name]">
      <xsl:value-of select="@name"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
