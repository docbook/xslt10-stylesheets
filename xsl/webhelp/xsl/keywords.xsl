<?xml version="1.0" encoding="US-ASCII"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:exslt="http://exslt.org/common" extension-element-prefixes="exslt" exclude-result-prefixes="exslt" version="1.0">

<!-- This customization of keywords.xsl causes any
indexterms to be added to the <meta name="keywords".../> tag
in the chunked html output. The main reason for doing this
is to improve support for Asian languages and help
compensate for the lack of stemming in the indexer. 

As implmented, this customization only supports situations
where all sections or sect* elements are chunked. For
example, if you have chunk.first.sections set to 0, any
indexterms in the first sections will not be appended to the
keywords list.  -->

<xsl:template match="keywordset"/>
<xsl:template match="subjectset"/>

<!-- ==================================================================== -->

<xsl:template match="keywordset" mode="html.header">
	<xsl:variable name="keywords">
	  <xsl:copy-of select="keyword"/>
	</xsl:variable>
	<xsl:variable name="indexterms">
	  <!-- Get all the indexterms in this section/chapter only (i.e. not in child sections -->
	  <xsl:copy-of select="ancestor::*[2]/*[not(self::*[starts-with(local-name(.),'sect')]) and not(self::chapter)]//indexterm/*|ancestor::*[2]/indexterm/*"/>
	</xsl:variable>
	<xsl:variable name="indexterms-unique">
	  <!-- Why am I doing this xsl:if? I can't remember. -->
<!-- 	  <xsl:if test="ancestor::*[substring(local-name(.),string-length(local-name(.)) - 3,4) = 'info']"> -->
		<xsl:for-each select="exslt:node-set($indexterms)/*[not(. = preceding-sibling::*) and not(. = exslt:node-set($keywords)/keyword)]">
		  <xsl:if test="position() = 1">, </xsl:if>
		  <xsl:value-of select="normalize-space(.)"/><xsl:if test="not(position() =  last())">, </xsl:if>
		</xsl:for-each>
<!-- 	  </xsl:if> -->
	</xsl:variable>
	
	<meta name="keywords">
	  <xsl:attribute name="content">
		<xsl:apply-templates select="keyword" mode="html.header"/><xsl:if test="following-sibling::keyword">, </xsl:if><xsl:value-of select="$indexterms-unique"/>
	  </xsl:attribute>
	</meta>
	
  </xsl:template>

  <xsl:template match="keyword" mode="html.header">
	<xsl:apply-templates/>
	<xsl:if test="following-sibling::keyword">, </xsl:if>
  </xsl:template>

  <xsl:template name="keywordset">
	<xsl:if test="not(self::book) and not(self::part) and not(./*/keywordset) and (./*[not(starts-with(local-name(.),'sect')) and not(self::chapter)]//indexterm or ./indexterm)">
	  <xsl:variable name="indexterms">
		<!-- Get all the indexterms in this section/chapter only (i.e. not in child sections -->
		<xsl:copy-of select="./*[not(self::section)]//indexterm/*|./indexterm/*"/>
	  </xsl:variable>
	  <xsl:variable name="indexterms-unique">
		<xsl:for-each select="exslt:node-set($indexterms)/*[not(. = preceding-sibling::*)]">
		  <xsl:value-of select="normalize-space(.)"/><xsl:if test="not(position() =  last())">, </xsl:if>
		</xsl:for-each>
	  </xsl:variable>
	  <xsl:if test="not($indexterms-unique = '')">
		<meta name="keywords">
		  <xsl:attribute name="content">
			<xsl:value-of select="$indexterms-unique"/>
		  </xsl:attribute>
		</meta>
	  </xsl:if>
	</xsl:if>
  </xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
