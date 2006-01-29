<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
		xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
		xmlns:dtd="http://nwalsh.com/xmlns/dtd/"
		xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
		exclude-result-prefixes="exsl rng doc ctrl"
		version="1.0">

<!-- attempts, and currently fails, to produce a DTD -->

<xsl:include href="doc2dtd-tables.xsl"/>

<xsl:key name="pattern" match="rng:define" use="@name"/>

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:param name="debug" select="0"/>

<xsl:template match="/">
  <xsl:variable name="trimmed">
    <xsl:apply-templates mode="trim"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$debug != 0">
      <xsl:copy-of select="$trimmed"/>
    </xsl:when>
    <xsl:otherwise>
      <dtd:dtd>
	<xsl:apply-templates select="exsl:node-set($trimmed)/*"/>
      </dtd:dtd>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:element">
  <xsl:choose>
    <xsl:when test="../@name = 'db.titlereq.info'"/>
    <xsl:when test="../@name = 'db.titleonly.info'"/>
    <xsl:when test="../@name = 'db.titleonlyreq.info'"/>
    <xsl:when test="../@name = 'db.titleforbidden.info'"/>
    <xsl:when test="starts-with(../@name, 'db._')"/>
    <xsl:otherwise>
      <xsl:comment>
	<xsl:value-of select="../@name"/>
      </xsl:comment>
      <dtd:element name="{@name}">
	<xsl:apply-templates select="doc:content-model" mode="content-model"/>
      </dtd:element>

      <dtd:attlist name="{@name}">
	<xsl:apply-templates select="doc:attributes" mode="attributes"/>
      </dtd:attlist>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:define">
  <xsl:choose>
    <xsl:when test="@name = 'db.common.attributes'
	            or @name = 'db.common.linking.attributes'">
      <dtd:pe name="{@name}">
	<xsl:apply-templates select=".//rng:attribute" mode="attributes">
	  <xsl:with-param name="override" select="1"/>
	</xsl:apply-templates>
      </dtd:pe>
    </xsl:when>

    <!-- Handle the indexterm patterns -->

    <xsl:when test="@name = 'db.indexterm.startofrange'
	            or @name = 'db.indexterm.endofrange'">
      <!-- db.indexterm.singular handles all three cases -->
    </xsl:when>

    <!-- Handle the duplicate area patterns -->
    <xsl:when test="@name = 'db.area'">
      <!-- db.area.inareaset is the "right" one; it has an optional id -->
    </xsl:when>

    <!-- Handle the row patterns -->

    <xsl:when test="@name = 'db.entrytbl.row' and key('pattern', 'db.row')">
      <!-- db.row handles both cases -->
    </xsl:when>

    <!-- Handle the thead patterns -->

    <!-- Note: the extra testing in here for not(@name='xml:id') is necessary
         because the attribute generation code uses the presence of xml:id
	 to decide if common attributes should be output, so it mustn't appear
	 twice. -->

    <xsl:when test="@name = 'db.cals.thead' and key('pattern', 'db.html.thead')">
      <xsl:variable name="html.thead"
		    select="key('pattern', 'db.html.thead')"/>

      <xsl:copy-of select="$merged-thead"/>

      <dtd:attlist name="thead">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.thead/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.cals.entrytbl.thead'">
      <!-- nop; handled by the db.cals.thead branch -->
    </xsl:when>

    <xsl:when test="@name = 'db.html.thead' and key('pattern', 'db.cals.thead')">
      <!-- nop; handled by the db.cals.thead branch -->
    </xsl:when>

    <!-- Handle the tfoot patterns -->

    <xsl:when test="@name = 'db.cals.tfoot' and key('pattern', 'db.html.tfoot')">
      <xsl:variable name="html.tfoot"
		    select="key('pattern', 'db.html.tfoot')"/>

      <xsl:copy-of select="$merged-tfoot"/>

      <dtd:attlist name="tfoot">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.tfoot/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.html.tfoot' and key('pattern', 'db.cals.tfoot')">
      <!-- nop; handled by the db.cals.tfoot branch -->
    </xsl:when>

    <!-- Handle the tbody patterns -->

    <xsl:when test="@name = 'db.cals.tbody' and key('pattern', 'db.html.tbody')">
      <xsl:variable name="html.tbody"
		    select="key('pattern', 'db.html.tbody')"/>

      <xsl:copy-of select="$merged-tbody"/>

      <dtd:attlist name="tbody">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.tbody/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.cals.entrytbl.tbody'">
      <!-- nop; handled by the db.cals.thead branch -->
    </xsl:when>

    <xsl:when test="@name = 'db.html.tbody' and key('pattern', 'db.cals.tbody')">
      <!-- nop; handled by the db.cals.tbody branch -->
    </xsl:when>

    <!-- Handle the informaltable patterns -->

    <xsl:when test="@name = 'db.cals.informaltable'
		    and key('pattern', 'db.html.informaltable')">
      <xsl:variable name="html.informaltable"
		    select="key('pattern', 'db.html.informaltable')"/>

      <xsl:copy-of select="$merged-informaltable"/>

      <dtd:attlist name="informaltable">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.informaltable/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.html.informaltable'
		    and key('pattern', 'db.cals.informaltable')">
      <!-- nop; handled by the db.cals.informaltable branch -->
    </xsl:when>

    <!-- Handle the table patterns -->

    <xsl:when test="@name = 'db.cals.table'
		    and key('pattern', 'db.html.table')">
      <xsl:variable name="html.table"
		    select="key('pattern', 'db.html.table')"/>

      <xsl:copy-of select="$merged-table"/>

      <dtd:attlist name="table">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.table/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.html.table'
		    and key('pattern', 'db.cals.table')">
      <!-- nop; handled by the db.cals.table branch -->
    </xsl:when>

    <xsl:when test="@name = 'db.caption' and key('pattern', 'db.html.caption')">
      <xsl:variable name="html.caption"
		    select="key('pattern', 'db.html.caption')"/>

      <xsl:copy-of select="$merged-caption"/>

      <dtd:attlist name="caption">
	<xsl:apply-templates select="rng:element/doc:attributes"
			     mode="attributes"/>
	<xsl:apply-templates select="$html.caption/rng:element/doc:attributes//rng:attribute[not(@name='xml:id')]"
			     mode="attributes"/>
      </dtd:attlist>
    </xsl:when>

    <xsl:when test="@name = 'db.html.caption'
		    and key('pattern', 'db.caption')">
      <!-- nop; handled by the db.caption branch -->
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="comment()|text()|processing-instruction()">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="doc:content-model" mode="content-model">
  <xsl:choose>
    <xsl:when test=".//rng:group|.//rng:choice|.//rng:interleave">
      <xsl:apply-templates mode="content-model"/>
    </xsl:when>
    <xsl:otherwise>
      <dtd:group>
	<xsl:apply-templates mode="content-model"/>
      </dtd:group>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:group" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:group>
    <xsl:if test="$repeat != ''">
      <xsl:attribute name="repeat">
	<xsl:value-of select="$repeat"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="*" mode="content-model"/>
  </dtd:group>
