<?xml version="1.0" encoding="windows-1250"?>
<!DOCTYPE stylesheet [
<!ENTITY amp 
"<xsl:text disable-output-escaping='yes'>&amp;amp;</xsl:text>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8"/>


<xsl:template match="/">
  <html><body>
    <xsl:apply-templates/>
  </body></html>
</xsl:template>

<xsl:template match="para">
  <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="title">
  
</xsl:template>

<xsl:template match="//ulink|//literal|//parameter|//varname|//sgmltag">
  <b><xsl:value-of select="."/></b>
</xsl:template>

<xsl:template match="//quote">
  <cite><xsl:value-of select="."/></cite>
</xsl:template>

<xsl:template match="//programlisting|//screen">
  <pre><xsl:value-of select="."/></pre>
</xsl:template>

<xsl:template match="//variablelist">
  <ul>
  <xsl:for-each select="./varlistentry">
    <li><b><xsl:value-of select="term"/></b> - <xsl:value-of select="listitem"/></li>
  </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>
