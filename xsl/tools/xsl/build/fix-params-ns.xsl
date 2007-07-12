<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:saxon="http://icl.com/saxon"
  exclude-result-prefixes="fo"
>
  <xsl:import href="./identity.xsl"/>
  <xsl:output method="xml"
  encoding="ASCII"
  saxon:character-representation="decimal"
  indent="no"/>
  <xsl:template match="*[not(local-name() = 'stylesheet')][namespace-uri() = 'http://www.w3.org/1999/XSL/Transform']">
    <!-- * copy all xsl:* elements but strip the extra namespaces nodes -->
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[not(local-name() = 'exclude-result-prefixes')]"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*[not(local-name() = 'stylesheet')][namespace-uri() = 'http://www.w3.org/1999/XSL/Format']">
    <!-- * copy all fo:* elements but strip the extra namespace nodes -->
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*[local-name() = 'substitution']">
    <xsl:element name="substitution">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*[local-name() = 'code']">
    <xsl:element name="code">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