</xsl:template>

<xsl:template match="rng:choice" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:choice>
    <xsl:if test="$repeat != ''">
      <xsl:attribute name="repeat">
	<xsl:value-of select="$repeat"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="*" mode="content-model"/>
  </dtd:choice>
</xsl:template>

<xsl:template match="rng:interleave" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:choice repeat="*">
    <xsl:apply-templates select="*" mode="content-model"/>
  </dtd:choice>
</xsl:template>

<xsl:template match="rng:optional" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <xsl:apply-templates mode="content-model">
    <xsl:with-param name="repeat" select="'?'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="rng:zeroOrMore" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:choice repeat="*">
    <xsl:apply-templates select="*" mode="content-model"/>
  </dtd:choice>
</xsl:template>

<xsl:template match="rng:oneOrMore" mode="content-model">
  <xsl:param name="repeat" select="''"/>

  <!-- make sure there's something in there... -->
  <xsl:variable name="content">
    <xsl:apply-templates select="*" mode="content-model"/>
  </xsl:variable>
  <xsl:variable name="contentNS" select="exsl:node-set($content)/*"/>

  <xsl:if test="count($contentNS) &gt; 0">
    <dtd:choice repeat="+">
      <xsl:copy-of select="$content"/>
    </dtd:choice>
  </xsl:if>
</xsl:template>

<xsl:template match="rng:text" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:PCDATA/>
</xsl:template>

<xsl:template match="rng:empty" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <dtd:EMPTY/>
</xsl:template>

