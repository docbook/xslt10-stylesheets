<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <xsl:output method="text"/>
  <!--
   * $Id$
   *
   * Transform DocBook Stylesheet Reference Doc TOC into lisp code to
   * for making an Emacs menu.
   * 
   * Run this on either these files in the DocBook XSL
   * stylesheets distro:
   *
   *   doc/html/index.html
   *   doc/fo/index.html
   *
   * Feed it a value for the 'format' parameter to
   * indicate which you're generating; e.g.,
   *
   *   xsltproc -html -stringparam format "html" \
   *     make-docbook-xsl-params-list.xsl index.html
   *
   * $Revision$ $Date$ $Author$ -->

  <xsl:param name="format">html</xsl:param>

  <xsl:template match="/">
    <xsl:text
     >(defvar docbook-xsl-params-</xsl:text><xsl:value-of
     select="$format"/>
    <xsl:text
     >
      (list "DocBook: XSL Parameter Reference - </xsl:text
     ><xsl:value-of
     select="translate($format,
     'abcdefghijklmnopqrstuvwxyz',
     'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:text
     >"&#10;</xsl:text>
     <xsl:for-each select="//dl">
      <xsl:for-each select="dt">
	<xsl:if test="span[@class='reference']">
	<xsl:for-each select="span[@class='reference']">
	  <xsl:text>(list "</xsl:text><xsl:value-of
	  select="normalize-space(.)"/><xsl:text>"
	  </xsl:text>
	</xsl:for-each>
	<xsl:for-each select="following-sibling::dd[1]/dl/dt/a">
	  <xsl:text>["</xsl:text>
	  <xsl:value-of select="normalize-space(..)"/>
	  <xsl:text>"
	  (browse-url (concat "file:///" docbookxsldir "/doc/</xsl:text><xsl:value-of
	  select="$format"/><xsl:text>/</xsl:text><xsl:value-of
	  select="@href"/><xsl:text>")) t]
	  </xsl:text>
	</xsl:for-each>
	<xsl:text>)&#10;</xsl:text>
	</xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:text>)
    )</xsl:text>
  </xsl:template>

</xsl:stylesheet>