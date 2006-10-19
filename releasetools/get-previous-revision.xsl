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

  <xsl:output method="text"/>

  <xsl:template match="/">
    <!-- * The value of the "revision" attribute on the commit element -->
    <!-- * indicates the last time the file was checked in; since this -->
    <!-- * is the VERSION file, and that only gets checked in once per -->
    <!-- * release, that value should indicate the revision number -->
    <!-- * associated with the latest release. -->
    <xsl:value-of select="concat(/lists/list/entry/commit/@revision,'&#x0a;')"/>
  </xsl:template>

</xsl:stylesheet>
