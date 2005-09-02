<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output indent="yes"/>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:include href="../VERSION"/>

<xsl:template match="/">

  <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>  XML Catalog file for DocBook XSL Stylesheets distribution </xsl:comment>

    <rewriteURI uriStartString="http://docbook.sourceforge.net/release/xsl/current/" rewritePrefix="./"/>
    <rewriteSystem systemIdStartString="http://docbook.sourceforge.net/release/xsl/current/" rewritePrefix="./"/>

    <rewriteURI uriStartString="http://docbook.sourceforge.net/release/xsl/{$VERSION}/" rewritePrefix="./"/>
    <rewriteSystem systemIdStartString="http://docbook.sourceforge.net/release/xsl/{$VERSION}/" rewritePrefix="./"/>

  </catalog>

</xsl:template>

</xsl:stylesheet>
