<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version="1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:exslt="http://exslt.org/common"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                extension-element-prefixes="func exslt"
                exclude-result-prefixes="func exslt i l d"
                xmlns:i="urn:cz-kosek:functions:index">

<!-- ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or http://cdn.docbook.org/ for copyright
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="kosek.imported">
  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:choose>
    <xsl:when test="contains($vendor, 'libxslt')">
      <xsl:message terminate="yes">
        <xsl:text>ERROR: the 'kosek' index method does not </xsl:text>
        <xsl:text>work with the xsltproc XSLT processor.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<!-- Returns index group code for given term  -->
<func:function name="i:group-index">
  <xsl:param name="term"/>
  
  <xsl:variable name="letters-rtf">
    <xsl:variable name="lang">
      <xsl:call-template name="l10n.language"/>
    </xsl:variable>
    
    <xsl:variable name="local.l10n.letters"
      select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:letters)[1]"/>
    
    <xsl:for-each select="$l10n.xml">
      <xsl:variable name="l10n.letters"
	select="document(key('l10n-lang', $lang)/@href)/l:l10n/l:letters[1]"/>

      <xsl:choose>
	<xsl:when test="count($local.l10n.letters) &gt; 0">
	  <xsl:copy-of select="$local.l10n.letters"/>
	</xsl:when>
	<xsl:when test="count($l10n.letters) &gt; 0">
	  <xsl:copy-of select="$l10n.letters"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>No "</xsl:text>
	    <xsl:value-of select="$lang"/>
	    <xsl:text>" localization of index grouping letters exists</xsl:text>
	    <xsl:choose>
	      <xsl:when test="$lang = 'en'">
		<xsl:text>.</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>; using "en".</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:message>

	  <xsl:copy-of select="document(key('l10n-lang', 'en'))/l:l10n/l:letters[1]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="letters" select="exslt:node-set($letters-rtf)/*"/>
  
  <xsl:variable name="long-letter-index" select="$letters/l:l[. = substring($term,1,2)]/@i"/>
  <xsl:variable name="short-letter-index" select="$letters/l:l[. = substring($term,1,1)]/@i"/>
  <xsl:variable name="letter-index">
    <xsl:choose>
      <xsl:when test="$long-letter-index">
        <xsl:value-of select="$long-letter-index"/>
      </xsl:when>
      <xsl:when test="$short-letter-index">
        <xsl:value-of select="$short-letter-index"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <func:result select="number($letter-index)"/>
</func:function>

<!-- Return index group letter for given group code -->
<func:function name="i:group-letter">
  <xsl:param name="index"/>

  <xsl:variable name="letters-rtf">
    <xsl:variable name="lang">
      <xsl:call-template name="l10n.language"/>
    </xsl:variable>
    
    <xsl:variable name="local.l10n.letters"
      select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:letters)[1]"/>
    
    <xsl:for-each select="$l10n.xml">
      <xsl:variable name="l10n.letters"
	select="document(key('l10n-lang', $lang)/@href)/l:l10n/l:letters[1]"/>

      <xsl:choose>
	<xsl:when test="count($local.l10n.letters) &gt; 0">
	  <xsl:copy-of select="$local.l10n.letters"/>
	</xsl:when>
	<xsl:when test="count($l10n.letters) &gt; 0">
	  <xsl:copy-of select="$l10n.letters"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>No "</xsl:text>
	    <xsl:value-of select="$lang"/>
	    <xsl:text>" localization of index grouping letters exists</xsl:text>
	    <xsl:choose>
	      <xsl:when test="$lang = 'en'">
		<xsl:text>.</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>; using "en".</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:message>

	  <xsl:copy-of select="document(key('l10n-lang', 'en')/@href)/l:l10n/l:letters[1]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="letters" select="exslt:node-set($letters-rtf)/*"/>
  
  <func:result select="$letters/l:l[@i=$index][1]"/>
</func:function>

<xsl:key name="group-code"
         match="d:indexterm"
         use="i:group-index(&primary;)"/>

  <func:function name="i:term-index">
    <xsl:param name="term"/>
    
    <xsl:variable name="letters-rtf">
      <xsl:variable name="lang">
        <xsl:call-template name="l10n.language"/>
      </xsl:variable>
      
      <xsl:variable name="local.l10n.letters"
        select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:letters)[1]"/>
      
      <xsl:for-each select="$l10n.xml">
        <xsl:variable name="l10n.letters"
          select="document(key('l10n-lang', $lang)/@href)/l:l10n/l:letters[1]"/>
        
        <xsl:choose>
          <xsl:when test="count($local.l10n.letters) &gt; 0">
            <xsl:copy-of select="$local.l10n.letters"/>
          </xsl:when>
          <xsl:when test="count($l10n.letters) &gt; 0">
            <xsl:copy-of select="$l10n.letters"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>No "</xsl:text>
              <xsl:value-of select="$lang"/>
              <xsl:text>" localization of index grouping letters exists</xsl:text>
              <xsl:choose>
                <xsl:when test="$lang = 'en'">
                  <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>; using "en".</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:message>
            <xsl:copy-of select="document(key('l10n-lang', 'en'))/l:l10n/l:letters[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="letters" select="exslt:node-set($letters-rtf)/*"/>
    
    <xsl:variable name="normalize.sort">
      <xsl:variable name="lang">
        <xsl:call-template name="l10n.language"/>
      </xsl:variable>
      
      <xsl:variable name="local.l10n.normalize.sort" select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:gentext[starts-with(@key,  'normalize.sort')])"/>
      
      <xsl:for-each select="$l10n.xml">
        <xsl:variable name="l10n.normalize.sort" select="document(key('l10n-lang', $lang)/@href)/l:l10n/l:gentext[starts-with(@key, 'normalize.sort')]"/>
        
        <xsl:choose>
          <xsl:when test="count($local.l10n.normalize.sort) &gt; 0">
            <xsl:copy-of select="$local.l10n.normalize.sort"/>
          </xsl:when>
          <xsl:when test="count($l10n.normalize.sort) &gt; 0">
            <xsl:copy-of select="$l10n.normalize.sort"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>No "</xsl:text>
              <xsl:value-of select="$lang"/>
              <xsl:text>" normalizing translate strings exists</xsl:text>
              <xsl:choose>
                <xsl:when test="$lang = 'en'">
                  <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>; using "en".</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:message>
            <xsl:copy-of select="document(key('l10n-lang', 'en')/@href)/l:l10n/l:gentext[starts-with(@key, 'normalize.sort.input')]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="normalize.sort.input">
      <xsl:value-of select="exslt:node-set($normalize.sort)/l:gentext[@key = 'normalize.sort.input']/@text"/>
    </xsl:variable>
    <xsl:variable name="normalize.sort.output">
      <xsl:value-of select="exslt:node-set($normalize.sort)/l:gentext[@key = 'normalize.sort.output']/@text"/>
    </xsl:variable>
    
    <xsl:variable name="term-index">
      <xsl:call-template name="calculate-term-index">
        <xsl:with-param name="term" select="$term"/>
        <xsl:with-param name="term-index" select="' '"/>
        <xsl:with-param name="letters" select="$letters"/>
        <xsl:with-param name="normalize.sort.input" select="$normalize.sort.input"/>
        <xsl:with-param name="normalize.sort.output" select="$normalize.sort.output"/>
      </xsl:call-template>
    </xsl:variable>
    
    <func:result select="normalize-space($term-index)"/>
  </func:function>
  
  <xsl:template name="calculate-term-index">
    <xsl:param name="term"/>
    <xsl:param name="term-index"/>
    <xsl:param name="letters"/>
    <xsl:param name="normalize.sort.input"/>
    <xsl:param name="normalize.sort.output"/>
    
    <xsl:variable name="firstletterinterm" select="substring($term, 1, 1)"/>
    <xsl:variable name="firstletterindex">
      <xsl:choose>
        <xsl:when test="$letters/l:l[. = $firstletterinterm]/@i">
          <xsl:variable name="indexnumber" select="$letters/l:l[. = $firstletterinterm]/@i"/> 
          <xsl:if test="$indexnumber &lt; 10">
            <xsl:text>0</xsl:text>
          </xsl:if>
          <xsl:value-of select="$indexnumber"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmpc" select="translate($firstletterinterm, $normalize.sort.input, $normalize.sort.output)"/>      
          <xsl:choose>
            <xsl:when test="$letters/l:l[. = $tmpc]/@i">
              <xsl:variable name="indexnumber" select="$letters/l:l[. = $tmpc]/@i"/> 
              <xsl:if test="$indexnumber &lt; 10">
                <xsl:text>0</xsl:text>
              </xsl:if>
              <xsl:value-of select="$indexnumber"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$firstletterinterm"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="restofterm" select="substring-after($term, $firstletterinterm)"/>
    
    <xsl:choose>
      <xsl:when test="$restofterm != ''">
        <xsl:call-template name="calculate-term-index">
          <xsl:with-param name="term" select="$restofterm"/>
          <xsl:with-param name="term-index" select="concat($term-index, ' ', $firstletterindex)"/>
          <xsl:with-param name="letters" select="$letters"/>
          <xsl:with-param name="normalize.sort.input" select="$normalize.sort.input"/>
          <xsl:with-param name="normalize.sort.output" select="$normalize.sort.output"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($term-index, ' ', $firstletterindex)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
