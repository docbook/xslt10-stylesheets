<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:dtd="http://nwalsh.com/xmlns/dtd/"
		exclude-result-prefixes="rng doc"
                version="1.0">

<xsl:import href="../../tools/doc2dtd.xsl"/>

<xsl:template match="rng:define">
  <xsl:choose>
    <xsl:when test="@name = 'db.link'
		    and key('pattern', 'ws.headlink')">
      <!-- There are two, context-dependet link elements; merge them. -->
      <xsl:variable name="ws.headlink"
		    select="key('pattern', 'ws.headlink')"/>

      <dtd:element name="link">
	<xsl:apply-templates select="rng:element/doc:content-model"
			     mode="content-model"/>
      </dtd:element>

      <dtd:attlist name="link">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$ws.headlink/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'ws.headlink'
		    and key('pattern', 'db.link')">
      <!-- nop; handled by the db.link branch -->
    </xsl:when>

    <xsl:when test="@name = 'ws.script'">
      <!-- The script element has a src attribute or contains text; fix that -->
      <dtd:element name="script">
	<dtd:group>
	  <dtd:choice repeat="*">
	    <dtd:PCDATA/>
	  </dtd:choice>
	</dtd:group>
      </dtd:element>

      <dtd:attlist name="script">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'ws.style'">
      <!-- The style element has a src attribute or contains text; fix that -->
      <dtd:element name="style">
	<dtd:group>
	  <dtd:choice repeat="*">
	    <dtd:PCDATA/>
	  </dtd:choice>
	</dtd:group>
      </dtd:element>

      <dtd:attlist name="style">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
