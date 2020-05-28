<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                exclude-result-prefixes="doc"
                version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:strip-space elements="localization locale context"/>

<!-- Load the language file passed as a parameter into a variable -->
<xsl:param name="locale.file" select="''"/>
<xsl:param name="locale" select="document($locale.file, /)"/>

<xsl:template match="doc:*"/>

<xsl:template match="locale">
  <l:l10n>
    <xsl:copy-of select="$locale/locale/@*"/>

    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * This file is generated automatically. </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * To submit changes to this file upstream (to the DocBook Project) </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * do not submit an edited version of this file. Instead, submit an </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * edited version of the source file at the following location: </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> *  <xsl:value-of
    select="concat('https://docbook.svn.sourceforge.net/svnroot/docbook/trunk/gentext/locale/',$locale.file, ' ')"/> </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * E-mail the edited <xsl:value-of select="$locale.file"/> source file to: </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> * </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> *  docbook-developers@lists.sourceforge.net </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> ******************************************************************** </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> This file is part of the XSL DocBook Stylesheet distribution. </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> See ../README or https://cdn.docbook.org/release/xsl/current/ for </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> copyright and other information. </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> ******************************************************************** </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> In these files, % with a letter is used for a placeholder: </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>   %t is the current element's title </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>   %s is the current element's subtitle (if applicable)</xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>   %n is the current element's number label</xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>   %p is the current element's page number (if applicable)</xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> ******************************************************************** </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>

    <xsl:apply-templates/>

  </l:l10n>
</xsl:template>

<xsl:template match="gentext|dingbat">
  <xsl:text>&#10;</xsl:text>
  <xsl:variable name="key"><xsl:value-of  select="@key"/></xsl:variable>
  <!-- Use localized text if available -->
  <!-- otherwise use english -->
  <xsl:variable name="localnode"
      select="$locale/locale/*[local-name(.) = local-name(current())][@key = $key]"/>
  <xsl:variable name="localtext" select="$localnode/@text"/>
  <xsl:element name="l:{name(.)}">
    <xsl:copy-of select="@key"/>
    <xsl:attribute name="text">
      <xsl:choose>
        <xsl:when test="$localtext">
          <xsl:value-of select="$localtext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!-- Add lang=en if not in localized file or if marked as en there -->
    <xsl:if test="$localnode/@lang = 'en' or not($localnode)">
      <xsl:attribute name="lang">en</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="context">
  <xsl:text>&#10;</xsl:text>
  <xsl:element name="l:{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="template">
  <xsl:variable name="key"><xsl:value-of  select="@name"/></xsl:variable>
  <xsl:variable name="styleatt"><xsl:value-of  select="@style"/></xsl:variable>
  <xsl:variable name="context"><xsl:value-of select="ancestor::context[1]/@name"/></xsl:variable>
  <!-- Use localized text if available -->
  <!-- otherwise use english -->
  <xsl:variable name="localnode"
      select="$locale/locale/context[@name = $context]/template[@name = $key 
                and (($styleatt = '' and not(@style)) 
                      or @style = $styleatt) ]"/>
   <xsl:if test="count($localnode) &gt; 1">
     <xsl:message>Warning: more than one localized template
	  for context <xsl:value-of select="$context"/>
	  and name <xsl:value-of select="$key"/>.
     </xsl:message>
  </xsl:if>
  <l:template>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="text">
      <xsl:choose>
        <xsl:when test="$localnode">
          <xsl:apply-templates select="$localnode/node()" mode="template-text">
	    <xsl:with-param name="en-locale" select="/*[1]"/>
	</xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()" mode="template-text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="$localnode/@lang = 'en' or not($localnode)">
      <xsl:attribute name="lang">en</xsl:attribute>
    </xsl:if>
  </l:template>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="letters">
  <!-- Use localized text if available -->
  <!-- otherwise use english -->
  <xsl:variable name="localnode"
      select="$locale/locale/*[local-name(.) = local-name(current())]"/>
  <xsl:element name="l:{name(.)}">
    <!-- Add lang=en if not in localized file or if marked as en there -->
    <xsl:if test="$localnode/@lang = 'en' or not($localnode)">
      <xsl:attribute name="lang">en</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$localnode">
        <!-- <xsl:copy-of select="$localnode/*"/> -->
        <xsl:for-each select="$localnode/*">
          <xsl:element name="l:{name(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
          </xsl:element>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:copy-of select="*"/> -->
        <xsl:for-each select="*">
          <xsl:element name="l:{name(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
          </xsl:element>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="template-text">
  <xsl:param name="en-locale"/>

  <xsl:variable name="key" select="local-name(.)"/>
  <!-- Use localized text if available -->
  <!-- otherwise use english -->
  <xsl:variable name="gentext" 
                select="$locale//gentext[@key = $key]
                      | $locale//dingbat[@key = $key]"/>

  <xsl:variable name="en-gentext" 
                select="$en-locale//gentext[@key=$key]
                       |$en-locale//dingbat[@key=$key]"/>
  <xsl:choose>
    <xsl:when test="count($gentext) &gt; 1">
      <xsl:message terminate="yes">
        <xsl:text>There is more than one gentext key '</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>' in the '</xsl:text>
        <xsl:value-of select="ancestor::locale/@language"/>
        <xsl:text>' locale.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:when test="count($gentext) = 1">
      <xsl:value-of select="$gentext[1]/@text"/>
    </xsl:when>
    <xsl:when test="count($en-gentext) = 1">
      <xsl:message terminate="no">
        <xsl:text>There is no gentext key '</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>' in the '</xsl:text>
        <xsl:value-of select="ancestor::locale/@language"/>
        <xsl:text>' locale. Using English.</xsl:text>
      </xsl:message>
      <xsl:value-of select="$en-gentext[1]/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        <xsl:text>There is no gentext key '</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>' in the '</xsl:text>
        <xsl:value-of select="ancestor::locale/@language"/>
        <xsl:text>' locale or in English.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="template-text">
  <xsl:value-of select="."/>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
