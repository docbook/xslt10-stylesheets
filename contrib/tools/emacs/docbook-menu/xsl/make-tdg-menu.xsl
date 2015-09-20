<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <xsl:output method="text"/>
  <!--
   * $Id$
   *
   * Transform TDG into lisp code to for making an Emacs menu
   *
   * Run this on the docbook.html or docbook-x.html file in the TDG distro
   * to create a "docbook-tdg-menu.el" file; e.g.,
   *
   *  xsltproc -html make-tdg-menu.xsl > docbook-tdg-menu.el
   *
   * $Revision$ $Date$ $Author$ -->

  <xsl:template match="/">
    <xsl:text
     >(defvar docbook-tdg-toc
    (list "DocBook: The Definitive Guide"
    </xsl:text>

     <xsl:for-each select="//div[@class='toc']/dl">
      <xsl:for-each select="dt">
	  <xsl:text>(list "</xsl:text><xsl:value-of
	  select="normalize-space(.)"/><xsl:text>"
	  </xsl:text>
	<xsl:for-each select="following-sibling::dd[1]/dl/dt/a">
	  <xsl:text>["</xsl:text>
	  <xsl:value-of select="normalize-space(..)"/>
	  <xsl:text>"
	  (browse-url (concat "file:///" homedir "/doc/tdg/en/html/</xsl:text><xsl:value-of
	  select="@href"/><xsl:text>")) t]
	  </xsl:text>
	</xsl:for-each>
	</xsl:for-each>
	<xsl:text>)&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>)
    )</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>