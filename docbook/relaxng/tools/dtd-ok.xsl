<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <!-- The plan is that this stylesheet cleans up a DocBook RNG file, refactoring
       the constructs that Trang can't handle into appropriate deterministic
       (and less constrained) alternatives. -->

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="define" match="rng:define" use="@name"/>
  <xsl:key name="other-attr"  match="ctrl:other-attribute" use="@name"/>
  <xsl:key name="other-attr-enum"  match="ctrl:other-attribute" use="@enum-name"/>
  <xsl:key name="other-attr-other" match="ctrl:other-attribute" use="@other-name"/>

  <xsl:template match="/">
    <xsl:variable name="flat">
      <xsl:apply-templates select="/" mode="flatten"/>
    </xsl:variable>
<!--
    <xsl:variable name="pass0b">
      <xsl:apply-templates select="exsl:node-set($flat)" mode="pass0b"/>
    </xsl:variable>

    <xsl:variable name="pass0c">
      <xsl:apply-templates select="exsl:node-set($pass0b)" mode="pass0c"/>
    </xsl:variable>

    <xsl:variable name="pass1">
      <xsl:apply-templates select="exsl:node-set($pass0c)" mode="pass1"/>
    </xsl:variable>

    <xsl:variable name="pass2">
      <xsl:apply-templates select="exsl:node-set($pass1)" mode="pass2"/>
    </xsl:variable>

    <xsl:variable name="pass3">
      <xsl:apply-templates select="exsl:node-set($pass2)" mode="pass3"/>
    </xsl:variable>

    <xsl:copy-of select="$pass3"/>
