<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
                exclude-result-prefixes="xsl xi src"
                version='1.0'>

<xsl:output method="xml" indent="no"/>


<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="refdescription">
  <refsect1>
    <title></title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refauthor">
  <refsect1>
    <title>Author</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refversion">
  <refsect1>
    <title>Version</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refparameter">
  <refsect1>
    <title>Parameters</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refreturn">
  <refsect1>
    <title>Returns</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refexception|refthrows">
  <refsect1>
    <title>Exceptions</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refsee">
  <refsect1>
    <title>See</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refsince">
  <refsect1>
    <title>Since</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refserial">
  <refsect1>
    <title>Serial</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

<xsl:template match="refdeprecated">
  <refsect1>
    <title>Deprecated</title>
    <xsl:apply-templates/>
  </refsect1>
</xsl:template>

</xsl:stylesheet>
