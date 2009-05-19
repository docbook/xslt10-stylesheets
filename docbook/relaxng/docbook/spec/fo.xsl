<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db m t xlink xs"
                version="2.0">

<xsl:import href="/sourceforge/docbook/xsl2/base/fo/docbook.xsl"/>

<xsl:param name="draft.watermark.image"
           select="'/sourceforge/docbook/xsl/images/draft.png'"/>

<xsl:param name="generate.toc" as="element()*">
  <tocparam path="appendix" toc="0" title="0"/>
  <tocparam path="article"  toc="1" title="1"/>
</xsl:param>

<xsl:param name="autolabel.elements">
  <db:appendix format="A"/>
  <db:chapter/>
  <db:figure/>
  <db:example/>
  <db:table/>
  <db:equation/>
  <db:part format="I"/>
  <db:reference format="I"/>
  <db:preface/>
  <db:qandadiv/>
  <db:section format="1"/>
  <db:refsection/>
</xsl:param>

<xsl:param name="ulink.footnotes" select="0"/>

<xsl:param name="ulink.hyphenate" select="'&#xAD;'"/>

<xsl:param name="section.label.includes.component.label" select="1"/>

<xsl:param name="bibliography.collection" select="'bibliography.xml'"/>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="0"/>
<ln path="programlistingco" everyNth="0"/>
<ln path="screen" everyNth="0"/>
<ln path="synopsis" everyNth="0"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<xsl:param name="profile.condition" select="'print'"/>

<xsl:attribute-set name="section.title.level1.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'18pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level2.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'14pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'13pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level4.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'12pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level5.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level6.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
</xsl:attribute-set>

<xsl:template name="t:head-sep-rule">
  <xsl:param name="pageclass"/>
  <xsl:param name="sequence"/>
  <xsl:param name="gentext-key"/>

  <xsl:if test="$sequence != 'first' and $header.rule != 0">
    <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-color">black</xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->
<!-- Wicked hack! -->

<xsl:template match="db:link" mode="m:normalize">
  <xsl:choose>
    <xsl:when test="contains(@xlink:href,'/tracker/')">
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:next-match/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:attribute-set name="oasis.header.properties">
  <xsl:attribute name="color" select="'#66116D'"/>
  <xsl:attribute name="font-family" select="'Arial, Helvetica, sans-serif'"/>
  <xsl:attribute name="font-weight" select="'bold'"/>
</xsl:attribute-set>

<xsl:attribute-set name="oasis.head1.properties"
		   use-attribute-sets="oasis.header.properties">
  <xsl:attribute name="font-size" select="'18pt'"/>
  <xsl:attribute name="margin-top" select="'18pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="oasis.head2.properties"
		   use-attribute-sets="oasis.header.properties">
  <xsl:attribute name="font-size" select="'14pt'"/>
  <xsl:attribute name="margin-top" select="'14pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="oasis.head3.properties"
		   use-attribute-sets="oasis.header.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
  <xsl:attribute name="margin-top" select="'4pt'"/>
</xsl:attribute-set>

<!-- ============================================================ -->

