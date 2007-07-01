<?xml version="1.0"?>
<!-- * -->
<!-- * This is a static copy of the w2docbook.xsl file from the litprog module. -->
<!-- * It *MAY NOT BE UP TO DATE*. It is provided for the convenience of -->
<!-- * developers who don't want to generate the file themselves from -->
<!-- * the sources in the ../litprog directory. To create a fresh up-to-date -->
<!-- * copy of the file, check out that directory from the source repository -->
<!-- * and build it. -->
<!-- * -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" exclude-result-prefixes="xsl src xml" version="1.0">

  <xsl:output method="xml" indent="no"/>

  <xsl:preserve-space elements="*"/>

  <xsl:template match="*">
    <xsl:element name="{local-name(.)}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="src:fragment" priority="2">
    <programlisting id="{@*[local-name() = 'id']}">
      <xsl:apply-templates mode="escaped"/>
    </programlisting>
  </xsl:template>

  <xsl:template match="src:fragref" priority="2">
    <xref linkend="{@linkend}"/>
  </xsl:template>

  <xsl:template match="*" mode="escaped">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>="</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="escaped"/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="comment()" mode="escaped">
    <xsl:text>&lt;!--</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>--&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="escaped">
    <xsl:text>&lt;?</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:value-of select="."/>
    <xsl:text>?&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="escaped">
    <xsl:copy/>
  </xsl:template>
</xsl:stylesheet>
