<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:set="http://exslt.org/sets"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl s set"
                extension-element-prefixes="exsl"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <xsl:message>Add groups</xsl:message>
    <xsl:variable name="grouped">
      <xsl:apply-templates mode="group"/>
    </xsl:variable>

    <xsl:message>Expand content models</xsl:message>
    <xsl:variable name="expanded">
      <xsl:call-template name="expand">
	<xsl:with-param name="root" select="exsl:node-set($grouped)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:message>Classify element content</xsl:message>
    <xsl:variable name="classified">
      <xsl:apply-templates select="exsl:node-set($expanded)" mode="classify"/>
    </xsl:variable>

    <xsl:message>Flatten nested choices</xsl:message>
    <xsl:variable name="flattened">
      <xsl:call-template name="flatten">
	<xsl:with-param name="root" select="exsl:node-set($classified)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of select="$flattened"/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:define[count(*) &gt; 1]
		       |rng:zeroOrMore[count(*) &gt; 1]
		       |rng:oneOrMore[count(*) &gt; 1]"
		mode="group">
    <xsl:variable name="refs">
      <xsl:text>0</xsl:text>
      <xsl:for-each select=".//rng:ref">
	<xsl:if test="key('defs',@name)/rng:element">1</xsl:if>
      </xsl:for-each>
      <xsl:if test="count(rng:attribute|rng:optional/rng:attribute) &gt; 0">1</xsl:if>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:choose>
	<xsl:when test="$refs &gt; 0">
	  <rng:group>
	    <xsl:apply-templates mode="group"/>
	  </rng:group>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates mode="group"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="group">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="group"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="group">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template name="expand">
    <xsl:param name="root"/>

    <xsl:variable name="canExpand">
      <xsl:apply-templates select="$root" mode="expandTest"/>
    </xsl:variable>

    <xsl:message>
      <xsl:value-of select="string-length($canExpand)"/>
      <xsl:text> patterns to expand</xsl:text>
    </xsl:message>

    <xsl:choose>
      <xsl:when test="contains($canExpand, '1')">
	<xsl:variable name="expanded">
	  <xsl:apply-templates select="$root" mode="expand"/>
	</xsl:variable>
	<xsl:call-template name="expand">
	  <xsl:with-param name="root" select="exsl:node-set($expanded)"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$root"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/" mode="expandTest">
    <xsl:for-each select="//rng:ref">
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="ref" select="key('defs', @name)"/>

      <xsl:choose>
	<xsl:when test="ancestor::rng:define[@name=$name]">
	  <!-- don't expand recursively -->
	</xsl:when>
	<xsl:when test="$ref and ($ref/rng:element or $ref/rng:choice/rng:element)">
	  <!-- don't expand element patterns -->
	</xsl:when>
	<xsl:when test="$ref and $ref/rng:empty">
	  <!-- don't expand empty patterns -->
	</xsl:when>
	<xsl:when test="$ref">1</xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/" mode="expand">
    <xsl:apply-templates mode="expand"/>
  </xsl:template>

  <xsl:template match="rng:ref" priority="2" mode="expand">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="ref" select="key('defs', @name)"/>

    <xsl:choose>
      <xsl:when test="$ref and ancestor::rng:define[@name=$name]">
	<!-- don't expand recursively -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and ($ref/rng:element or $ref/rng:choice/rng:element)">
	<!-- don't expand element patterns -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and $ref/rng:empty">
	<!-- just discard it -->
      </xsl:when>
      <xsl:when test="$ref and count($ref/*) &gt; 1">
	<!-- deal with the case where the pattern has an implicit group -->
	<rng:group>
	  <xsl:copy-of select="$ref/*"/>
	</rng:group>
      </xsl:when>
      <xsl:when test="$ref">
	<xsl:copy-of select="$ref/*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:element" mode="expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="expand">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:element|rng:start" mode="classify">
    <xsl:variable name="attr"
		  select="*[self::rng:ref[key('defs',@name)/rng:attribute]
		            |self::rng:attribute
		            |.//rng:ref[key('defs',@name)/rng:attribute]
		            |.//rng:attribute]"/>
    <xsl:variable name="rules" select="s:*"/>
    <xsl:variable name="cmod" select="set:difference(*,$attr|rng:notAllowed|$rules)"/>

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <doc:attributes>
	<xsl:copy-of select="$attr"/>
      </doc:attributes>

      <doc:content-model>
	<xsl:choose>
	  <xsl:when test="count($cmod) &gt; 1">
	    <rng:group>
	      <xsl:copy-of select="$cmod"/>
	    </rng:group>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="$cmod"/>
	  </xsl:otherwise>
	</xsl:choose>
      </doc:content-model>

      <xsl:if test="$rules">
	<doc:rules>
	  <xsl:copy-of select="$rules"/>
	</doc:rules>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="classify">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="classify"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()"
		mode="classify">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template name="flatten">
    <xsl:param name="root"/>
    <xsl:param name="count" select="1"/>

    <xsl:variable name="canFlatten">
      <xsl:apply-templates select="$root" mode="flattenTest"/>
    </xsl:variable>

    <xsl:message>
      <xsl:value-of select="$canFlatten"/>
      <xsl:text> patterns to flatten</xsl:text>
    </xsl:message>

    <xsl:choose>
      <xsl:when test="$canFlatten &gt; 0">
	<xsl:variable name="flattened">
	  <xsl:apply-templates select="$root" mode="flatten"/>
	</xsl:variable>

	<xsl:call-template name="flatten">
	  <xsl:with-param name="root" select="exsl:node-set($flattened)"/>
	  <xsl:with-param name="count" select="$count + 1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$root"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/" mode="flattenTest">
    <xsl:value-of select="count(//doc:content-model//rng:choice/rng:choice
			        |//doc:content-model//rng:zeroOrMore[not(*)]
			        |//doc:content-model//rng:oneOrMore[not(*)]
			        |//doc:content-model//rng:choice[not(*)]
		                |//doc:content-model//rng:choice[count(*)=1]
                                |//doc:content-model//rng:zeroOrMore/rng:choice
                                |//doc:content-model//rng:oneOrMore/rng:choice
                                |//doc:content-model//rng:zeroOrMore/rng:zeroOrMore
                                |//doc:content-model//rng:oneOrMore/rng:oneOrMore)"/>
  </xsl:template>

  <xsl:template match="/" mode="flatten">
    <xsl:apply-templates mode="flatten"/>
  </xsl:template>

  <xsl:template match="doc:content-model//rng:choice/rng:choice
		       |doc:content-model//rng:choice[count(*)=1]
		       |doc:content-model//rng:zeroOrMore/rng:choice
		       |doc:content-model//rng:oneOrMore/rng:choice
		       |doc:content-model//rng:zeroOrMore/rng:zeroOrMore
		       |doc:content-model//rng:oneOrMore/rng:oneOrMore"
	        mode="flatten">
    <xsl:apply-templates mode="flatten"/>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore[not(*)]
		       |rng:oneOrMore[not(*)]
		       |rng:choice[not(*)]"
		mode="flatten">
    <!-- discard them; they must have contained nothing but notAllowed -->
  </xsl:template>

  <xsl:template match="rng:group" mode="flatten">
    <xsl:choose>
      <xsl:when test="ancestor::doc:attributes
		      and count(*) = count(rng:optional[rng:attribute])">
	<xsl:apply-templates mode="flatten"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:notAllowed" mode="flatten">
    <xsl:choose>
      <xsl:when test="parent::rng:choice
		      |parent::rng:zeroOrMore
		      |parent::rng:oneOrMore">
	<!-- suppress -->
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:ref" mode="flatten">
    <xsl:variable name="name" select="@name"/>
    <xsl:choose>
      <xsl:when test="preceding-sibling::rng:ref[@name = $name]">
	<!-- suppress -->
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:choice[count(*)=1]" mode="flatten">
    <xsl:apply-templates mode="flatten"/>
  </xsl:template>

  <xsl:template match="*" mode="flatten">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="flatten"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="flatten">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
