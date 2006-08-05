<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version="2.0">

<!--
xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
xmlns:u="http://nwalsh.com/xsl/unittests#"
-->

<xsl:import href="../../xsl2/html/docbook.xsl"/>

<xsl:output
    method="xhtml"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:param name="root.elements">
  <db:slides/>
</xsl:param>

<xsl:param name="docbook.css" select="'slides.css'"/>

<!-- ============================================================ -->

<xsl:template name="t:head">
  <xsl:param name="notes" select="0"/>

  <title>
    <xsl:choose>
      <xsl:when test="db:info/db:title">
	<xsl:value-of select="db:info/db:title"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>???</xsl:text>
	<xsl:message>
	  <xsl:text>Warning: no title for root element: </xsl:text>
	  <xsl:value-of select="local-name(.)"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </title>

  <link rel="home" href="{f:filename(/db:slides, $notes)}" title="Home"/>
  <link rel="contents" title="Contents" href="toc.html"/>

  <xsl:if test="self::db:foil">
    <link rel="up" title="Up" href="{f:filename(parent::*, $notes)}"/>
  </xsl:if>

  <link rel="first" title="First" href="{f:filename((//db:foil)[1], $notes)}"/>

  <xsl:variable name="pfoils"
		select="(preceding::db:foil
			 |preceding-sibling::db:foil
			 |parent::db:foilgroup
			 |parent::db:slides)"/>

  <xsl:if test="$pfoils">
    <link rel="prev" title="Previous"
	  href="{f:filename($pfoils[last()], $notes)}"/>
  </xsl:if>

  <xsl:variable name="nfoils"
		select="(following::db:foil
			 |following-sibling::db:foil
			 |following::db:foilgroup
			 |db:foil|db:foilgroup)"/>

  <xsl:if test="$nfoils">
    <link rel="next" title="Next" href="{f:filename($nfoils[1], $notes)}"/>
  </xsl:if>

  <xsl:if test="$nfoils">
    <link rel="last" title="Last" href="{f:filename($nfoils[last()], $notes)}"/>
  </xsl:if>

  <xsl:for-each select="//db:foilgroup">
    <link rel="section" href="{f:filename(.,$notes)}">
      <xsl:attribute
	  name="title"
	  select="if (string-length(db:info/db:title) &gt; 20)
	          then concat(substring(db:info/db:title,1,17),'...')
		  else db:info/db:title"/>
    </link>
  </xsl:for-each>

  <xsl:call-template name="css-style"/>

  <script type="text/javascript" language="javascript" src="script/ua.js"/>
  <script type="text/javascript" language="javascript" src="script/xbDOM.js"/>
  <script type="text/javascript" language="javascript" src="script/xbLibrary.js"/>
  <script language="javascript" type="text/javascript">
    <xsl:text>xblibrary = new xbLibrary('script/');</xsl:text>
  </script>
  <script type="text/javascript" language="javascript" src="script/xbStyle.js"/>
  <script type="text/javascript" src="script/overlay.js"/>
  <script type="text/javascript" src="script/slides.js"/>

  <xsl:call-template name="javascript"/>
</xsl:template>

<xsl:template name="t:foil-header">
  <div class="header">
    <xsl:apply-templates select="db:info/db:title" mode="m:titlepage-mode"/>
  </div>
</xsl:template>

<xsl:template name="t:foil-body">
  <div class="body">
    <xsl:apply-templates select="node() except (db:foil|db:foilgroup)"/>

    <xsl:if test="self::db:foilgroup">
      <ul>
	<xsl:apply-templates select="db:foil" mode="m:slidetoc"/>
      </ul>
    </xsl:if>

  </div>
</xsl:template>

