<?xml version="1.0"?>
<!-- * -->
<!-- * This is a static copy of the xtangle.xsl file from the litprog module. -->
<!-- * It *MAY NOT BE UP TO DATE*. It is provided for the convenience of -->
<!-- * developers who don't want to generate the file themselves from -->
<!-- * the sources in the ../litprog directory. To create a fresh up-to-date -->
<!-- * copy of the file, check out that directory from the source repository -->
<!-- * and build it. -->
<!-- * -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" exclude-result-prefixes="src" version="1.0">

    
  <xsl:preserve-space elements="*"/>

  <xsl:key name="fragment" match="src:fragment" use="@*[local-name() = 'id']"/>

  <xsl:param name="top" select="'top'"/>


  <xsl:output method="xml"/>

  <xsl:template match="/">
  <xsl:apply-templates select="key('fragment', $top)"/>
</xsl:template>
  <xsl:template match="src:fragment">
    <xsl:variable name="first-node" select="node()[1]"/>
  <xsl:variable name="middle-nodes" select="node()[position() &gt; 1 and position() &lt; last()]"/>
  <xsl:variable name="last-node" select="node()[position() &gt; 1 and position() = last()]"/>
      <xsl:choose>
            <xsl:when test="$first-node = text() and count(node()) = 1">
                <xsl:variable name="leading-nl" select="substring($first-node, 1, 1) = '&#10;'"/>
        <xsl:variable name="trailing-nl" select="substring($first-node, string-length($first-node), 1) = '&#10;'"/>
        <xsl:choose>
                    <xsl:when test="$leading-nl and $trailing-nl">
            <xsl:value-of select="substring($first-node, 2, string-length($first-node)-2)"/>
          </xsl:when>
                    <xsl:when test="$leading-nl">
            <xsl:value-of select="substring($first-node, 2)"/>
          </xsl:when>
                    <xsl:when test="$trailing-nl">
            <xsl:value-of select="substring($first-node, 1, string-length($first-node)-1)"/>
          </xsl:when>
                    <xsl:otherwise>
            <xsl:value-of select="$first-node"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
            <xsl:when test="$first-node = text() and substring($first-node, 1, 1) = '&#10;'">
        <xsl:value-of select="substring($first-node, 2)"/>
      </xsl:when>
            <xsl:otherwise>
        <xsl:apply-templates select="$first-node" mode="copy"/>
      </xsl:otherwise>
    </xsl:choose>
      <xsl:apply-templates select="$middle-nodes" mode="copy"/>
      <xsl:choose>
      <xsl:when test="$last-node = text() and substring($last-node, string-length($last-node), 1) = '&#10;'">
        <xsl:value-of select="substring($last-node, 1, string-length($last-node)-1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$last-node" mode="copy"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>
  <xsl:template match="src:passthrough" mode="copy">
  <xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>
<xsl:template match="src:fragref" mode="copy">
  <xsl:variable name="node" select="."/>
  <xsl:choose>
        <xsl:when test="@disable-output-escaping='yes'">
      <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
          <xsl:for-each select="namespace::*">
    <xsl:if test="string(.) != namespace-uri($node)">
      <xsl:copy/>
    </xsl:if>
  </xsl:for-each>
        <xsl:for-each select="@*">
          <xsl:if test="not(name(.) = 'disable-output-escaping')">
            <xsl:copy/>
          </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates mode="copy"/>
      </xsl:element>
    </xsl:when>
        <xsl:otherwise>
      <xsl:variable name="fragment" select="key('fragment', @linkend)"/>
            <xsl:if test="count($fragment) != 1">
        <xsl:message terminate="yes">
          <xsl:text>Link to fragment "</xsl:text>
          <xsl:value-of select="@linkend"/>
          <xsl:text>" does not uniquely identify a single fragment.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:if test="local-name($fragment) != 'fragment'">
  <xsl:message terminate="yes">
    <xsl:text>Link "</xsl:text>
    <xsl:value-of select="@linkend"/>
    <xsl:text>" does not point to a src:fragment.</xsl:text>
  </xsl:message>
</xsl:if>
      <xsl:apply-templates select="$fragment"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="*" mode="copy">
  <xsl:variable name="node" select="."/>
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
      <xsl:for-each select="namespace::*">
    <xsl:if test="string(.) != namespace-uri($node)">
      <xsl:copy/>
    </xsl:if>
  </xsl:for-each>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>
  <xsl:template match="processing-instruction()" mode="copy">
  <xsl:processing-instruction name="{name(.)}">
    <xsl:value-of select="."/>
  </xsl:processing-instruction>
</xsl:template>

<xsl:template match="comment()" mode="copy">
  <xsl:comment>
    <xsl:value-of select="."/>
  </xsl:comment>
</xsl:template>
</xsl:stylesheet>
