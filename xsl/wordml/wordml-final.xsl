<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
  exclude-result-prefixes='w v w10 sl aml wx o dt'>

  <xsl:output method='xml' indent="yes" encoding='UTF-8'/>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ******************************************************************** -->

  <xsl:strip-space elements='*'/>
  <xsl:preserve-space elements='w:t'/>

  <xsl:template match="w:body">
    <!-- let's assume an article document element for the moment -->
    <article>
      <xsl:apply-templates/>
    </article>
  </xsl:template>

  <xsl:template match='wx:sub-section'>
    <xsl:element name='{substring-before(w:p[1]/w:pPr/w:pStyle/@w:val, "-")}'>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match='w:p'>
    <xsl:choose>
      <xsl:when test='w:pPr/w:pStyle/@w:val = "blockerror"'>
        <xsl:comment>
          <xsl:apply-templates/>
        </xsl:comment>
      </xsl:when>
      <xsl:when test='substring-after(w:pPr/w:pStyle/@w:val, "-") = "title"'>
        <title>
          <xsl:apply-templates/>
        </title>
      </xsl:when>
      <xsl:otherwise>
        <para>
          <xsl:apply-templates/>
        </para>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='w:r'>
    <xsl:choose>
      <xsl:when test='w:rPr/w:rStyle/@w:val = "section-level"'/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
