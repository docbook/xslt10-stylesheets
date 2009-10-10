<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:xslo="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="exsl"
                version="1.0">

<xsl:include href="../lib/lib.xsl"/>
<xsl:output method="xml"
  encoding="ASCII"
  saxon:character-representation="decimal"
  />
<xsl:preserve-space elements="*"/>
<xsl:namespace-alias stylesheet-prefix="xslo" result-prefix="xsl"/>

<xsl:template match="/">
  <xsl:comment>This file was created automatically by html2xhtml</xsl:comment>
  <xsl:comment>from the HTML stylesheets.</xsl:comment>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="xsl:stylesheet" >
  <xsl:variable name="a">
      <xsl:element name="dummy" namespace="http://www.w3.org/1999/xhtml"/>
  </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="exsl:node-set($a)//namespace::*"/>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
   </xsl:copy>

</xsl:template>

<!-- Make sure we override some templates and parameters appropriately for XHTML -->
<xsl:template match="xsl:output">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="method">xml</xsl:attribute>
    <xsl:attribute name="encoding">UTF-8</xsl:attribute>
    <xsl:attribute name="doctype-public">-//W3C//DTD XHTML 1.1//EN</xsl:attribute>

    <xsl:attribute name="doctype-system">http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:import">
  <xsl:copy>
    <xsl:attribute name="href">
      <xsl:call-template name="string.subst">
        <xsl:with-param name="string" select="@href"/>
        <xsl:with-param name="target">/html/</xsl:with-param>

        <xsl:with-param name="replacement">/xhtml-1_1/</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:call-template[@name='language.attribute']">
	<xsl:copy>
		<xsl:attribute name="name">xml.language.attribute</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='stylesheet.result.type']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xhtml'</xsl:attribute>

  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='make.valid.html']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">1</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='output.method']">

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.method']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>

  </xsl:copy>
</xsl:template>

<xsl:template match="td/xsl:attribute[@name='width']"/>

<xsl:template match="hr">
	<xsl:element name="hr" namespace="http://www.w3.org/1999/xhtml"/>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.encoding']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'UTF-8'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-public']">

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'-//W3C//DTD XHTML 1.1//EN'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-system']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='ulink.target']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:element name="xsl:text"><xsl:text></xsl:text></xsl:element>
	</xsl:copy>
</xsl:template>


<xsl:template match="xsl:param[@name='html.longdesc']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='css.decoration']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:variable[@name='use.viewport']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:attribute[@name='bgcolor']">
  <xsl:element name="xsl:attribute">
    <xsl:attribute name="name">style</xsl:attribute>
    <xsl:element name="xsl:text">background-color: </xsl:element>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="xsl:attribute[@name='align']">
  <xsl:element name="xsl:attribute">
    <xsl:attribute name="name">style</xsl:attribute>
    <xsl:element name="xsl:text">text-align: </xsl:element>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="xsl:attribute[@name='type']">
	<xsl:choose>
		<xsl:when test="ancestor::ol"/>
		<xsl:when test="ancestor::ul"/>
		<xsl:otherwise>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="xsl:attribute[@name='name']">
  <xsl:choose>
    <xsl:when test="ancestor::a">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name">id</xsl:attribute>
        <xsl:apply-templates/>

      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="xsl:element">
  <!-- make sure literal xsl:element declarations propagate the right namespace -->
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="namespace">http://www.w3.org/1999/xhtml</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Bare anchors (<a/>) are not allowed in <blockquote>s -->
<xsl:template match="xsl:template[@name='anchor']/xsl:if">
  <xslo:if>
    <xsl:attribute name="test">
      <xsl:text>not($node[parent::blockquote])</xsl:text>
    </xsl:attribute>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xslo:if>
</xsl:template>

<xsl:template match="xsl:template[@name='body.attributes']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> no apply-templates; make it empty </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:copy>
</xsl:template>

<!-- "The following HTML elements specify font information. 
      Although they are not all deprecated, their use is discouraged in 
      favor of style sheets." -->
<xsl:template match="b|i">
  <xsl:apply-templates/>
</xsl:template>  

