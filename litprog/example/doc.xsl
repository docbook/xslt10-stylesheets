<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
                xmlns:h="http://www.w3.org/TR/xhtml-basic"
                exclude-result-prefixes="h"
                version="1.0">

<xsl:output method="html"/>

<xsl:template match="*">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="src:fragment" priority="2">
  <table border="1" width="100%" summary="Source Fragment">
    <tr>
      <td>
        <a name="{@id}"/>
        <b>
          <xsl:apply-templates select="." mode="label.markup"/>
        </b>
      </td>
    </tr>
    <tr>
      <td>
        <pre>
          <xsl:apply-templates/>
        </pre>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="src:fragref" priority="2">
  <xsl:variable name="linkend" select="@linkend"/>
  <a href="#{$linkend}">
    <xsl:apply-templates select="//*[@id = $linkend]" mode="label.markup"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="//*[@id = $linkend]" mode="title.markup"/>
  </a>
</xsl:template>

<xsl:template match="src:fragment" mode="label.markup">
  <xsl:text>&#xA7;</xsl:text>
  <xsl:number from="/" level="any"/>
  <xsl:text>.</xsl:text>
</xsl:template>

<xsl:template match="src:fragment" mode="title.markup">
  <xsl:variable name="div" select="ancestor::h:div[1]"/>
  <xsl:if test="$div">
    <xsl:variable name="title" select="($div/h:h1[1]
                                       |$div/h:h2[1]
                                       |$div/h:h3[1]
                                       |$div/h:h4[1]
                                       |$div/h:h5[1]
                                       |$div/h:h6[1])[1]"/>
    <xsl:value-of select="$title"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
