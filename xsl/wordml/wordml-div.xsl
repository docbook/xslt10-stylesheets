<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">

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
    <xsl:copy>
      <xsl:variable name='sect1s'
        select='w:p[w:pPr/w:pStyle/@w:val = "section-title" and
                *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 1] |
                w:p[w:pPr/w:pStyle/@w:val = "sect1-title"]'/>

      <xsl:choose>
        <xsl:when test='$sect1s'>
          <xsl:apply-templates select='$sect1s[1]/preceding-sibling::*'/>

          <xsl:apply-templates select='$sect1s[1]' mode='section1'>
            <xsl:with-param name='sect1s'
              select='$sect1s[position() != 1]'/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='w:p' mode='section1'>
    <xsl:param name='sect1s' select='/..'/>

    <xsl:choose>
      <xsl:when test='$sect1s and 
                      (w:pPr/w:pStyle/@w:val = "sect1-title" or
                       (w:pPr/w:pStyle/@w:val = "section-title" and
                      *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 1))'>
        <xsl:variable name='sect2s'
          select='$sect1s[1]/preceding-sibling::w:p[
                  w:pPr/w:pStyle/@w:val = "sect2-title" or
                  (w:pPr/w:pStyle/@w:val = "section-title" and
                  *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 2)]'/>

        <xsl:call-template name='make-sect1'>
          <xsl:with-param name='sect1s' select='$sect1s'/>
          <xsl:with-param name='sect2s' select='$sect2s'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name='sect2s'
          select='following-sibling::w:p[
                  w:pPr/w:pStyle/@w:val = "sect2-title" or
                  (w:pPr/w:pStyle/@w:val = "section-title" and
                  *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 2)]'/>
        <xsl:call-template name='make-sect1'>
          <xsl:with-param name='sect1s' select='$sect1s'/>
          <xsl:with-param name='sect2s' select='$sect2s'/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='make-sect1'>
    <xsl:param name='sect1s' select='/..'/>
    <xsl:param name='sect2s' select='/..'/>

    <wx:sub-section>
      <xsl:call-template name='copy'/>

      <xsl:apply-templates select='following-sibling::*[1]' mode='section2'>
        <xsl:with-param name='nextSect1' select='$sect1s[1]'/>
        <xsl:with-param name='sect2s' select='$sect2s'/>
      </xsl:apply-templates>
    </wx:sub-section>

    <xsl:apply-templates select='$sect1s[1]' mode='section1'>
      <xsl:with-param name='sect1s' select='$sect1s[position() != 1]'/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='w:p' mode='section2'>
    <xsl:param name='nextSect1' select='/..'/>
    <xsl:param name='sect2s' select='/..'/>

    <xsl:choose>
      <xsl:when test='generate-id() = generate-id($nextSect1)'/>

      <xsl:when test='w:pPr/w:pStyle/@w:val = "sect2-title" or
                      (w:pPr/w:pStyle/@w:val = "section-title" and
                      *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 2)'>
        <xsl:variable name='nextSect2'
          select='following-sibling::w:p[w:pPr/w:pStyle/@w:val = "sect2-title" or
                  (w:pPr/w:pStyle/@w:val = "section-title" and
                  *[2]/self::w:r[w:rPr/w:rStyle/@w:val = "section-level"]/w:t = 2)][1]'/>

        <wx:sub-section>
          <xsl:call-template name='copy'/>

          <xsl:apply-templates select='following-sibling::*[1]' mode='terminal'>
            <xsl:with-param name='nextSect1' select='$nextSect1'/>
            <xsl:with-param name='nextSect2' select='$nextSect2'/>
            <xsl:with-param name='sect2s' select='$sect2s'/>
          </xsl:apply-templates>
        </wx:sub-section>

        <xsl:if test='count($sect2s|$nextSect2) = count($sect2s)'>
          <xsl:apply-templates select='$nextSect2' mode='section2'>
            <xsl:with-param name='nextSect1' select='$nextSect1'/>
            <xsl:with-param name='sect2s' select='$sect2s'/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='copy'/>

        <xsl:apply-templates select='following-sibling::*[1]' mode='section2'>
          <xsl:with-param name='nextSect1' select='$nextSect1'/>
          <xsl:with-param name='sect2s' select='$sect2s'/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='w:p' mode='terminal'>
    <xsl:param name='nextSect1' select='/..'/>
    <xsl:param name='nextSect2' select='/..'/>
    <xsl:param name='sect2s' select='/..'/>

    <xsl:choose>
      <xsl:when test='generate-id() = generate-id($nextSect1)'/>
      <xsl:when test='generate-id() = generate-id($nextSect2)'/>

      <xsl:otherwise>
        <xsl:call-template name='copy'/>

        <xsl:apply-templates select='following-sibling::*[1]' mode='terminal'>
          <xsl:with-param name='nextSect1' select='$nextSect1'/>
          <xsl:with-param name='nextSect2' select='$nextSect2'/>
          <xsl:with-param name='sect2s' select='$sect2s'/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='*'>
    <xsl:call-template name='copy'/>
  </xsl:template>
  <xsl:template match='*' mode='section1'>
    <xsl:param name='sect1s' select='/..'/>

    <xsl:call-template name='copy'/>

    <xsl:apply-templates select='following-sibling::*[1]' mode='section1'>
      <xsl:with-param name='sect1s' select='$sect1s'/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match='*' mode='section2'>
    <xsl:param name='nextSect1' select='/..'/>
    <xsl:param name='sect2s' select='/..'/>

    <xsl:call-template name='copy'/>

    <xsl:apply-templates select='following-sibling::*[1]' mode='section2'>
      <xsl:with-param name='nextSect1' select='$nextSect1'/>
      <xsl:with-param name='sect2s' select='$sect2s'/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match='*' mode='terminal'>
    <xsl:param name='nextSect1' select='/..'/>
    <xsl:param name='nextSect2' select='/..'/>
    <xsl:param name='sect2s' select='/..'/>

    <xsl:call-template name='copy'/>

    <xsl:apply-templates select='following-sibling::*[1]' mode='terminal'>
      <xsl:with-param name='nextSect1' select='$nextSect1'/>
      <xsl:with-param name='nextSect2' select='$nextSect2'/>
      <xsl:with-param name='sect2s' select='$sect2s'/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name='copy'>
    <xsl:copy>
      <xsl:for-each select='@*'>
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
