<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:set="http://exslt.org/sets"
		xmlns:s="http://www.ascc.net/xml/schematron"
                exclude-result-prefixes="exsl ctrl s rng set"
                version="1.0">

  <xsl:include href="/sourceforge/docbook/xsl/html/chunker.xsl"/>

  <xsl:param name="home" select="'home.html'"/>
  <xsl:param name="title" select="'anonymous'"/>
  <xsl:param name="base.dir" select="'html/'"/>
  <xsl:param name="stylesheet" select="'html.css'"/>
  <xsl:param name="ng-release" select="'Bourbon'"/>

  <xsl:output method="html"/>

  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>
  <xsl:key name="elemdefs" match="rng:define[rng:element]" use="rng:element/@name"/>
  <xsl:key name="elements" match="rng:element" use="@name"/>
  <xsl:key name="genid" match="rng:element" use="generate-id()"/>

  <xsl:template match="/">
    <xsl:variable name="allElemNS">
      <xsl:apply-templates select="//rng:element[@name and generate-id(.)
		                     =generate-id(key('elements',@name)[1])]"
                           mode="names">
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="//rng:element[not(@name)]"
                           mode="names">
	<xsl:sort select="ancestor::rng:define[1]/@name"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="allElem" select="exsl:node-set($allElemNS)/*"/>

    <xsl:apply-templates select="//rng:start" mode="chunk">
      <xsl:with-param name="home" select="$home"/>
      <xsl:with-param name="next" select="$allElem[1]/@filename"/>
    </xsl:apply-templates>

    <xsl:for-each select="$allElem"><!--[@name = 'areaspec']">-->
      <xsl:variable name="prev" select="preceding-sibling::*[1]/@filename"/>
      <xsl:variable name="next" select="following-sibling::*[1]/@filename"/>

      <xsl:apply-templates select="key('genid', @id)" mode="chunk">
	<xsl:with-param name="home" select="$home"/>
	<xsl:with-param name="prev" select="$prev"/>
	<xsl:with-param name="next" select="$next"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="rng:element" mode="names">
    <element id="{generate-id()}" define="{ancestor::rng:define[1]/@name}">
      <xsl:attribute name="filename">
	<xsl:apply-templates select="." mode="filename"/>
      </xsl:attribute>
      <xsl:if test="@name">
	<xsl:attribute name="name">
	  <xsl:value-of select="@name"/>
	</xsl:attribute>
      </xsl:if>
    </element>
  </xsl:template>

  <xsl:template match="rng:start" mode="chunk">
    <xsl:param name="home"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="concat($base.dir,$home)"/>
      <xsl:with-param name="content">
	<html>
	  <head>
	    <title>RNGdoc: <xsl:value-of select="$title"/></title>
	    <xsl:if test="$stylesheet != ''">
	      <link rel="stylesheet" type="text/css" href="{$stylesheet}"/>
	    </xsl:if>
	  </head>
	  <body>
	    <xsl:call-template name="nav-header">
	      <xsl:with-param name="home" select="$home"/>
	      <xsl:with-param name="prev" select="$prev"/>
	      <xsl:with-param name="next" select="$next"/>
	    </xsl:call-template>

	    <h1>Start</h1>

	    <div class="start">
	      <tt>start</tt>
	      <xsl:text> ::=</xsl:text>

	      <ul>
		<xsl:apply-templates select="doc:content-model"/>
	      </ul>
	    </div>
	  </body>
	</html>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="rng:element" mode="filename">
    <xsl:choose>
      <xsl:when test="@name">
	<xsl:value-of select="@name"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="ancestor::rng:define[1]/@name"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="'.html'"/>
  </xsl:template>

  <xsl:template match="rng:element" mode="chunk">
    <xsl:param name="home"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>

    <xsl:variable name="basename">
      <xsl:choose>
	<xsl:when test="@name">
	  <xsl:value-of select="@name"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="ancestor::rng:define[1]/@name"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename"
		      select="concat($base.dir,$basename,'.html')"/>
      <xsl:with-param name="content">
	<html>
	  <head>
	    <title>
	      <xsl:text>RNGdoc: </xsl:text>
	      <xsl:value-of select="@name"/>
	      <xsl:text>: </xsl:text>
	      <xsl:value-of select="$title"/>
	    </title>
	    <xsl:if test="$stylesheet != ''">
	      <link rel="stylesheet" type="text/css" href="{$stylesheet}"/>
	    </xsl:if>
	  </head>
	  <body>
	    <xsl:call-template name="nav-header">
	      <xsl:with-param name="home" select="$home"/>
	      <xsl:with-param name="prev" select="$prev"/>
	      <xsl:with-param name="next" select="$next"/>
	    </xsl:call-template>

	    <h1>
	      <xsl:value-of select="@name"/>
	    </h1>

	    <xsl:choose>
	      <xsl:when test="key('elemdefs', @name)">
		<xsl:for-each select="key('elemdefs', @name)">
		  <xsl:apply-templates select=".">
		    <xsl:with-param name="elemNum" select="position()"/>
		  </xsl:apply-templates>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="ancestor::rng:define[1]"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </body>
	</html>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="nav-header">
    <xsl:param name="home"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>

    <div class="headerNav">
      <a href="{$home}">
	<img src="images/nav-home.png" alt="[H]" border="0"/>
      </a>

      <xsl:choose>
	<xsl:when test="$prev">
	  <a href="{$prev}">
	    <img src="images/nav-prev.png" alt="[P]" border="0"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <img src="images/nav-xprev.png" alt="[P]" border="0"/>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
	<xsl:when test="$next">
	  <a href="{$next}">
	    <img src="images/nav-next.png" alt="[N]" border="0"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <img src="images/nav-xnext.png" alt="[N]" border="0"/>
	</xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="rng:grammar|doc:content-model">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:define[rng:element]" priority="2">
    <xsl:param name="elemNum" select="1"/>

    <div>
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="$elemNum = 1">define-first</xsl:when>
	  <xsl:otherwise>define-next</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="rng:define">
    <!-- skip the ones that aren't elements -->
  </xsl:template>

  <xsl:template match="rng:text">
    <li><em>text</em></li>
  </xsl:template>

  <xsl:template match="rng:notAllowed">
    <!-- nop -->
  </xsl:template>

  <xsl:template match="rng:empty">
    <li><em>EMPTY</em></li>
  </xsl:template>

  <xsl:template match="rng:nsName">
    <li>
      <em>any</em> element in the <tt><xsl:value-of select="@ns"/></tt> namespace
    </li>
  </xsl:template>

  <xsl:template match="rng:anyName">
    <li>
      <em>any</em> element
    </li>
  </xsl:template>

  <xsl:template match="rng:anyName" mode="attributes">
    <em>any</em> attribute
    <xsl:if test="rng:except">
      <ul>
	<li>Except:
	  <ul>
	    <xsl:apply-templates mode="attributes"/>
	  </ul>
	</li>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:nsName" mode="attributes">
    <li>
      <em>any</em> attribute in the <tt><xsl:value-of select="@ns"/></tt> namespace
    </li>
  </xsl:template>

  <xsl:template match="rng:element">
    <xsl:param name="elemNum" select="1"/>
    <xsl:variable name="xdefs" select="key('elemdefs', @name)"/>

    <div class="element">
      <a name="{ancestor::rng:define[1]/@name}"/>
      <xsl:choose>
	<xsl:when test="@name">
	  <tt>
	    <xsl:value-of select="@name"/>
	  </tt>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="ancestor::rng:define[1]/@name"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="count($xdefs) &gt; 1">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="ancestor::rng:define[1]/@name"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:text> ::=</xsl:text>

      <ul>
	<xsl:choose>
	  <xsl:when test="doc:content-model">
	    <xsl:apply-templates select="doc:content-model"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates/>
	  </xsl:otherwise>
	</xsl:choose>
      </ul>

      <xsl:apply-templates select="doc:attributes"/>
      <xsl:apply-templates select="doc:rules"/>
    </div>
  </xsl:template>

  <xsl:template match="doc:attributes">
    <xsl:variable name="attributes" select=".//rng:attribute"/>

    <xsl:variable name="cmnAttr"
		  select="$attributes[@name='id' and parent::rng:optional]
		          |$attributes[@name='xml:lang']
			  |$attributes[@name='xml:base']
			  |$attributes[@name='remap']
			  |$attributes[@name='xreflabel']
			  |$attributes[@name='revisionflag']
			  |$attributes[@name='arch']
			  |$attributes[@name='condition']
			  |$attributes[@name='conformance']
			  |$attributes[@name='os']
			  |$attributes[@name='revision']
			  |$attributes[@name='security']
			  |$attributes[@name='userlevel']
			  |$attributes[@name='vendor']
			  |$attributes[@name='role']
			  |$attributes[@name='version']"/>

    <xsl:variable name="cmnAttrIdReq"
		  select="$attributes[@name='id' and not(parent::rng:optional)]
		          |$attributes[@name='xml:lang']
			  |$attributes[@name='xml:base']
			  |$attributes[@name='remap']
			  |$attributes[@name='xreflabel']
			  |$attributes[@name='revisionflag']
			  |$attributes[@name='arch']
			  |$attributes[@name='condition']
			  |$attributes[@name='conformance']
			  |$attributes[@name='os']
			  |$attributes[@name='revision']
			  |$attributes[@name='security']
			  |$attributes[@name='userlevel']
			  |$attributes[@name='vendor']
			  |$attributes[@name='role']
			  |$attributes[@name='version']"/>

    <xsl:variable name="cmnAttrEither" select="$cmnAttr|$cmnAttrIdReq"/>

    <xsl:variable name="cmnLinkAttr"
		  select="$attributes[@name='href' and $attributes[@name='linkend']]
		          |$attributes[@name='linkend' and $attributes[@name='href']]"/>

    <xsl:variable name="otherAttr"
		  select="set:difference($attributes,
		                         $cmnAttr|$cmnAttrIdReq|$cmnLinkAttr)"/>

    <xsl:choose>
      <xsl:when test="count($cmnAttr) = 16 and $cmnLinkAttr">
	<p>Common attributes and common linking attributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttrIdReq) = 16 and $cmnLinkAttr">
	<p>Common attributes (ID required) and common linking atttributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttr) = 16">
	<p>Common attributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttrIdReq) = 16">
	<p>Common attributes (ID required).</p>
      </xsl:when>
      <xsl:when test="$cmnLinkAttr">
	<p>Common linking attributes.</p>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="count($cmnAttrEither) != 16 or count($otherAttr) &gt; 0">
      <p>
	<xsl:choose>
	  <xsl:when test="count($cmnAttr) = 16 
		          or count($cmnAttrIdReq) = 15
		  	  or $cmnLinkAttr">
	    <xsl:text>Additional attributes:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Attributes:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text> (Required attributes, if any, are </xsl:text>
	<b>bold</b>
	<xsl:text>)</xsl:text>
      </p>

      <ul>
	<xsl:for-each select="rng:interleave/*|*[not(self::rng:interleave)]">
	  <xsl:sort select="descendant-or-self::rng:attribute/@name"/>
	  <!-- don't bother with common attributes -->
	  <xsl:variable name="name" select="descendant-or-self::rng:attribute/@name"/>
	  <xsl:choose>
	    <xsl:when test="$cmnAttrEither[@name=$name]|$cmnLinkAttr[@name=$name]"/>
	    <xsl:otherwise>
	      <xsl:apply-templates select="." mode="attributes"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:optional" mode="attributes">
    <xsl:apply-templates mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:choice" mode="attributes">
    <li>
      <xsl:choose>
	<xsl:when test="ancestor::rng:optional">
	  <em>At most one of:</em>
	</xsl:when>
	<xsl:otherwise>
	  <em>Exactly one of:</em>
	</xsl:otherwise>
      </xsl:choose>
      <ul>
	<xsl:apply-templates mode="attributes"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="rng:group" mode="attributes">
    <li>
      <em>Each of:</em>
      <ul>
	<xsl:apply-templates mode="attributes"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="rng:interleave" mode="attributes">
    <xsl:apply-templates mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:ref" mode="attributes">
    <xsl:variable name="attrs" select="key('defs', @name)/rng:attribute"/>

    <xsl:choose>
      <xsl:when test="count($attrs) &gt; 1">
	<li>
	  <xsl:choose>
	    <xsl:when test="ancestor::rng:optional">
	      <em>At most one of:</em>
	    </xsl:when>
	    <xsl:otherwise>
	      <em><b>Each of:</b></em>
	    </xsl:otherwise>
	  </xsl:choose>
	  <ul>
	    <xsl:apply-templates select="$attrs" mode="attributes">
	      <xsl:with-param name="optional" select="ancestor::rng:optional"/>
	      <xsl:with-param name="choice" select="ancestor::rng:choice"/>
	    </xsl:apply-templates>
	  </ul>
	</li>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="$attrs" mode="attributes">
	  <xsl:with-param name="optional" select="ancestor::rng:optional"/>
	  <xsl:with-param name="choice" select="ancestor::rng:choice"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:attribute" mode="attributes">
    <xsl:param name="optional" select="ancestor::rng:optional
	                               |ancestor::rng:zeroOrMore"/>
    <xsl:param name="choice" select="ancestor::rng:choice"/>

    <xsl:variable name="attrContent">
      <xsl:choose>
	<xsl:when test="@name">
	  <xsl:value-of select="@name"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates mode="attributes"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li>
      <xsl:choose>
	<xsl:when test="$optional">
	  <xsl:copy-of select="$attrContent"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:choose>
	    <xsl:when test="@name">
	      <b>
		<xsl:value-of select="@name"/>
	      </b>
	    </xsl:when>
	    <xsl:otherwise>
	      <b>Required:</b>
	      <xsl:copy-of select="$attrContent"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
	<xsl:when test="rng:choice|rng:value">
	  <xsl:text> (enumeration)</xsl:text>
	  <ul>
	    <xsl:for-each select="rng:choice/rng:value|rng:value">
	      <li>
		<xsl:text>“</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>”</xsl:text>
	      </li>
	    </xsl:for-each>
	  </ul>
	</xsl:when>
	<xsl:when test="rng:data">
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="rng:data/@type"/>
	  <xsl:text>)</xsl:text>
	</xsl:when>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="doc:rules">
    <p>Additional constraints:</p>
    <ul>
      <xsl:for-each select=".//s:assert">
	<li>
	  <xsl:value-of select="."/>
	</li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="rng:value">
    <xsl:if test="position() &gt; 1"> | </xsl:if>
    <span class="{local-name()}">
      <xsl:text>“</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>”</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="rng:ref">
    <xsl:variable name="elemName" select="(key('defs', @name)/rng:element)[1]/@name"/>
    <xsl:variable name="xdefs" select="key('elemdefs', $elemName)"/>

    <xsl:variable name="target">
      <xsl:choose>
	<xsl:when test="$elemName">
	  <xsl:value-of select="concat($elemName, '.html')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat(@name, '.html')"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="count($xdefs) &gt; 1">
	<xsl:text>#</xsl:text>
	<xsl:value-of select="@name"/>
      </xsl:if>
    </xsl:variable>

    <li>
      <xsl:choose>
	<xsl:when test="$elemName">
	  <tt>
	    <a href="{$target}">
	      <xsl:value-of select="key('defs', @name)/rng:element/@name"/>
	    </a>
	  </tt>
	  <xsl:if test="parent::rng:optional">?</xsl:if>
	</xsl:when>
	<xsl:otherwise>
	  <a href="{$target}">
	    <xsl:value-of select="@name"/>
	  </a>
	  <xsl:if test="parent::rng:optional">?</xsl:if>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:if test="count($xdefs) &gt; 1">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="rng:optional">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore">
    <li><xsl:text>Zero or more of:</xsl:text></li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="rng:oneOrMore">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional one or more of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One or more of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="rng:group">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional sequence of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Sequence of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:interleave">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional interleave of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Interleave of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:choice">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optionally one of: </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One of: </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

</xsl:stylesheet>
