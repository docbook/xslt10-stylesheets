<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
		xmlns:xl="http://www.w3.org/1999/xlink"
		exclude-result-prefixes="l xl"
		version="1.0">
  
  <xsl:import href="https://cdn.docbook.org/release/xsl/current/html/docbook.xsl"/>

  <xsl:param name="admon.graphics" select="1"></xsl:param>
  <xsl:param name="section.autolabel" select="1"></xsl:param>
  <xsl:param name="section.label.includes.component.label" select="1"></xsl:param>
  <xsl:param name="blurb-file"/>
  <xsl:param name="locale-file"/>
  
  <xsl:template match="chapter[@role='blurb']/para">
    <p><span>Translation: </span>
      <xsl:for-each select="document($blurb-file)/chapter/chapterinfo/othercredit">
	<a>
	  <xsl:attribute name="href">
	    <xsl:text>mailto:</xsl:text>
	    <xsl:value-of select=".//email"/>
	  </xsl:attribute>
	  <xsl:call-template name="person.name"/>
	</a>
	<xsl:choose>
	  <xsl:when test="position() = last()"/> <!-- do nothing -->
	  <xsl:otherwise>
	    <xsl:text>, </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </p>
    <xsl:apply-templates select="document($blurb-file)/chapter/para"/>
  </xsl:template>
  
  <xsl:template match="othercredit/affiliation"/>
  <xsl:template match="othercredit/contrib"/>

  <xsl:template match="editor[position()=1]" mode="titlepage.mode">
    <p>
      <span class="localizedby"><xsl:text>Localization: </xsl:text>
      <xsl:choose>
	<xsl:when test="document($locale-file)//authorgroup">
	  <xsl:apply-templates select="document($locale-file)//authorgroup" mode="titlepage.mode"/>
	</xsl:when>
	<xsl:when test="document($locale-file)//author">
	  <xsl:apply-templates select="document($locale-file)//authorgroup" mode="titlepage.mode"/>
	</xsl:when>
	<xsl:otherwise>[none credited]</xsl:otherwise>
      </xsl:choose>
      </span>
    </p>
     <p>
      <span class="editedby"><xsl:call-template name="gentext.edited.by"/><xsl:text>: </xsl:text></span>
      <span class="{name(.)}"><xsl:call-template name="person.name"/></span>
    </p>
  </xsl:template>

  <xsl:template match="authorgroup" mode="titlepage.mode">
    <xsl:for-each select="author">
      <xsl:call-template name="person.name"/>
      <xsl:choose>
	<xsl:when test="position() = last()"/> <!-- do nothing -->
	<xsl:otherwise>
	  <xsl:text>, </xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates select="editor[position()=1]" mode="titlepage.mode"/>
  </xsl:template>

<xsl:template name="l10n.language">
  <!-- This is a modified version of the l10n.language that makes it possible -->
  <!-- to get the English-language name of the current lang (instead of just -->
  <!-- the code). -->
  <xsl:param name="target" select="."/>
  <xsl:param name="xref-context" select="false()"/>
  <xsl:param name="get.english.language.name" select="0"/>

  <xsl:variable name="mc-language">
    <xsl:choose>
      <xsl:when test="$l10n.gentext.language != ''">
        <xsl:value-of select="$l10n.gentext.language"/>
      </xsl:when>

      <xsl:when test="$xref-context or $l10n.gentext.use.xref.language != 0">
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][1]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>
        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][1]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>

        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="language" select="translate($mc-language,
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                        'abcdefghijklmnopqrstuvwxyz')"/>

  <xsl:variable name="adjusted.language">
    <xsl:choose>
      <xsl:when test="contains($language,'-')">
        <xsl:value-of select="substring-before($language,'-')"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="substring-after($language,'-')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=$adjusted.language]">
      <xsl:choose>
	<xsl:when test="$get.english.language.name = 1">
	  <xsl:value-of select="$l10n.xml/l:i18n/l:l10n[@language=$adjusted.language]/@english-language-name"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$adjusted.language"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- try just the lang code without country -->
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=substring-before($adjusted.language,'_')]">
      <xsl:choose>
	<xsl:when test="$get.english.language.name = 1">
	  <xsl:value-of select="$l10n.xml/l:i18n/l:l10n[substring-before($adjusted.language,'_')]/@english-language-name"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="substring-before($adjusted.language,'_')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- or use the default -->
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No localization exists for "</xsl:text>
        <xsl:value-of select="$adjusted.language"/>
        <xsl:text>" or "</xsl:text>
        <xsl:value-of select="substring-before($adjusted.language,'_')"/>
        <xsl:text>". Using default "</xsl:text>
        <xsl:value-of select="$l10n.gentext.default.language"/>
        <xsl:text>".</xsl:text>
      </xsl:message>
      <xsl:value-of select="$l10n.gentext.default.language"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction('dbcurrentlang')">
  <xsl:call-template name="l10n.language">
    <xsl:with-param name="get.english.language.name">1</xsl:with-param>
  </xsl:call-template>
  <xsl:text> (</xsl:text>
  <xsl:call-template name="l10n.language"/>
  <xsl:text>)</xsl:text>
</xsl:template>
  
</xsl:stylesheet>
