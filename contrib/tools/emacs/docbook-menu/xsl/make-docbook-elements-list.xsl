<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <xsl:output method="text"/>
  <!--
   * $Id$
   *
   * Transform TDG Element Reference TOC HTML file into lisp code to
   * for making an Emacs menu
   *
   * Run this on the part2.html or part2-x.html file in the TDG distro
   * to create a "docbook-elements-alphabetical.el" file; e.g.,
   *
   *  xsltproc -html make-docbook-elements-list.xsl > docbook-elements-alphabetical.el
   *
   * $Revision$ $Date$ $Author$ -->

  <xsl:template match="/">
    <xsl:text
     >(defvar docbook-elements-alphabetical
    (list "DocBook: Element Reference"
    </xsl:text>
     <xsl:for-each select="//dd/dl/dt/a">
	  <xsl:text>["</xsl:text>
	  <xsl:value-of select="translate(normalize-space(..), '&#x22;', '')"/>
	  <xsl:text>"
	  (browse-url (concat tdg-base "/</xsl:text><xsl:value-of
	  select="@href"/><xsl:text>")) t]
	  </xsl:text>
	</xsl:for-each>
	<xsl:text>)&#10;</xsl:text>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>