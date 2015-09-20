<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version='1.0'>

  <xsl:output method="xml"
	      indent="yes"/>

  <xsl:variable name="files" select="/*/file"/>
  
  <xsl:template match="localefiles">
    <xsl:apply-templates select="file[1]"/>
  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="path" select="@path"/>
    <table summary="List of translators" border="1" xml:id="translators">
      <caption style="text-align: left">Current DocBook translators of record</caption>
      <thead>
	<tr>
	  <td>Language</td>
	  <td>Name</td>
	</tr>
      </thead>
      <xsl:for-each select="document($path)/*">
	<xsl:apply-templates select="//locale"/>
	<xsl:for-each select="$files[position() >1]">
	  <xsl:apply-templates select="document(@path)//locale"/>
	</xsl:for-each>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="locale">
    <tr>
      <xsl:text>&#10;</xsl:text>
      <td>
	<xsl:value-of select="@english-language-name"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="@language"/>
	<xsl:text>)</xsl:text>
      </td>
      <xsl:text>&#10;</xsl:text>
      <td>
	<xsl:choose>
	  <xsl:when test=".//author">
	    <xsl:apply-templates select=".//author"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <emphasis role="strong">No current translator on record</emphasis>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
      <xsl:text>&#10;</xsl:text>
    </tr>
  </xsl:template>
  
  <xsl:template match="author">
    <ulink>
      <xsl:attribute name="url">
	<xsl:text>mailto:</xsl:text>
	<xsl:value-of select=".//email"/>
      </xsl:attribute>
      <personname>
	<xsl:apply-templates select="*[local-name() != 'affiliation']"/>
      </personname>
    </ulink>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
	<xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="firstname">
    <firstname>
      <xsl:value-of select="."/>
    </firstname>
  </xsl:template>
  
  <xsl:template match="surname">
    <surname>
      <xsl:value-of select="."/>
    </surname>
  </xsl:template>

  <xsl:template match="othername">
    <othername>
      <xsl:value-of select="."/>
    </othername>
  </xsl:template>
</xsl:stylesheet>
