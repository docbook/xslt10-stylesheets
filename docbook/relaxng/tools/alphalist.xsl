<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		version="2.0">

  <xsl:key name="defs" match="rng:define" use="@name"/>
  <xsl:key name="elems" match="rng:element" use="@name"/>

  <xsl:output method="text"/>

  <xsl:strip-space elements="*"/>

  <xsl:template match="rng:grammar">
    <xsl:for-each select=".//rng:define[rng:element]">
      <xsl:sort data-type="text" select="rng:element/@name"/>
      <xsl:variable name="name">
	<xsl:value-of select="rng:element/@name"/>
	<xsl:if test="count(key('elems', rng:element/@name)) &gt; 1">
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="@name"/>
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </xsl:variable>

      <xsl:variable name="elems">
	<xsl:for-each select="rng:element/doc:content-model//rng:ref">
	  <doc:elem>
	    <xsl:attribute name="name">
	      <xsl:value-of select="key('defs',@name)/rng:element/@name"/>
	    </xsl:attribute>
	  </doc:elem>
	</xsl:for-each>
      </xsl:variable>

      <xsl:if test="rng:element/doc:content-model//rng:text">
	<xsl:value-of select="$name"/>
	<xsl:text>: #PCDATA&#10;</xsl:text>
      </xsl:if>

      <xsl:for-each-group select="$elems/doc:elem" group-by="@name">
	<xsl:sort data-type="text" select="current-grouping-key()"/>
	<xsl:value-of select="$name"/>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="current-grouping-key()"/>
	<xsl:text>&#10;</xsl:text>
      </xsl:for-each-group>

      <xsl:if test="rng:element/doc:content-model/rng:empty">
	<xsl:value-of select="$name"/>
	<xsl:text>: EMPTY&#10;</xsl:text>
      </xsl:if>

      <xsl:text>&#10;</xsl:text>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