<!-- this only occurs in docbook.xsl to identify errors -->
<xsl:template match="font">
  <span class="ERROR" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="a[@name]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>

    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'name'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="img[@border]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'border'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- Sadly, strict XHTML doesn't let us override list values (though we could figure out 
     with a more nuanced template than what is done below whether we could fix it with a 
     list-style @style instruction in CSS -->
<xsl:template match="li/xsl:if[@test = '@override']">
  <xsl:element name="xsl:if">
    <xsl:attribute name="test">@override</xsl:attribute>
    <xsl:element name="xsl:message">
      <xsl:element name="xsl:text">
        <xsl:text>@override attribute cannot be set in strict XHTML output for listitem: </xsl:text>
      </xsl:element>
      <xsl:element name="xsl:value-of">
        <xsl:attribute name="select">
          <xsl:text>@override</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>

<!-- again, forbidden by XHTML, but this one could just be a CSS choice (maybe line-height?) -->
<xsl:template match="ol/xsl:if[contains(@test, '@spacing=') and contains(@test, 'compact')]|
                     ul/xsl:if[contains(@test, '@spacing=') and contains(@test, 'compact')]">
  <xsl:element name="xsl:if">
    <xsl:attribute name="test">@spacing='compact'</xsl:attribute>
    <xsl:element name="xsl:message">
      <xsl:element name="xsl:text">
        <xsl:text>Compact spacing via @spacing attribute cannot be set in strict XHTML output for listitem: </xsl:text>
      </xsl:element>
      <xsl:element name="xsl:value-of">
        <xsl:attribute name="select">
          <xsl:text>@spacing</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>

<!-- @start forbidden in XHTML -->
<xsl:template match='ol/xsl:if[contains(@test, "$start") and contains(@test, "!= &apos;1&apos;")]'>
  <xsl:element name="xsl:if">
    <xsl:attribute name="test">$start != '1'</xsl:attribute>
    <xsl:element name="xsl:message">
      <xsl:element name="xsl:text">
        <xsl:text>Strict XHTML does not allow setting @start attribute for lists! </xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="td[@width]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'width'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- support for CSS selection of valid XHTML ol @style attributes for substeps-->
<xsl:template match="xsl:template[@match='substeps']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">numeration</xsl:attribute>
      <xsl:element name="xsl:call-template">
        <xsl:attribute name="name">procedure.step.numeration</xsl:attribute>
      </xsl:element>
    </xsl:element>
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">cssstyle</xsl:attribute>
      <xsl:element name="xsl:choose">
        <xsl:element name="xsl:when">
          <xsl:attribute name="test">$numeration = '1'</xsl:attribute>
          <xsl:text>decimal</xsl:text>
        </xsl:element>
        <xsl:element name="xsl:when">
          <xsl:attribute name="test">$numeration = 'a'</xsl:attribute>
          <xsl:text>lower-alpha</xsl:text>
        </xsl:element>
        <xsl:element name="xsl:when">
          <xsl:attribute name="test">$numeration = 'i'</xsl:attribute>
          <xsl:text>lower-roman</xsl:text>
        </xsl:element>
        <xsl:element name="xsl:when">
          <xsl:attribute name="test">$numeration = 'A'</xsl:attribute>
          <xsl:text>upper-alpha</xsl:text>
        </xsl:element>
        <xsl:element name="xsl:when">
          <xsl:attribute name="test">$numeration = 'I'</xsl:attribute>
          <xsl:text>upper-roman</xsl:text>
        </xsl:element>
        <xsl:element name="xsl:otherwise">
          <xsl:element name="xsl:message">
            <xsl:text>Warning: unknown procedure.step.numeration value: </xsl:text>
            <xsl:element name="xsl:value-of">
              <xsl:attribute name="select">$numeration</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>

    <xsl:element name="xsl:call-template">
      <xsl:attribute name="name">anchor</xsl:attribute>
    </xsl:element>
    <xsl:element name="ol" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="xsl:attribute">
        <xsl:attribute name="name">style</xsl:attribute>
        <xsl:element name="xsl:text">
          <xsl:text>list-style-type: </xsl:text>
        </xsl:element>
        <xsl:element name="xsl:value-of">
          <xsl:attribute name="select">$cssstyle</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="xsl:apply-templates"/>
    </xsl:element>
  </xsl:copy>
</xsl:template>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
