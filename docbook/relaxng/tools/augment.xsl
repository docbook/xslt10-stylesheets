<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:variable name="exclusionsNS">
    <exclusions>
      <xsl:apply-templates select="//ctrl:exclude"/>
    </exclusions>
  </xsl:variable>

  <xsl:variable name="exclusions" select="exsl:node-set($exclusionsNS)/*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:grammar" priority="2">
    <xsl:copy>
      <!-- Make sure the datatypeLibrary is specified -->
      <xsl:attribute name="datatypeLibrary">
	<xsl:value-of select="'http://www.w3.org/2001/XMLSchema-datatypes'"/>
      </xsl:attribute>
      <xsl:copy-of select="@*"/>

      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment> DocBook NG: The "Absinthe" Release </xsl:comment>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment> See http://docbook.org/docbook-ng/ </xsl:comment>
      <xsl:text>&#10;</xsl:text>

      <xsl:for-each select="*">
	<xsl:choose>
	  <xsl:when test="self::rng:define and rng:element[@name]">
	    <xsl:variable name="name" select="@name"/>
	    <xsl:variable name="basename">
	      <xsl:choose>
		<xsl:when test="starts-with(@name, 'db.')">
		  <xsl:value-of select="substring-after(@name, 'db.')"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@name"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>

	    <xsl:variable name="ctrl:common-attributes"
			  select="(//ctrl:common-attributes[@element=$basename]
			           |//ctrl:common-attributes[@define=$name])[1]"/>
	    <xsl:variable name="ctrl:common-linking"
			  select="(//ctrl:common-linking[@element=$basename]
			           |//ctrl:common-linking[@define=$name])[1]"/>
	    <xsl:variable name="ctrl:role"
			  select="(//ctrl:role[@element=$basename]
			           |//ctrl:role[@define=$name])[1]"/>

	    <xsl:if test="not($ctrl:role/@suppress)">
	      <rng:define name="{$basename}.role.attrib">
		<rng:optional>
		  <rng:ref name="role.attribute"/>
		</rng:optional>
	      </rng:define>
	    </xsl:if>

	    <rng:define name="local.{$basename}.attrib">
	      <rng:empty/>
	    </rng:define>

	    <rng:define name="{$basename}.attlist">
	      <xsl:choose>
		<xsl:when test="$ctrl:common-attributes/@suppress">
		  <!-- nop -->
		</xsl:when>
		<xsl:when test="$ctrl:common-attributes">
		  <rng:ref name="{$ctrl:common-attributes/@attributes}"/>
		</xsl:when>
		<xsl:otherwise>
		  <rng:ref name="common.attributes"/>
		</xsl:otherwise>
	      </xsl:choose>

	      <xsl:choose>
		<xsl:when test="$ctrl:common-linking/@suppress">
		  <!-- nop -->
		</xsl:when>
		<xsl:when test="$ctrl:common-linking">
		  <rng:ref name="{$ctrl:common-linking/@attributes}"/>
		</xsl:when>
		<xsl:when test="key('defs',concat($basename,'.linkend.attrib'))
			        or key('defs',concat($basename,'.linkends.attrib'))">
		  <!-- no common linking attributes -->
		</xsl:when>
		<xsl:otherwise>
		  <rng:ref name="common.linking.attributes"/>
		</xsl:otherwise>
	      </xsl:choose>

	      <xsl:if test="not($ctrl:role/@suppress)">
		<rng:ref name="{$basename}.role.attrib"/>
	      </xsl:if>

	      <xsl:for-each select="/rng:grammar/rng:define[not(@combine)]">
		<xsl:if test="string-length(@name) &gt; 7
                              and starts-with(@name,concat($basename,'.'))
			      and substring(@name, string-length(@name)-6)
                                  = '.attrib'">
		  <rng:ref name="{@name}"/>
		</xsl:if>
		<xsl:if test="string-length(@name) &gt; 8
                              and starts-with(@name,concat($basename,'.'))
			      and substring(@name, string-length(@name)-7)
                                  = '.attribs'">
		  <rng:ref name="{@name}"/>
		</xsl:if>
	      </xsl:for-each>

	      <rng:ref name="local.{$basename}.attrib"/>
	    </rng:define>

	    <xsl:apply-templates select="."/>
	  </xsl:when>

	  <xsl:when test="self::ctrl:*">
	    <!-- suppress -->
	  </xsl:when>

	  <xsl:otherwise>
	    <xsl:apply-templates select="."/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rng:element[@name]" priority="2">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="basename">
      <xsl:choose>
        <xsl:when test="starts-with(../@name, 'db.')">
          <xsl:value-of select="substring-after(../@name, 'db.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:for-each select="$exclusions/ctrl:exclusion[ctrl:from[*[name(.)=$name]]]">
	<xsl:for-each select="ctrl:exclude/*">
	  <!--
	  <xsl:message>
	    <xsl:value-of select="name(.)"/>
	    <xsl:text> is excluded from </xsl:text>
	    <xsl:value-of select="$name"/>
	  </xsl:message>
	  -->

	  <s:rule context="{$name}">
	    <s:assert test="not(.//{name(.)})">
	      <xsl:value-of select="name(.)"/>
	      <xsl:text> must not occur in the descendants of </xsl:text>
	      <xsl:value-of select="$name"/>
	    </s:assert>
	  </s:rule>
	</xsl:for-each>
      </xsl:for-each>

      <rng:ref name="{$basename}.attlist"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rng:include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:attribute name="href">
        <xsl:value-of select="substring-before(@href, '.rnx')"/>
        <xsl:text>.rng</xsl:text>
      </xsl:attribute>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ctrl:exclude">
    <ctrl:exclusion>
      <ctrl:from>
	<xsl:apply-templates select="key('defs', @from)" mode="names"/>
      </ctrl:from>
      <ctrl:exclude>
	<xsl:apply-templates select="key('defs', @exclude)" mode="names"/>
      </ctrl:exclude>
    </ctrl:exclusion>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Names -->

  <xsl:template match="rng:ref" mode="names">
    <xsl:apply-templates select="key('defs',@name)" mode="names"/>
  </xsl:template>

  <xsl:template match="rng:element" mode="names">
    <xsl:element name="{@name}"/>
  </xsl:template>

  <xsl:template match="*" mode="names">
    <xsl:apply-templates mode="names"/>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
