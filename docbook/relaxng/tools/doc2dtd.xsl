<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		version="1.0">

<!-- attempts, and currently fails, to produce a DTD -->

<xsl:output method="text"/>
<xsl:strip-space elements="*"/>

<xsl:variable name="start" select="/rng:grammar/rng:start"/>

<xsl:template match="/">
  <xsl:variable name="trimmed">
    <xsl:apply-templates mode="trim"/>
  </xsl:variable>

  <xsl:variable name="cleaned">
    <xsl:apply-templates select="exsl:node-set($trimmed)/*" mode="cleanup"/>
  </xsl:variable>

  <xsl:apply-templates select="exsl:node-set($cleaned)/*"/>
</xsl:template>

<xsl:key name="defs" match="rng:define" use="@name"/>

<xsl:template match="rng:div">
  <xsl:apply-templates select="rng:define"/>
</xsl:template>

<xsl:template match="ctrl:alternate-define"/>

<xsl:template match="rng:define[@name='db.info.titlereq']"/>
<xsl:template match="rng:define[@name='db.info.titleonly']"/>
<xsl:template match="rng:define[@name='db.info.titleonlyreq']"/>
<xsl:template match="rng:define[@name='db.info.titleforbidden']"/>

<xsl:template match="rng:define">
  <xsl:apply-templates select="rng:element"/>
</xsl:template>

<xsl:template match="rng:element">
  <xsl:if test="@name">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="defname" select="ancestor::rng:define/@name"/>

    <!--
    <xsl:message>
      <xsl:value-of select="@name"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="../@name"/>
      <xsl:text>)</xsl:text>
    </xsl:message>
    -->
    <xsl:text>&lt;!ELEMENT </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="doc:content-model" mode="model"/>
    <xsl:text>&gt;&#10;&#10;</xsl:text>

    <xsl:text>&lt;!ATTLIST </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="$start//rng:ref[@name = $defname]">
      <xsl:text>&#9;xmlns&#9;CDATA #FIXED "http://docbook.org/docbook-ng"&#10;</xsl:text>
      <xsl:text>&#9;version&#9;CDATA&#9;#IMPLIED&#10;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="doc:attributes" mode="attlist"/>
    <xsl:text>&gt;&#10;&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->
<!-- doc:content-model -->

<xsl:template match="doc:content-model" mode="model">
  <xsl:choose>
    <xsl:when test="rng:choice|rng:oneOrMore|rng:zeroOrMore|rng:interleave|rng:group">
      <xsl:apply-templates mode="model"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates mode="model"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:group" mode="model">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="model"/>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="rng:choice" mode="model">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="model"/>
    <xsl:if test="position() != last()"> | </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="rng:interleave" mode="model">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="model"/>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="rng:zeroOrMore" mode="model">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="model"/>
    <xsl:if test="position() != last()"> | </xsl:if>
  </xsl:for-each>
  <xsl:text>)*</xsl:text>
</xsl:template>

<xsl:template match="rng:oneOrMore" mode="model">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="model"/>
    <xsl:if test="position() != last()"> | </xsl:if>
  </xsl:for-each>
  <xsl:text>)+</xsl:text>
</xsl:template>

<xsl:template match="rng:optional" mode="model">
  <xsl:apply-templates mode="model"/>
  <xsl:text>?</xsl:text>
</xsl:template>

<xsl:template match="rng:ref" mode="model">
  <xsl:variable name="def" select="key('defs', @name)"/>
  <xsl:value-of select="$def/rng:element/@name"/>
</xsl:template>

<xsl:template match="rng:text" mode="model">
  <xsl:text>#PCDATA</xsl:text>
</xsl:template>

<xsl:template match="rng:empty" mode="model">
  <xsl:text>EMPTY</xsl:text>
</xsl:template>

<xsl:template match="rng:data" mode="model">
  <xsl:message>Using #PCDATA instead of <xsl:value-of select="@type"/></xsl:message>
  <xsl:text>#PCDATA</xsl:text>