<xsl:template match="rng:ref" mode="content-model">
  <xsl:param name="repeat" select="''"/>
  <xsl:variable name="def" select="key('pattern', @name)"/>
  <xsl:choose>
    <xsl:when test="@name = 'db.indexterm.startofrange'
		    and (../rng:ref[@name='db.indexterm.singular']
		         or ../rng:ref[@name='db.indexterm.endofrange'])">
      <!-- suppress -->
    </xsl:when>
    <xsl:when test="@name = 'db.indexterm.endofrange'
		    and ../rng:ref[@name='db.indexterm.singular']">
      <!-- suppress -->
    </xsl:when>
    <xsl:when test="@name = 'db.html.table'
		    and ../rng:ref[@name='db.cals.table']">
      <!-- suppress -->
    </xsl:when>
    <xsl:when test="@name = 'db.html.informaltable'
		    and ../rng:ref[@name='db.cals.informaltable']">
      <!-- suppress -->
    </xsl:when>
    <xsl:when test="@name = 'db._any.svg' or @name='db._any.mathml'">
      <!-- suppress -->
    </xsl:when>
    <xsl:when test="$def/rng:element">
      <xsl:if test="$def/rng:element/@name != ''">
	<dtd:ref name="{$def/rng:element/@name}">
	  <xsl:if test="$repeat != ''">
	    <xsl:attribute name="repeat">
	      <xsl:value-of select="$repeat"/>
	    </xsl:attribute>
	  </xsl:if>
	</dtd:ref>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <dtd:peref name="{@name}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="doc:attributes" mode="attributes">
  <xsl:apply-templates select=".//rng:attribute" mode="attributes"/>
</xsl:template>

<xsl:template match="rng:attribute" mode="attributes">
  <xsl:param name="override" select="0"/>

  <xsl:choose>
    <xsl:when test="$override = 0">
      <xsl:choose>
	<xsl:when test="@name = 'xml:id'">
	  <dtd:peref name="db.common.attributes"/>
	</xsl:when>
	<xsl:when test="@name = 'version'"/>
	<xsl:when test="@name = 'xml:lang'"/>
	<xsl:when test="@name = 'xml:base'"/>
	<xsl:when test="@name = 'remap'"/>
	<xsl:when test="@name = 'xreflabel'"/>
	<xsl:when test="@name = 'revisionflag'"/>
	<xsl:when test="@name = 'arch'"/>
	<xsl:when test="@name = 'condition'"/>
	<xsl:when test="@name = 'conformance'"/>
	<xsl:when test="@name = 'os'"/>
	<xsl:when test="@name = 'revision'"/>
	<xsl:when test="@name = 'security'"/>
	<xsl:when test="@name = 'userlevel'"/>
	<xsl:when test="@name = 'vendor'"/>
	<xsl:when test="@name = 'wordsize'"/>
	<xsl:when test="@name = 'dir'"/>
	<xsl:when test="@name = 'annotations'"/>

	<xsl:when test="@name = 'linkend'">
	  <dtd:peref name="db.common.linking.attributes"/>
	</xsl:when>
	<xsl:when test="@name = 'xlink:href'"/>
	<xsl:when test="@name = 'xlink:type'"/>
	<xsl:when test="@name = 'xlink:role'"/>
	<xsl:when test="@name = 'xlink:arcrole'"/>
	<xsl:when test="@name = 'xlink:title'"/>
	<xsl:when test="@name = 'xlink:show'"/>
	<xsl:when test="@name = 'xlink:actuate'"/>

	<xsl:otherwise>
	  <dtd:attribute name="{@name}">
	    <xsl:if test="@a:defaultValue">
	      <xsl:attribute name="default">
		<xsl:value-of select="@a:defaultValue"/>
	      </xsl:attribute>
	    </xsl:if>
	    <xsl:attribute name="occurs">
	      <xsl:choose>
		<xsl:when test="ancestor::rng:optional">optional</xsl:when>
		<xsl:when test="ancestor::rng:choice">optional</xsl:when>
		<xsl:otherwise>required</xsl:otherwise>
	      </xsl:choose>
	    </xsl:attribute>
	    <xsl:if test="rng:data">
	      <xsl:attribute name="type">
		<xsl:value-of select="rng:data/@type"/>
	      </xsl:attribute>
	    </xsl:if>
	    <xsl:if test=".//rng:value">
	      <xsl:text>(</xsl:text>
	      <xsl:for-each select=".//rng:value">
		<xsl:if test="position() &gt; 1">|</xsl:if>
		<xsl:value-of select="."/>
	      </xsl:for-each>

	      <!-- HACK -->
	      <xsl:if test="@name = 'class' and .//rng:value[1] = 'singular'">
		<xsl:text>|startofrange|endofrange</xsl:text>
	      </xsl:if>

	      <xsl:text>)</xsl:text>
	    </xsl:if>
	  </dtd:attribute>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <!-- HACK -->
      <xsl:if test="@name = 'xlink:href'">
	<dtd:attribute name="xmlns:xlink" occurs="fixed">
	  <xsl:text>http://www.w3.org/1999/xlink</xsl:text>
	</dtd:attribute>
      </xsl:if>

      <dtd:attribute name="{@name}">
	<xsl:attribute name="occurs">
	  <xsl:choose>
	    <xsl:when test="ancestor::rng:optional">optional</xsl:when>
	    <xsl:when test="ancestor::rng:choice">optional</xsl:when>
	    <xsl:when test="ancestor::rng:interleave">optional</xsl:when>
	    <xsl:otherwise>required</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<xsl:if test="rng:data">
	  <xsl:attribute name="type">
	    <xsl:value-of select="rng:data/@type"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="rng:choice">
	  <xsl:text>(</xsl:text>
	  <xsl:for-each select="rng:choice/rng:value">
	    <xsl:if test="position() &gt; 1">|</xsl:if>
	    <xsl:value-of select="."/>
	  </xsl:for-each>
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </dtd:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*[ancestor::doc:attributes]" mode="trim" priority="1000">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="trim"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:optional[parent::rng:interleave]" mode="trim"
	      priority="100">
  <!-- optional in interleave is redundant for DTD syntax -->
  <xsl:apply-templates mode="trim"/>
</xsl:template>

<xsl:template match="rng:optional" mode="trim">
  <!-- optional with multiple children needs a group? -->
  <xsl:copy>
    <xsl:copy-of select="@*"/>

    <xsl:choose>
      <xsl:when test="count(*) &gt; 1">
	<rng:group>
	  <xsl:apply-templates mode="trim"/>
	</rng:group>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="trim"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:choice[rng:ref[@name='db.titlereq.info']
        and rng:group[rng:optional[rng:ref[@name='db.titleforbidden.info']]]]"
	      mode="trim">
<!--
  Turn this: (((title|titleabbrev|subtitle)*,info?)|info)
  into this:   (title|titleabbrev|subtitle)*,info?)