<xsl:template name="t:foil-footer">
  <div id="overlayDiv" class="footer">
    <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
  </div>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:slides" mode="m:root">
  <xsl:if test="$save.normalized.xml != 0">
    <xsl:message>Saving normalized xml.</xsl:message>
    <xsl:result-document href="normalized.xml">
      <xsl:copy-of select="."/>
    </xsl:result-document>
  </xsl:if>

  <xsl:result-document href="index.html">
    <html>
      <head>
	<xsl:call-template name="t:head"/>
      </head>
      <body>
	<h1>Slides info…</h1>
      </body>
    </html>
  </xsl:result-document>
  
  <xsl:apply-templates select="db:foil|db:foilgroup"/>

  <xsl:result-document href="toc.html">
    <html>
      <head>
	<xsl:call-template name="t:head"/>
      </head>
      <body>
	<h1>Contents</h1>
	<xsl:if test="db:foil">
	  <ul>
	    <xsl:apply-templates select="db:foil"
				 mode="m:slidetoc"/>
	  </ul>
	</xsl:if>
	<xsl:if test="db:foilgroup">
	  <ul>
	    <xsl:apply-templates select="db:foilgroup"
				 mode="m:slidetoc"/>
	  </ul>
	</xsl:if>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template match="db:slides/db:info/db:title
		     |db:foilgroup/db:info/db:title
		     |db:foil/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:foil|db:foilgroup">
  <xsl:result-document href="{f:filename(.,0)}">
    <html>
      <head>
	<xsl:call-template name="t:head"/>
	<link rel="bookmark" href="{f:filename(.,1)}" title="Speaker notes"/>
      </head>
      <body onload="newPage(1)" onkeypress="navigate(event)">
	<div class="foil">
	  <xsl:call-template name="t:foil-header"/>
	  <xsl:call-template name="t:foil-body"/>
	  <xsl:call-template name="t:foil-footer"/>
	</div>
      </body>
    </html>
  </xsl:result-document>

  <xsl:result-document href="{f:filename(.,1)}">
    <html>
      <head>
	<xsl:call-template name="t:head">
	  <xsl:with-param name="notes" select="1"/>
	</xsl:call-template>
	<link rel="bookmark" href="{f:filename(.,0)}" title="Foil"/>
      </head>
      <body onload="newPage(1)" onkeypress="navigate(event)">
	<div class="speakernotes">
	  <xsl:call-template name="t:foil-header"/>
	  <xsl:if test="db:speakernotes">
	    <div class="notes">
	      <h2>Notes</h2>
	      <xsl:apply-templates select="db:speakernotes/*"/>
	    </div>
	  </xsl:if>
	  <xsl:call-template name="t:foil-footer"/>
	  <div class="thumbnail">
	    <xsl:apply-templates select="node() except db:foil"/>
	  </div>
	</div>
      </body>
    </html>
  </xsl:result-document>

  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<xsl:template match="db:speakernotes"/>

<!-- ============================================================ -->

<xsl:template match="db:foilgroup" mode="m:slidetoc">
  <li>
    <a href="{f:filename(.,0)}">
      <xsl:value-of select="db:info/db:title"/>
    </a>
    <ul>
      <xsl:apply-templates select="db:foil" mode="m:slidetoc"/>
    </ul>
  </li>
</xsl:template>

<xsl:template match="db:foil" mode="m:slidetoc">
  <li>
    <a href="{f:filename(.,0)}">
      <xsl:value-of select="db:info/db:title"/>
    </a>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="f:filename" as="xs:string">
  <xsl:param name="foil" as="element()"/>
  <xsl:param name="notes"/>

  <xsl:variable name="basename"
		select="if ($notes = 0) then 'foil' else 'notes'"/>

  <xsl:variable name="basename">
    <xsl:choose>
      <xsl:when test="$notes = 0 and $foil[self::db:slides]">index</xsl:when>
      <xsl:when test="$foil[self::db:slides]">notes</xsl:when>
      <xsl:when test="$foil[self::db:foilgroup]">
	<xsl:value-of select="$basename"/>
	<xsl:text>group</xsl:text>
	<xsl:number value="count($foil//preceding::db:foilgroup)+1" format="01"/>
      </xsl:when>
      <xsl:when test="$foil[self::db:foil]">
	<xsl:value-of select="$basename"/>
	<xsl:number value="count($foil//preceding::db:foil)+1" format="01"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
	  <xsl:text>Attempt to get filename for: </xsl:text>
	  <xsl:value-of select="name($foil)"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="concat($basename, '.html')"/>
</xsl:function>

</xsl:stylesheet>
