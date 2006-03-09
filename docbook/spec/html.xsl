<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl"/>

<xsl:variable name="tcProduct" select="//articleinfo/productname[1]"/>
<xsl:variable name="tcProductVersion" select="//articleinfo/productnumber[1]"/>
<xsl:variable name="tcArtifactType" select="'spec'"/>
<xsl:variable name="tcStage"
	      select="//articleinfo/releaseinfo[@role='stage'][1]"/>
<xsl:variable name="tcRevision" select="//articleinfo/pubsnumber[1]"/>
<xsl:variable name="tcLanguage" select="/@lang"/>
<xsl:variable name="tcForm" select="'xml'"/>

<xsl:variable name="odnRoot">
  <xsl:value-of select="$tcProduct"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcProductVersion"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcArtifactType"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcStage"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="$tcRevision"/>
  <xsl:if test="$tcLanguage != 'en' and $tcLanguage != ''">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$tcLanguage"/>
  </xsl:if>
</xsl:variable>

<xsl:param name="css.path"
           select="'http://www.oasis-open.org/spectools/css/'"/>

<xsl:param name="css.stylesheet">
  <xsl:choose>
    <xsl:when test="$tcStage = 'wd'">oasis-wd.css</xsl:when>
    <xsl:when test="$tcStage = 'cd'">oasis-cd.css</xsl:when>
    <xsl:when test="$tcStage = 'pr'">oasis-pr.css</xsl:when>
    <xsl:when test="$tcStage = 'cs'">oasis-cs.css</xsl:when>
    <xsl:when test="$tcStage = 'os'">oasis-os.css</xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized stage: '</xsl:text>
	<xsl:value-of select="$tcStage"/>
        <xsl:text>'; styling as Working Draft.</xsl:text>
      </xsl:message>
      <xsl:text>oasis-wd.css</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>

  <meta name="tcProduct" content="{$tcProduct}"/>
  <meta name="tcProductVersion" content="{$tcProductVersion}"/>
  <meta name="tcArtifactType" content="{$tcArtifactType}"/>
  <meta name="tcStage" content="{$tcStage}"/>
  <meta name="tcRevision" content="{$tcRevision}"/>
  <meta name="tcLanguage" content="{$tcLanguage}"/>
  <meta name="tcForm" content="html"/>

  <style type="text/css">
    span.paranum { color: #7F7F7F;
                   font-style: italic;
                   font-family: monospace;
                 }
    span.filename { font-weight: bold; }		 
  </style>
</xsl:template>

<xsl:template name="article.titlepage">
  <div class="titlepage">
    <p class="logo">
      <a href="http://www.oasis-open.org/">
	<img src="http://www.oasis-open.org/spectools/images/oasis.gif"
	     alt="OASIS" border="0" />
      </a>
    </p>

    <xsl:apply-templates select="//articleinfo/title"
			 mode="titlepage.mode"/>

    <h2>
      <xsl:choose>
	<xsl:when test="$tcStage = 'wd'">Working Draft</xsl:when>
	<xsl:when test="$tcStage = 'cd'">Committee Draft</xsl:when>
	<xsl:when test="$tcStage = 'pr'">Public Review Draft</xsl:when>
	<xsl:when test="$tcStage = 'cs'">Committee Specification</xsl:when>
	<xsl:when test="$tcStage = 'os'">OASIS Standard</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>Unrecognized stage: '</xsl:text>
	    <xsl:value-of select="$tcStage"/>
	    <xsl:text>'; labeling as Working Draft.</xsl:text>
	  </xsl:message>
	  <xsl:text>Working Draft</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>,&#160;</xsl:text>
      <xsl:value-of select="//articleinfo/pubdate[1]"/>
    </h2>

    <dl>
      <dt><span class="docid-heading">Document identifier:</span></dt>
      <dd>
	<p>
	  <xsl:value-of select="$odnRoot"/>
	  <xsl:text> (</xsl:text>
	  <a href="{$odnRoot}.xml">.xml</a>
	  <xsl:text>, </xsl:text>
	  <a href="{$odnRoot}.html">.html</a>
	  <xsl:text>, </xsl:text>
	  <a href="{$odnRoot}.pdf">.pdf</a>
	  <xsl:text>)</xsl:text>
	</p>
      </dd>

      <dt><span class="loc-heading">Location:</span></dt>
      <dd>
	<p>
	  <a href="{//articleinfo/releaseinfo[@role='location']}">
	    <xsl:value-of select="//articleinfo/releaseinfo[@role='location']"/>
	  </a>
	</p>
      </dd>

      <dt>
	<span class="editor-heading">
	  <xsl:text>Editor</xsl:text>
	  <xsl:if test="count(//articleinfo//editor) &gt; 1">
	    <xsl:text>s</xsl:text>
	  </xsl:if>
	  <xsl:text>:</xsl:text>
	</span>
      </dt>
      <dd>
	<xsl:for-each select="//articleinfo//editor">
	  <p>
	    <xsl:apply-templates select="." mode="titlepage.mode"/>
	  </p>
	</xsl:for-each>
      </dd>

      <dt><span class="abstract-heading">Abstract:</span></dt>
      <dd>
	<xsl:apply-templates select="//articleinfo/abstract[1]/*"/>
      </dd>

      <dt><span class="status-heading">Status:</span></dt>
      <dd>
	<xsl:apply-templates
	    select="//articleinfo/legalnotice[@role='status']/*"/>
      </dd>
    </dl>

    <xsl:apply-templates select="//articleinfo/copyright" mode="titlepage.mode"/>
  </div>
  <hr />
</xsl:template>

</xsl:stylesheet>
