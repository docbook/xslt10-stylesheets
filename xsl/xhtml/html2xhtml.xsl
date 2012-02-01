<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xslo="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:exsl="http://exslt.org/common"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="exsl saxon"
                version="1.0">

<xsl:include href="../lib/lib.xsl"/>
<xsl:output method="xml"
  encoding="ASCII"
  saxon:character-representation="decimal"
  />

<xsl:namespace-alias stylesheet-prefix="xslo" result-prefix="xsl"/>

<xsl:preserve-space elements="*"/>

<xsl:template match="/">
  <xsl:comment>This file was created automatically by html2xhtml</xsl:comment>
  <xsl:comment>from the HTML stylesheets.</xsl:comment>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="xsl:stylesheet" >
  <xsl:variable name="a">
      <xsl:element name="dummy" namespace="http://www.w3.org/1999/xhtml"/>
  </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="exsl:node-set($a)//namespace::*"/>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
   </xsl:copy>
</xsl:template>

<!-- Make sure we override some templates and parameters appropriately for XHTML -->
<xsl:template match="xsl:output">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="method">xml</xsl:attribute>
    <xsl:attribute name="encoding">UTF-8</xsl:attribute>
    <xsl:attribute name="doctype-public">-//W3C//DTD XHTML 1.0 Transitional//EN</xsl:attribute>
    <xsl:attribute name="doctype-system">http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:import">
  <xsl:copy>
    <xsl:attribute name="href">
      <xsl:call-template name="string.subst">
        <xsl:with-param name="string" select="@href"/>
        <xsl:with-param name="target">/html/</xsl:with-param>
        <xsl:with-param name="replacement">/xhtml/</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='stylesheet.result.type']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xhtml'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='make.valid.html']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">1</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='output.method']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.method']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.encoding']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'UTF-8'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-public']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'-//W3C//DTD XHTML 1.0 Transitional//EN'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-system']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:attribute[@name='name']">
  <xsl:choose>
    <xsl:when test="ancestor::a">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name">id</xsl:attribute>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="xsl:element">
  <!-- make sure literal xsl:element declarations propagate the right namespace -->
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="namespace">http://www.w3.org/1999/xhtml</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Bare anchors (<a/>) are not allowed in <blockquote>s -->
<xsl:template match="xsl:template[@name='anchor']/xsl:if">
  <xslo:if>
    <xsl:attribute name="test">
      <xsl:text>not($node[parent::blockquote])</xsl:text>
    </xsl:attribute>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xslo:if>
</xsl:template>

<xsl:template match="xsl:template[@name='body.attributes']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xslo:if test="starts-with($writing.mode, 'rl')">
      <xslo:attribute name="dir">rtl</xslo:attribute>
    </xslo:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> no apply-templates; make it empty except for dir for rtl</xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:copy>
</xsl:template>

<!-- this only occurs in docbook.xsl to identify errors -->
<xsl:template match="font">
  <span class="ERROR" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- "The following HTML elements specify font information. 
      Although they are not all deprecated, their use is discouraged in 
      favor of style sheets." -->
<xsl:template match="b">
  <strong xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*|node()"/>
  </strong>
</xsl:template>  
<xsl:template match="i">
  <em xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*|node()"/>
  </em>
</xsl:template>  

<!-- this only occurs in docbook.xsl to identify errors -->
<xsl:template match="a[@name]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'name'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="@*">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template name="strippath">
  <xsl:param name="filename" select="''"/>
  <xsl:choose>
    <!-- Leading .. are not eliminated -->
    <xsl:when test="starts-with($filename, '../')">
      <xsl:value-of select="'../'"/>
      <xsl:call-template name="strippath">
        <xsl:with-param name="filename" select="substring-after($filename, '../')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($filename, '/../')">
      <xsl:call-template name="strippath">
        <xsl:with-param name="filename">
          <xsl:call-template name="getdir">
            <xsl:with-param name="filename" select="substring-before($filename, '/../')"/>
          </xsl:call-template>
          <xsl:value-of select="substring-after($filename, '/../')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="getdir">
  <xsl:param name="filename" select="''"/>
  <xsl:if test="contains($filename, '/')">
    <xsl:value-of select="substring-before($filename, '/')"/>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="getdir">
      <xsl:with-param name="filename" select="substring-after($filename, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
