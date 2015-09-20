<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs='http://www.w3.org/2001/XMLSchema'
		exclude-result-prefixes="db f h m t xlink xs"
                version="2.0">

<xsl:import href="/sourceforge/docbook/xsl2/base/html/docbook.xsl"/>

<xsl:param name="generate.toc" as="element()*">
<tocparam path="appendix" toc="0" title="0"/>
<tocparam path="article"  toc="1" title="1"/>
</xsl:param>

<xsl:param name="section.label.includes.component.label" select="1"/>

<xsl:param name="bibliography.collection" select="'bibliography.xml'"/>

<xsl:param name="docbook.css" select="'docbook.css'"/>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="0"/>
<ln path="programlistingco" everyNth="0"/>
<ln path="screen" everyNth="0"/>
<ln path="synopsis" everyNth="0"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<xsl:param name="profile.condition" select="'online'"/>

<!-- ============================================================ -->

<xsl:template name="t:user-head-content">
  <xsl:param name="node" select="."/>
  <link href="OASIS_Specification_Template_v1-0.css"
	rel="stylesheet" type="text/css" />

  <style type="text/css">
h1,
div.toc p b { 
  font-family: Arial, Helvetica, sans-serif;
  font-size: 18pt;
  font-weight: bold;
  list-style-type: decimal;
  color: #66116D;
}
  </style>
</xsl:template>

<xsl:template match="db:article">
  <xsl:variable name="toc.params"
		select="f:find-toc-params(., $generate.toc)"/>

  <p>
    <img src="http://docs.oasis-open.org/templates/OASISLogo.jpg"
	 alt="OASIS logo" width="203" height="54" />
  </p>

  <xsl:apply-templates select="db:info"/>

  <xsl:call-template name="make-lots">
    <xsl:with-param name="toc.params" select="$toc.params"/>
    <xsl:with-param name="toc">
      <xsl:call-template name="component-toc">
	<xsl:with-param name="toc.title" select="$toc.params/@title != 0"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates select="*[not(self::db:info)]"/>
</xsl:template>

<xsl:template match="db:article/db:info">
  <div class="head">
    <h1>
      <xsl:apply-templates select="db:title/node()"/>
      <xsl:text> Version </xsl:text>
      <xsl:value-of select="db:productnumber"/>
    </h1>

    <h2>
      <xsl:value-of select="../@status"/>
    </h2>

    <h2 class="pubdate">
      <xsl:value-of select="format-date(xs:date(db:pubdate[1]),
	                                '[D01] [MNn,*-3] [Y0001]')"/>
    </h2>

    <xsl:variable name="odnRoot">
      <xsl:value-of select="db:productname[1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:productnumber[1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="'spec'"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:releaseinfo[@role='stage'][1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:biblioid[@class='pubsnumber'][1]"/>
      <xsl:if test="ancestor::*[@xml:lang][1]
		    and ancestor::*[@xml:lang][1]/@xml:lang != 'en'">
	<xsl:text>-</xsl:text>
	<xsl:value-of select="ancestor::*[@xml:lang][1]/@xml:lang"/>
      </xsl:if>
    </xsl:variable>

    <div class="uris">
      <h3>Specification URIs:</h3>
      <dl>
	<dt>This Version:</dt>
	<xsl:for-each select="('.html','.pdf','.xml')">
	  <dd>
	    <a href="{$odnRoot}{.}">
	      <xsl:text>http://docs.oasis-open.org/docbook/specs/</xsl:text>
	      <xsl:value-of select="$odnRoot"/>
	      <xsl:value-of select="."/>
	    </a>
	  </dd>
	</xsl:for-each>
      </dl>
    </div>

    <div class="committee">
      <dl>
	<dt>Technical Committee:</dt>
	<xsl:for-each select="db:org/db:orgdiv">
	  <dd>
	    <a href="{@xlink:href}">
	      <xsl:value-of select="."/>
	    </a>
	  </dd>
	</xsl:for-each>

	<dt>
	  <xsl:text>Chair</xsl:text>
	  <xsl:if test="count(db:othercredit[@otherclass = 'chair']) &gt; 1">
	    <xsl:text>s</xsl:text>
	  </xsl:if>
	</dt>
	<xsl:apply-templates select="db:othercredit[@otherclass = 'chair']"
			     mode="spec.titlepage"/>

	<xsl:variable name="editors" select="db:authorgroup/db:editor|db:editor"/>
	<dt>
	  <xsl:text>Editor</xsl:text>
	  <xsl:if test="count($editors) &gt; 1">
	    <xsl:text>s</xsl:text>
	  </xsl:if>
	</dt>
	<xsl:apply-templates select="$editors" mode="spec.titlepage"/>

	<xsl:variable name="replaces" select="db:bibliorelation[@type='replaces']"/>
	<xsl:variable name="supersedes" select="db:bibliorelation[@othertype='supersedes']"/>
	<xsl:variable name="related" select="db:bibliorelation[@type='references']"/>

	<xsl:if test="$replaces | $supersedes | $related">
	  <dt>Related Work:</dt>
	  <dd>
	    <dl>
	      <xsl:if test="$replaces|$supersedes">
		<dt>This specification replaces or supersedes:</dt>
		<xsl:for-each select="$replaces|$supersedes">
		  <dd>
		    <xsl:value-of select="@xlink:href"/>
		  </dd>
		</xsl:for-each>
	      </xsl:if>
	      <xsl:if test="$related">
		<dt>This specification is related to:</dt>
		<xsl:for-each select="$related">
		  <dd>
		    <xsl:value-of select="@xlink:href"/>
		  </dd>
		</xsl:for-each>
	      </xsl:if>
	    </dl>
	  </dd>
	</xsl:if>
      </dl>
    </div>

    <xsl:if test="db:bibliomisc[@role='namespace']">
      <div class="namespaces">
	<dl>
	  <dt>
	    <xsl:text>Declared XML Namespace</xsl:text>
	    <xsl:if test="count(db:bibliomisc[@role='namespace']) &gt; 1">s</xsl:if>
	  </dt>
	  <xsl:for-each select="db:bibliomisc[@role='namespace']">
	    <dd>
	      <xsl:value-of select="."/>
	    </dd>
	  </xsl:for-each>
	</dl>
      </div>
    </xsl:if>

    <div class="abstract">
      <h3>Abstract:</h3>
      <xsl:apply-templates select="db:abstract"/>
    </div>

    <div class="abstract">
      <h3>Status:</h3>
      <xsl:apply-templates select="db:legalnotice[@role='status']"/>
    </div>

    <div class="notices">
      <h2>Notices:</h2>
      <xsl:apply-templates select="db:legalnotice[@role='notices']"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="db:editor|db:editor|db:othercredit" mode="spec.titlepage">
  <dd>
    <xsl:apply-templates select="db:personname" mode="spec.titlepage"/>
    <xsl:if test="db:affiliation/db:orgname">
      <xsl:text>, </xsl:text>
      <span class="affiliation">
	<xsl:apply-templates select="db:affiliation/db:orgname"/>
      </span>
    </xsl:if>
    <xsl:if test="db:email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="db:email"/>
    </xsl:if>
  </dd>
</xsl:template>

<xsl:template match="db:personname" mode="spec.titlepage">
  <span class="personname">
    <xsl:apply-templates select="db:firstname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="db:surname"/>
  </span>
</xsl:template>

<xsl:template match="db:abstract|db:legalnotice">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:section/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hslevel"
		select="if ($depth &lt; 6) then $depth else 6"/>

  <xsl:variable name="hlevel"
		select="if (ancestor::db:appendix) then $hslevel+1 else $hslevel"/>

  <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