<xsl:template match="db:article/db:info" mode="m:titlepage-mode">
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

  <fo:block margin-top="-0.75in">
    <fo:external-graphic
	src="url(http://docs.oasis-open.org/templates/OASISLogo.jpg)"
	margin-left="-5pt"/>
  </fo:block>

  <fo:block xsl:use-attribute-sets="oasis.head1.properties">
    <xsl:apply-templates select="db:title/node()"/>
    <xsl:text> Version </xsl:text>
    <xsl:value-of select="db:productnumber"/>
  </fo:block>

  <fo:block xsl:use-attribute-sets="oasis.head2.properties">
    <xsl:value-of select="../@status"/>
  </fo:block>

  <fo:block xsl:use-attribute-sets="oasis.head2.properties"
	    margin-bottom="4pt">
    <xsl:value-of select="format-date(xs:date(db:pubdate[1]),
	                              '[D01] [MNn,*-3] [Y0001]')"/>
  </fo:block>

  <fo:block xsl:use-attribute-sets="oasis.head3.properties"
	    margin-top="14pt">
    <xsl:text>Specification URIs:</xsl:text>
  </fo:block>

  <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
	    keep-together.within-column="always" 
	    keep-with-next.within-column="always">
    <xsl:text>This Version:</xsl:text>
  </fo:block>

  <fo:block margin-left="0.3in">
    <xsl:for-each select="('.html','.pdf','.xml')">
      <fo:block>
	<xsl:text>http://docs.oasis-open.org/docbook/specs/</xsl:text>
	<xsl:value-of select="$odnRoot"/>
	<xsl:value-of select="."/>
      </fo:block>
    </xsl:for-each>
  </fo:block>

  <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
	    keep-together.within-column="always" 
	    keep-with-next.within-column="always">
    <xsl:text>Technical Committee:</xsl:text>
  </fo:block>

  <fo:block margin-left="0.3in">
    <xsl:for-each select="db:org/db:orgdiv">
      <fo:block>
	<xsl:value-of select="."/>
      </fo:block>
    </xsl:for-each>
  </fo:block>

  <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
	    keep-together.within-column="always" 
	    keep-with-next.within-column="always">
    <xsl:text>Chair</xsl:text>
    <xsl:if test="count(db:othercredit[@otherclass = 'chair']) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </fo:block>

  <fo:block margin-left="0.3in">
    <xsl:apply-templates select="db:othercredit[@otherclass = 'chair']"
			 mode="spec.titlepage"/>
  </fo:block>

  <xsl:variable name="editors" select="db:authorgroup/db:editor|db:editor"/>

  <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
	    keep-together.within-column="always" 
	    keep-with-next.within-column="always">
    <xsl:text>Editor</xsl:text>
    <xsl:if test="count($editors) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </fo:block>

  <fo:block margin-left="0.3in">
    <xsl:apply-templates select="$editors" mode="spec.titlepage"/>
  </fo:block>

  <xsl:variable name="replaces" select="db:bibliorelation[@type='replaces']"/>
  <xsl:variable name="supersedes" select="db:bibliorelation[@othertype='supersedes']"/>
  <xsl:variable name="related" select="db:bibliorelation[@type='references']"/>

  <xsl:if test="$replaces | $supersedes | $related">
    <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
	      keep-together.within-column="always" 
	      keep-with-next.within-column="always">
	  <xsl:text>Related Work:</xsl:text>
    </fo:block>

    <fo:block margin-left="0.3in">
      <xsl:if test="$replaces|$supersedes">
	<fo:block xsl:use-attribute-sets="list.item.spacing"  
		  keep-together.within-column="always" 
		  keep-with-next.within-column="always"
		  font-weight="bold" font-family="Arial, Helvetica, sans-serif">
	  <xsl:text>This specification replaces or supersedes:</xsl:text>
	</fo:block>
	<fo:block margin-left="0.3in">
	  <xsl:for-each select="$replaces|$supersedes">
	    <fo:block>
	      <xsl:value-of select="@xlink:href"/>
	    </fo:block>
	  </xsl:for-each>
	</fo:block>
      </xsl:if>

      <xsl:if test="$related">
	<fo:block xsl:use-attribute-sets="list.item.spacing"  
		  keep-together.within-column="always" 
		  keep-with-next.within-column="always"
		  font-weight="bold" font-family="Arial, Helvetica, sans-serif">
	  <xsl:text>This specification is related to:</xsl:text>
	</fo:block>
	<fo:block margin-left="0.3in">
	  <xsl:for-each select="$related">
	    <fo:block>
	      <xsl:value-of select="@xlink:href"/>
	    </fo:block>
	  </xsl:for-each>
	</fo:block>
      </xsl:if>
    </fo:block>
  </xsl:if>

  <xsl:if test="db:bibliomisc[@role='namespace']">
      <fo:block xsl:use-attribute-sets="list.item.spacing oasis.head3.properties"
		keep-together.within-column="always" 
		keep-with-next.within-column="always">
	<xsl:text>Declared XML Namespace</xsl:text>
	<xsl:if test="count(db:bibliomisc[@role='namespace']) &gt; 1">s</xsl:if>
      </fo:block>

      <fo:block margin-left="0.3in">
	<xsl:for-each select="db:bibliomisc[@role='namespace']">
	  <fo:block>
	    <xsl:value-of select="."/>
	  </fo:block>
	</xsl:for-each>
      </fo:block>
  </xsl:if>

  <fo:block>
    <fo:block xsl:use-attribute-sets="oasis.head3.properties" margin-top="14pt"
	      keep-with-next.within-column="always">
      <xsl:text>Abstract:</xsl:text>
    </fo:block>
    <fo:block margin-left="0.3in" font-family="Arial, Helvetica, sans-serif">
      <xsl:apply-templates select="db:abstract"/>
    </fo:block>
  </fo:block>

  <fo:block>
    <fo:block xsl:use-attribute-sets="oasis.head3.properties" margin-top="14pt"
	      keep-with-next.within-column="always">
      <xsl:text>Status:</xsl:text>
    </fo:block>
    <fo:block margin-left="0.3in" font-family="Arial, Helvetica, sans-serif">
      <xsl:apply-templates select="db:legalnotice[@role='status']"/>
    </fo:block>
  </fo:block>

  <fo:block>
    <fo:block xsl:use-attribute-sets="oasis.head3.properties" margin-top="14pt"
	      keep-with-next.within-column="always">
      <xsl:text>Notices:</xsl:text>
    </fo:block>
    <fo:block font-family="Arial, Helvetica, sans-serif">
      <xsl:apply-templates select="db:legalnotice[@role='notices']"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="db:editor|db:editor|db:othercredit" mode="spec.titlepage">
  <fo:block>
    <xsl:apply-templates select="db:personname" mode="spec.titlepage"/>
    <xsl:if test="db:affiliation/db:orgname">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="db:affiliation/db:orgname"/>
    </xsl:if>
    <xsl:if test="db:email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="db:email"/>
    </xsl:if>
  </fo:block>
</xsl:template>

<xsl:template match="db:personname" mode="spec.titlepage">
  <fo:inline>
    <xsl:apply-templates select="db:firstname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="db:surname"/>
  </fo:inline>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