</xsl:template>

<!-- ====================================================================== -->
<!-- doc:attributes -->

<xsl:template match="doc:attributes" mode="attlist">
  <xsl:apply-templates mode="attlist"/>
</xsl:template>

<xsl:template match="rng:attribute" mode="attlist">
  <xsl:text>&#9;</xsl:text>
  <xsl:value-of select="@name"/>

  <xsl:text>&#9;</xsl:text>
  <xsl:if test="string-length(@name) &lt; 8">
    <xsl:text>&#9;</xsl:text>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="rng:data">
      <xsl:choose>
	<xsl:when test="rng:data/@type = 'integer'">CDATA</xsl:when>
	<xsl:otherwise><xsl:value-of select="rng:data/@type"/></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="rng:choice">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="rng:choice/rng:value">
	<xsl:value-of select="."/>
	<xsl:if test="position() != last()">|</xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>CDATA</xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#9;</xsl:text>
  <xsl:choose>
    <xsl:when test="ancestor::rng:optional">
      <xsl:text>#IMPLIED</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>#REQUIRED</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="rng:interleave|rng:optional" mode="attlist">
  <xsl:apply-templates mode="attlist"/>
</xsl:template>

<!-- ====================================================================== -->
<!-- trim -->

<xsl:template match="rng:ref[@name='indexterm.startofrange']" mode="trim"/>
<xsl:template match="rng:ref[@name='indexterm.endofrange']" mode="trim"/>
<xsl:template match="rng:ref[@name='html.informaltable']" mode="trim"/>
<xsl:template match="rng:ref[@name='html.table']" mode="trim"/>
<xsl:template match="rng:ref[@name='any.svg']" mode="trim"/>
<xsl:template match="rng:ref[@name='any.mml']" mode="trim"/>
<xsl:template match="rng:data[preceding-sibling::rng:data]" mode="trim"/>

<xsl:template match="rng:define[@name='indexterm.startofrange']" mode="trim"/>
<xsl:template match="rng:define[@name='indexterm.endofrange']" mode="trim"/>
<xsl:template match="rng:define[@name='html.informaltable']" mode="trim"/>
<xsl:template match="rng:define[@name='html.table']" mode="trim"/>
<xsl:template match="rng:define[@name='html.thead']" mode="trim"/>
<xsl:template match="rng:define[@name='html.tbody']" mode="trim"/>
<xsl:template match="rng:define[@name='html.tfoot']" mode="trim"/>
<xsl:template match="rng:define[@name='any.svg']" mode="trim"/>
<xsl:template match="rng:define[@name='any.mml']" mode="trim"/>
<xsl:template match="rng:define[@name='text.phrase']" mode="trim"/>

<xsl:template match="*" mode="trim">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="trim"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="trim">
  <xsl:copy/>
</xsl:template>

<!-- ====================================================================== -->
<!-- cleanup -->

<xsl:template match="doc:content-model[count(*) = 1 and rng:text]" mode="cleanup">
  <doc:content-model>
    <rng:zeroOrMore>
      <rng:text/>
    </rng:zeroOrMore>
  </doc:content-model>
</xsl:template>

<xsl:template match="doc:content-model[.//rng:text]" mode="cleanup">
  <xsl:variable name="children">
    <xsl:copy-of select=".//rng:ref"/>
  </xsl:variable>

  <doc:content-model>
    <rng:zeroOrMore>
      <rng:text/>
      <xsl:for-each select="exsl:node-set($children)/*">
	<xsl:variable name="name" select="@name"/>
	<xsl:if test="not(preceding-sibling::rng:ref[@name = $name])">
	  <xsl:copy-of select="."/>
	</xsl:if>
      </xsl:for-each>
    </rng:zeroOrMore>
  </doc:content-model>
</xsl:template>

<xsl:template match="*" mode="cleanup">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="cleanup"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="cleanup">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
