<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://sagehill.net/xsl/target/1.0"
                version="1.0">

<!-- Templates for extracting cross reference information
     from a document for use in an xref database.
     It is included by targets.xsl and chunktargets.xsl.
     This was modified from Norm Walsh's original olink-common.xsl.
-->

<xsl:template match="/">
  <xsl:apply-templates mode="olink.mode"/>
</xsl:template>

<xsl:template name="attrs">
  <xsl:param name="nd" select="."/>

  <xsl:attribute name="element">
    <xsl:value-of select="local-name(.)"/>
  </xsl:attribute>

  <xsl:attribute name="href">
    <xsl:call-template name="olink.href.target">
      <xsl:with-param name="obj" select="$nd"/>
    </xsl:call-template>
  </xsl:attribute>

  <xsl:attribute name="name">
    <xsl:call-template name="gentext.element.name"/>
  </xsl:attribute>

  <xsl:variable name="num">
    <xsl:apply-templates select="$nd" mode="label.markup"/>
  </xsl:variable>

  <xsl:if test="$num">
    <xsl:attribute name="number">
      <xsl:value-of select="$num"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="$nd/@id">
    <xsl:attribute name="targetid">
      <xsl:value-of select="$nd/@id"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="$nd/@lang">
    <xsl:attribute name="lang">
      <xsl:value-of select="$nd/@lang"/>
    </xsl:attribute>
  </xsl:if>

</xsl:template>

<xsl:template name="div">
  <xsl:param name="nd" select="."/>

  <t:div>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <t:ttl>
      <xsl:apply-templates select="$nd" mode="title.markup"/>
    </t:ttl>
<!--    <t:divttl>
      <xsl:apply-templates select="$nd" mode="object.title.markup"/>
    </t:divttl>
-->
    <t:xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to"/>
        </xsl:otherwise>
      </xsl:choose>
    </t:xreftext>
    <t:page>
    </t:page>
    <xsl:apply-templates mode="olink.mode"/>
  </t:div>
</xsl:template>

<xsl:template name="obj">
  <xsl:param name="nd" select="."/>

  <t:obj>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <t:ttl>
      <xsl:apply-templates select="$nd" mode="title.markup"/>
    </t:ttl>
<!--    <t:objttl>
      <xsl:apply-templates select="$nd" mode="object.title.markup"/>
    </t:objttl>
-->
    <t:xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to"/>
        </xsl:otherwise>
      </xsl:choose>
    </t:xreftext>
  </t:obj>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()"
              mode="olink.mode">
  <!-- nop -->
</xsl:template>

<!--
<xsl:template match="*" mode="olink.mode">
</xsl:template>
-->

<xsl:template match="set" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="book" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="part|reference" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="article" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="refentry" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="section|sect1|sect2|sect3|sect4|sect5" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="refsection|refsect1|refsect2|refsect3" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="figure|example|table" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="equation[title]" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="*" mode="olink.mode">
  <xsl:if test="@id">
    <xsl:call-template name="obj"/>
  </xsl:if> 
</xsl:template>

</xsl:stylesheet>