-->
  <xsl:apply-templates select="rng:group" mode="trim"/>
</xsl:template>

<xsl:template match="rng:choice[rng:optional[rng:ref[@name='db.info']]
        and rng:group[rng:optional[rng:ref[@name='db.titleforbidden.info']]]]"
	      mode="trim">
<!--
  Turn this: (((title|titleabbrev|subtitle)*,info?)|info?)
  into this:   (title|titleabbrev|subtitle)*,info?)
-->
  <xsl:apply-templates select="rng:group" mode="trim"/>
</xsl:template>

<!-- xxx -->

<!-- fix step content model for UPA -->
<!--
<xsl:template match="doc:content-model[ancestor::rng:define[@name='db.step']]"
	      mode="trim">
  <xsl:copy>
    <rng:group>
      <xsl:apply-templates select="rng:group[1]/rng:choice[1]" mode="trim"/>
      <rng:zeroOrMore>
	<xsl:copy-of select="rng:group[1]/rng:zeroOrMore[1]/node()"/>
	<rng:ref name="db.substeps"/>
	<rng:ref name="db.stepalternatives"/>
      </rng:zeroOrMore>
    </rng:group>
  </xsl:copy>
</xsl:template>
-->

<xsl:template match="rng:ref[@name='db.segmentedlist'
                             and parent::rng:zeroOrMore
			     and ancestor::rng:define[starts-with(@name,'db.index')]]"
	      mode="trim">
  <!-- remove it to avoid UPA -->
</xsl:template>

<xsl:template
    match="rng:choice[rng:group[rng:interleave[rng:ref[@name='db.title']]]
	          and rng:group[rng:optional[rng:ref[contains(@name,'.info')]]]
		  and rng:ref[contains(@name,'.info')]]"
    priority="100"
    mode="trim">
<!--
  Turn this: (((title|titleabbrev)*,info?)|info?)
  into this:   (title|titleabbrev)*,info?)
-->
  <xsl:apply-templates select="rng:group" mode="trim"/>
</xsl:template>

<xsl:template
    match="rng:choice[rng:group[rng:interleave[rng:optional[rng:ref[@name='db.title']]]]
	          and rng:group[rng:optional[rng:ref[contains(@name,'.info')]]]
		  and rng:ref[contains(@name,'.info')]]"
    priority="100"
    mode="trim">
<!--
  Turn this: (((title|titleabbrev)*,info?)|info?)
  into this:   (title|titleabbrev)*,info?)
-->
  <xsl:apply-templates select="rng:group" mode="trim"/>
</xsl:template>

<xsl:template
    match="rng:choice[rng:group[rng:ref[@name='db.title']]
	          and rng:group[rng:optional[rng:ref[contains(@name,'.info')]]]
		  and rng:ref[contains(@name,'.info')]]"
    mode="trim">
<!--
  Turn this: (((title|titleabbrev)*,info?)|info?)
  into this:   (title|titleabbrev)*,info?)
-->
  <xsl:apply-templates select="rng:group" mode="trim"/>
</xsl:template>


<xsl:template match="rng:define" mode="trim">
  <!--xsl:message>Trimming <xsl:value-of select="@name"/></xsl:message-->
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="trim"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*" mode="trim">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="trim"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="trim">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
