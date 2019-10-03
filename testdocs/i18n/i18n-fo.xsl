<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<xsl:import href="https://cdn.docbook.org/release/xsl/current/fo/docbook.xsl"/>
<xsl:include href="titlepage-fo.xsl"/>

<!-- ====================================================================== -->

<xsl:param name="title.margin.left" select="'0pt'"/>
<xsl:param name="ulink.show" select="0"/>

<!-- ====================================================================== -->

<xsl:template match="othercredit" mode="titlepage.mode">
  <xsl:variable name="contrib" select="string(contrib)"/>
  <xsl:choose>
    <xsl:when test="contrib">
      <xsl:if test="not(preceding-sibling::othercredit[string(contrib)=$contrib])">
        <fo:block>
          <xsl:apply-templates mode="titlepage.mode" select="contrib"/>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="person.name"/>
          <xsl:if test="affiliation/address/email">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="affiliation/address/email"
                                 mode="titlepage.mode"/>
          </xsl:if>
          <xsl:apply-templates select="following-sibling::othercredit[string(contrib)=$contrib]" mode="titlepage.othercredits"/>
        </fo:block>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <fo:block><xsl:call-template name="person.name"/></fo:block>
      <xsl:apply-templates mode="titlepage.mode" select="./affiliation"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="othercredit" mode="titlepage.othercredits">
  <xsl:text>; </xsl:text>
  <xsl:call-template name="person.name"/>
  <xsl:if test="affiliation/address/email">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="affiliation/address/email"
                         mode="titlepage.mode"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

</xsl:stylesheet>
