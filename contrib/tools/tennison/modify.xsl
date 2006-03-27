<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY tab "&#x9;">
<!ENTITY lf "&#xA;">
<!ENTITY cr "&#xD;">
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
		version='1.0'>

  <xsl:output method="xml"
	      indent="no"
              />
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
 
  <!-- * this template modifies the value of the "punctuation" variable -->
  <!-- * from the original markup.xsl so that it does not contain the -->
  <!-- * dot/period character -->
  <xsl:template match="*[local-name = 'variable'][@name = 'punctuation']">
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">
           <!-- * remove dot from the list of punctuation chars -->
        <xsl:text>,:;!?&tab;&cr;&lf;&nbsp; &quot;'()[]&lt;>{}</xsl:text>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
