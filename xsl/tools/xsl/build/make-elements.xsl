<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:xslt="dummy"
                version="1.0">
  <xsl:output indent="yes"/>
  <xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>
  <!-- ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or https://cdn.docbook.org/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- ==================================================================== -->

  <!-- * This stylesheet expects as input a RELAX NG grammar that -->
  <!-- * defines a set of (DocBook) elements, From that grammar, it gets -->
  <!-- * the value of the "name" attribute for each element defined in -->
  <!-- * that grammar, then generates a list of those names. -->

  <xsl:template match="/">
    <xslt:stylesheet version="1.0">
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * This stylesheet is automatically generated. </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * Edit the make-elements.xsl file to re-generate this. </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xslt:variable name="docbook-element-list">
        <simplelist role="element"> 
          <xsl:for-each
              select="//*[local-name() = 'element'][@name]">
            <xsl:sort select="@name"/>
            <xsl:if test="not(@name = preceding::*[local-name() = 'element']/@name)">
              <member><xsl:value-of select="@name"/></member>
            </xsl:if>
          </xsl:for-each>
        </simplelist>
      </xslt:variable>
      <xslt:variable name="docbook-elements"
                    select="exsl:node-set($docbook-element-list)/simplelist"/>
      <xslt:template name="is-docbook-element">
        <xslt:param name="element" select="''"/>
        <xslt:choose>
          <xslt:when test="$docbook-elements/member[. = $element]">1</xslt:when>
          <xslt:otherwise>0</xslt:otherwise>
        </xslt:choose>
      </xslt:template>
    </xslt:stylesheet>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