-->
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- pass0b -->

  <xsl:template match="/" mode="pass0b">
    <xsl:message>Pass 0b...</xsl:message>
    <xsl:apply-templates mode="pass0b"/>
  </xsl:template>

  <xsl:template match="*" mode="pass0b">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass0b"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="pass0b">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="rng:define[@name='ubiq.inlines']" mode="pass0b">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="rng:ref[@name='ubiq.inlines']" mode="pass0b">
    <xsl:copy-of select="key('define',@name)/*"/>
  </xsl:template>

  <xsl:template match="rng:define[@name='systemitem.inlines']" mode="pass0b">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="rng:ref[@name='systemitem.inlines']" mode="pass0b">
    <xsl:copy-of select="key('define',@name)/*"/>
  </xsl:template>

  <xsl:template match="rng:define[@name='prompt.inlines']" mode="pass0b">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="rng:ref[@name='prompt.inlines']" mode="pass0b">
    <xsl:copy-of select="key('define',@name)/*"/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- pass0c -->

  <xsl:template match="/" mode="pass0c">
    <xsl:message>Pass 0c...</xsl:message>
    <xsl:apply-templates mode="pass0c"/>
  </xsl:template>

  <xsl:template match="*" mode="pass0c">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass0c"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="pass0c">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="rng:define[@name='docbook.text']" mode="pass0c">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="rng:ref[@name='docbook.text']" mode="pass0c">
    <xsl:copy-of select="key('define',@name)/*"/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- pass1 -->

  <xsl:template match="/" mode="pass1">
    <xsl:message>Pass 1...</xsl:message>
    <xsl:apply-templates mode="pass1"/>
  </xsl:template>

  <xsl:template match="*" mode="pass1">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass1"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="pass1">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="rng:interleave/rng:ref" mode="pass1">
    <!-- make everything in interleave optional -->
    <xsl:message>
      <xsl:text>Make </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> optional in interleave (for </xsl:text>
      <xsl:value-of select="ancestor::rng:define/@name"/>
      <xsl:text>)</xsl:text>
    </xsl:message>
    <rng:optional>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="pass1"/>
      </xsl:copy>
    </rng:optional>
  </xsl:template>

  <xsl:template match="rng:define[key('other-attr', @name)
		                  or key('other-attr-enum', @name)
		                  or key('other-attr-other', @name)]" mode="pass1">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="ctrl:other-attribute" mode="pass1">
    <xsl:message>
      <xsl:text>Make </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> attributes</xsl:text>
    </xsl:message>

    <xsl:variable name="enum" select="key('define',@enum-name)"/>
    <xsl:variable name="other" select="key('define',@other-name)"/>

    <rng:define name="{@name}">
      <rng:optional>
	<rng:attribute name="{$enum/rng:optional/rng:attribute/@name}">
	  <rng:choice>
	    <xsl:copy-of select="$enum/rng:optional/rng:attribute/rng:choice/*"/>
	    <rng:value>
	      <xsl:value-of select="$other/rng:attribute[@name=$enum/rng:optional/rng:attribute/@name]/rng:value"/>
	    </rng:value>
	  </rng:choice>
	</rng:attribute>
      </rng:optional>

      <rng:optional>
	<xsl:copy-of select="$other/rng:attribute[@name!=$enum/rng:optional/rng:attribute/@name]"/>
      </rng:optional>
    </rng:define>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- pass2 -->

  <xsl:template match="/" mode="pass2">
    <xsl:message>Pass 2...</xsl:message>
    <xsl:apply-templates mode="pass2"/>
  </xsl:template>

  <xsl:template match="*" mode="pass2">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass2"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="pass2">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="rng:interleave" mode="pass2">
    <!-- make interleave a repeatable choice -->
    <xsl:message>
      <xsl:text>Make interleave a repeatable choice </xsl:text>
      <xsl:text>(for </xsl:text>
      <xsl:value-of select="ancestor::rng:define/@name"/>
      <xsl:text>)</xsl:text>
    </xsl:message>
    <rng:zeroOrMore>
      <rng:choice>
	<xsl:apply-templates mode="pass2"/>
      </rng:choice>
    </rng:zeroOrMore>
  </xsl:template>

  <xsl:template match="rng:element[.//rng:text]" mode="pass2">
    <!-- flatten choices that contain text -->
    <xsl:message>
      <xsl:text>Flatten #PCDATA </xsl:text>
      <xsl:text>(for </xsl:text>
      <xsl:value-of select="ancestor::rng:define/@name"/>
      <xsl:text>)</xsl:text>
    </xsl:message>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <rng:zerOrMore>
	<rng:choice>
	  <rng:text/>
	  <xsl:apply-templates select=".//rng:ref" mode="pass2"/>
	</rng:choice>
      </rng:zerOrMore>
    </xsl:copy>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- pass3 -->

  <xsl:template match="/" mode="pass3">
    <xsl:message>Pass 3...</xsl:message>
    <xsl:apply-templates mode="pass3"/>
  </xsl:template>

  <xsl:template match="*" mode="pass3">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass3"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="pass3">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- flatten -->

  <xsl:template match="/" mode="flatten">
    <xsl:message>Pass flatten...</xsl:message>
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

  <xsl:template match="rng:define" mode="flatten">
    <xsl:choose>
      <xsl:when test="substring(@name, string-length(@name)-7) = '.attlist'
		      or substring(@name, string-length(@name)-6) = '.attrib'
		      or substring(@name, string-length(@name)-10) = '.attributes'">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="@name = 'db.info.titlereq' or @name = 'db.info.titleforbidden'">
	<!-- nop -->
      </xsl:when>
      <xsl:when test="starts-with(@name, 'db.')">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:ref" mode="flatten">
    <xsl:choose>
      <xsl:when test="substring(@name, string-length(@name)-7) = '.attlist'
		      or substring(@name, string-length(@name)-6) = '.attrib'
		      or substring(@name, string-length(@name)-10) = '.attributes'">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="@name = 'db.info.titlereq' or @name = 'db.info.titleforbidden'">
	<rng:ref name="db.info"/>
      </xsl:when>
      <xsl:when test="starts-with(@name, 'db.')">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="flatten"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Expand <xsl:value-of select="@name"/></xsl:message>
	<xsl:apply-templates select="key('define', @name)/*" mode="flatten"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:element/rng:ref[substring(@name, string-length(@name)-7)
		                           = '.attlist']" priority="3" mode="flatten">
    <!-- discard -->
  </xsl:template>

  <xsl:template match="rng:ref[@name='text.phrase']" priority="2" mode="flatten">
    <rng:ref name="db.phrase"/>
  </xsl:template>

  <xsl:template match="rng:ref[@name='text.replaceable']" priority="2" mode="flatten">
    <rng:ref name="db.replaceable"/>
  </xsl:template>

</xsl:stylesheet>
