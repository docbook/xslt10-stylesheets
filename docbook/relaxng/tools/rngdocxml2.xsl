<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:set="http://exslt.org/sets"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl s set"
                version="1.0">

<!-- This stylesheet does the same things as rngdocxml.xsl, except that it -->
<!-- does it in several discrete passes. This works around two problems: -->
<!-- 1. Running rngdocxml.xsl under saxon is tediously slow (maybe because -->
<!-- of object creation issues?) and 2. xsltproc has a bug in key() -->

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="pass" select="'group'"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:template match="/">
    <xsl:variable name="grouped">
      <xsl:message>Add groups</xsl:message>
      <xsl:apply-templates select="/" mode="group"/>
    </xsl:variable>

    <xsl:variable name="expanded">
      <xsl:message>Expand content models</xsl:message>
      <xsl:call-template name="expand">
	<xsl:with-param name="root" select="exsl:node-set($grouped)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="classified">
      <xsl:message>Classify element content</xsl:message>
      <xsl:call-template name="classify">
	<xsl:with-param name="root" select="exsl:node-set($expanded)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="flattened">
      <xsl:message>Flatten nested choices</xsl:message>
      <xsl:call-template name="flatten">
	<xsl:with-param name="root" select="exsl:node-set($classified)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy-of select="$flattened"/>
  </xsl:template>

  <xsl:template match="/FOOBAR">
    <xsl:choose>
      <xsl:when test="$pass = 'group'">
	<xsl:message>Add groups</xsl:message>
	<xsl:apply-templates select="/" mode="group"/>
      </xsl:when>

      <xsl:when test="$pass = 'expand'">
	<xsl:message>Expand content models</xsl:message>
	<xsl:apply-templates select="/" mode="expand"/>
      </xsl:when>

      <xsl:when test="$pass = 'classify'">
	<xsl:message>Classify element content</xsl:message>
	<xsl:apply-templates select="/" mode="classify"/>
      </xsl:when>

      <xsl:when test="$pass = 'flatten'">
	<xsl:message>Flatten nested choices</xsl:message>
	<xsl:apply-templates select="/" mode="flatten"/>
      </xsl:when>

      <xsl:otherwise>
	<xsl:message terminate="yes">Bad pass!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- group -->

  <xsl:template match="rng:grammar" mode="group">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="next-pass">expand</xsl:attribute>
      <xsl:apply-templates mode="group"/>
    </xsl:copy>
  </xsl:template>

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
  <!-- expand -->

  <xsl:template name="expand">
    <xsl:param name="root" select="/"/>

    <xsl:variable name="expanded">
      <xsl:apply-templates select="$root" mode="expand"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="exsl:node-set($expanded)/rng:grammar/@next-pass='expand'">
	<xsl:call-template name="expand">
	  <xsl:with-param name="root" select="exsl:node-set($expanded)"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$expanded"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/" mode="expand">
    <xsl:variable name="canExpand">
      <xsl:apply-templates select="/" mode="expandTest"/>
    </xsl:variable>

    <xsl:message>
      <xsl:value-of select="string-length($canExpand)"/>
      <xsl:text> patterns to expand</xsl:text>
    </xsl:message>

    <xsl:choose>
      <xsl:when test="string-length($canExpand) = 0">
	<xsl:apply-templates mode="no-expand"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="expand"/>
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
	<xsl:when test="$ref and $ref/rng:element">
	  <!-- don't expand element patterns -->
	</xsl:when>
	<xsl:when test="$ref and $ref/rng:empty">
	  <!-- don't expand empty patterns -->
	</xsl:when>
	<xsl:when test="$ref">1</xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="rng:grammar" mode="expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="next-pass">expand</xsl:attribute>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
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
      <xsl:when test="$ref and $ref/rng:element">
	<!-- don't expand element patterns -->
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="expand"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$ref and $ref/rng:empty">
	<!-- just discard it -->
      </xsl:when>
      <xsl:when test="$ref">
	<xsl:copy-of select="$ref/*"/>

	<!--
	<xsl:if test="@name = 'area.units-other.attributes'">
	  <xsl:message>
	    <xsl:text>Expanding </xsl:text>
	    <xsl:value-of select="@name"/>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="name($ref/*[1])"/>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="name($ref)"/>
	  </xsl:message>
	</xsl:if>
	-->
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

  <!-- ======================================== -->

  <xsl:template match="rng:grammar" mode="no-expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="next-pass">classify</xsl:attribute>
      <xsl:apply-templates mode="no-expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="no-expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="no-expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="no-expand">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template name="classify">
    <xsl:param name="root" select="/"/>
    <xsl:apply-templates select="$root" mode="classify"/>
  </xsl:template>

  <xsl:template match="rng:grammar" mode="classify">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="next-pass">flatten</xsl:attribute>
      <xsl:apply-templates mode="classify"/>
    </xsl:copy>
  </xsl:template>

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

  <xsl:template match="comment()|processing-instruction()|text()" mode="classify">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template name="flatten">
    <xsl:param name="root" select="/"/>

    <xsl:variable name="flattened">
      <xsl:apply-templates select="$root" mode="flatten"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="exsl:node-set($flattened)/rng:grammar/@next-pass='flatten'">
	<xsl:call-template name="flatten">
	  <xsl:with-param name="root" select="exsl:node-set($flattened)"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$flattened"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/" mode="flatten">
    <xsl:variable name="canFlatten">
      <xsl:apply-templates select="/" mode="flattenTest"/>
    </xsl:variable>

    <xsl:message>
      <xsl:value-of select="$canFlatten"/>
      <xsl:text> patterns to flatten</xsl:text>
    </xsl:message>

    <xsl:choose>
      <xsl:when test="$canFlatten = 0">
	<xsl:apply-templates mode="no-flatten"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="flatten"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/" mode="flattenTest">
    <xsl:value-of select="count(//doc:content-model//rng:choice/rng:choice
                                |//doc:content-model//rng:zeroOrMore/rng:choice
                                |//doc:content-model//rng:oneOrMore/rng:choice
                                |//doc:content-model//rng:zeroOrMore/rng:zeroOrMore
                                |//doc:content-model//rng:oneOrMore/rng:oneOrMore)"/>
  </xsl:template>

  <xsl:template match="rng:grammar" mode="flatten">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="next-pass">flatten</xsl:attribute>
      <xsl:apply-templates mode="flatten"/>
    </xsl:copy>
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

  <xsl:template match="doc:content-model//rng:choice/rng:choice
		       |doc:content-model//rng:zeroOrMore/rng:choice
		       |doc:content-model//rng:oneOrMore/rng:choice
		       |doc:content-model//rng:zeroOrMore/rng:zeroOrMore
		       |doc:content-model//rng:oneOrMore/rng:oneOrMore"
	        mode="flatten">
    <xsl:apply-templates mode="flatten"/>
  </xsl:template>

  <xsl:template match="rng:notAllowed" mode="flatten">
    <xsl:choose>
      <xsl:when test="parent::rng:choice|parent::rng:zeroOrMore|parent::rng:oneOrMore">
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

  <xsl:template match="*" mode="flatten">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="flatten"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="flatten">
    <xsl:copy/>
  </xsl:template>

  <!-- ======================================== -->

  <xsl:template match="rng:grammar" mode="no-flatten">
    <xsl:copy>
      <xsl:copy-of select="@*[name(.) != 'next-pass']"/>
      <xsl:apply-templates mode="no-flatten"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="no-flatten">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="no-flatten"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="no-flatten">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
