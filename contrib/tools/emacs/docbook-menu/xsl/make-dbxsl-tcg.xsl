<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <xsl:output method="text"/>
  <!--
    * $Id$
    *
    * Run this on the DocBook XSL: The Complete Guide TOC index.html *
    * file to create an elisp file with code for making an Emacs menu.
    *
    *   xsltproc -html make-dbxsl-tcg.xsl index.html > dbk-xsltdg.el
    *
    * $Revision$ $Date$ $Author$ -->

  <xsl:template match="/">
    <xsl:text
    >(defvar docbook-menu-xsl-tcg</xsl:text>
    <xsl:text>&#10;(list "DocBook XSL: The Complete Guide"&#10;</xsl:text>
    <xsl:for-each select="//dl[parent::div[@class='toc']]">
      <xsl:for-each select="dt">
	<xsl:choose>
	  <xsl:when test="following-sibling::dd[1]">
	    <xsl:text>(list "</xsl:text><xsl:value-of
	    select="normalize-space(.)"/><xsl:text>"&#10;</xsl:text>
	    <xsl:for-each select="following-sibling::dd[1]/dl/dt">
	      <xsl:choose>
		<xsl:when test="following-sibling::dd[1]">
		  <xsl:text>(list "</xsl:text><xsl:value-of
		  select="normalize-space(.)"/><xsl:text>"&#10;</xsl:text>
		  <xsl:for-each select="following-sibling::dd[1]/dl/dt/span/a">
		    <xsl:text>["</xsl:text>
		    <xsl:value-of select="normalize-space(..)"/>
		    <xsl:text>"&#10;(browse-url (concat docbook-menu-xsl-tcg-uri "/</xsl:text><xsl:value-of
		    select="@href"/><xsl:text>")) t]&#10;</xsl:text>
		  </xsl:for-each>
		  <xsl:text>)&#10;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:for-each select="span/a">
		    <xsl:text>["</xsl:text>
		    <xsl:value-of select="normalize-space(..)"/>
		    <xsl:text>"&#10;(browse-url (concat docbook-menu-xsl-tcg-uri "/</xsl:text><xsl:value-of
		    select="@href"/><xsl:text>")) t]&#10;</xsl:text>
		  </xsl:for-each>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each>
	    <xsl:text>)&#10;</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:for-each select="span/a">
	      <xsl:text>["</xsl:text>
	      <xsl:value-of select="normalize-space(..)"/>
	      <xsl:text>"&#10;(browse-url (concat docbook-menu-xsl-tcg-uri "/</xsl:text><xsl:value-of
	      select="@href"/><xsl:text>")) t]&#10;</xsl:text>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
      <xsl:text>)&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>"DocBook XSL: The Complete Guide submenu for 'docbook-menu'."&#10;)</xsl:text>
  </xsl:template>

</xsl:stylesheet>