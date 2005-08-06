<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

  xmlns:sfa="http://developer.apple.com/namespaces/sfa"
  xmlns:sf="http://developer.apple.com/namespaces/sf"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:appsl="http://developer.apple.com/namespaces/sl"

  xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"

  xmlns:node='http://xsltsl.org/node'
  xmlns:doc='http://www.oasis-open.org/docbook/xml/4.0'
  extension-element-prefixes='node'
  exclude-result-prefixes='doc sfa sf xsi appsl'>

  <xsl:import href='xsltsl/stdlib.xsl'/>

  <xsl:output method="xml" indent='yes'/>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ******************************************************************** -->

  <xsl:strip-space elements='*'/>
  <xsl:preserve-space elements='sf:p sf:span'/>

  <xsl:key name='styles'
	   match='sf:paragraphstyle[not(ancestor::appsl:section-prototypes)] |
		  sf:characterstyle[not(ancestor::appsl:section-prototypes)]'
	   use='@sf:ident|@sfa:ID'/>

  <xsl:template match='appsl:document'>
    <w:wordDocument>
      <!-- TODO: headers and footers -->
      <xsl:apply-templates select='sf:text-storage'/>
    </w:wordDocument>
  </xsl:template>

  <xsl:template match='sf:text-body'>
    <w:body>
      <xsl:apply-templates/>
    </w:body>
  </xsl:template>

  <xsl:template match='sf:text-storage'>
    <wx:sect>
      <wx:sub-section>
	<xsl:apply-templates/>
      </wx:sub-section>
    </wx:sect>
  </xsl:template>

  <xsl:template match='sf:p'>
    <w:p>
      <xsl:call-template name='find-style'/>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <xsl:template match='sf:span'>
    <w:r>
      <xsl:call-template name='find-style'/>

      <xsl:apply-templates/>
    </w:r>
  </xsl:template>

  <xsl:template match='text()'>
    <xsl:choose>
      <xsl:when test='ancestor::sf:span'>
	<w:t>
	  <xsl:value-of select='.'/>
	</w:t>
      </xsl:when>
      <xsl:otherwise>
	<w:r>
	  <w:t>
	    <xsl:value-of select='.'/>
	  </w:t>
	</w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='sf:section|sf:layout'>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match='sf:stylesheet|sf:stylesheet-ref |
		       sf:container-hint |
		       sf:page-start|sf:br |
		       sf:selection-start|sf:selection-end |
		       sf:insertion-point |
		       sf:ghost-text'/>

  <xsl:template match='*'>
    <xsl:message>element "<xsl:value-of select='name()'/>" not handled</xsl:message>
  </xsl:template>

  <xsl:template name='find-style'>
    <xsl:param name='ident' select='@sf:style'/>

    <xsl:variable name='para-style-name'
		  select='key("styles", $ident)/self::sf:paragraphstyle/@sf:name'/>
    <xsl:variable name='char-style-name'
		  select='key("styles", $ident)/self::sf:characterstyle/@sf:name'/>

    <xsl:choose>
      <xsl:when test='$para-style-name != ""'>
	<w:pPr>
	  <xsl:if test='$para-style-name != ""'>
	    <w:pStyle w:val='{$para-style-name}'/>
	  </xsl:if>
	</w:pPr>
      </xsl:when>
      <xsl:when test='$char-style-name != "" or
		      key("styles", $ident)/self::sf:characterstyle/sf:property-map/*'>
	<w:rPr>
	  <xsl:if test='$char-style-name != ""'>
	    <w:rStyle w:val='{$char-style-name}'/>
	  </xsl:if>
	  <xsl:apply-templates select='key("styles", $ident)/self::sf:characterstyle/sf:property-map/*'
			       mode='styles'/>
	</w:rPr>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='sf:bold' mode='styles'>
    <w:b/>
  </xsl:template>
  <xsl:template match='sf:italic' mode='styles'>
    <w:i/>
  </xsl:template>
  <xsl:template match='sf:underline' mode='styles'>
    <w:u/>
  </xsl:template>

</xsl:stylesheet>
