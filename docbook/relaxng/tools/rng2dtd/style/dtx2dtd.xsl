<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:dtx="http://nwalsh.com/ns/dtd-xml"
                xmlns:f="http://nwalsh.com/functions/dtd-xml"
                xmlns="http://nwalsh.com/ns/dtd-xml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="s a dtx xs f"
                version="2.0">

<!-- If the contents of an attdecl is a ref, inline the referenced content -->

<xsl:param name="ns" select="'http://docbook.org/ns/docbook'"/>

<xsl:output method="text" encoding="utf-8"/>

<xsl:key name="name" match="dtx:pe|dtx:element" use="@name"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:variable name="prefix-list" as="xs:string*">
    <xsl:for-each select="//dtx:element[contains(@gi,':')]">
      <xsl:value-of select="substring-before(@gi, ':')"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="prefixes" select="distinct-values($prefix-list)"/>

  <xsl:variable name="root" select="/*"/>

  <!-- This is silly, but we do it for XProc -->
  <dtd>
    <xsl:text>&lt;!ENTITY % db.xmlns.attrib&#10;&#9;"xmlns</xsl:text>
    <xsl:text>&#9;CDATA&#9;#FIXED '</xsl:text>
    <xsl:value-of select="$ns"/>
    <xsl:text>'"&#10;>&#10;</xsl:text>

    <xsl:text>&lt;!ENTITY % xlink.xmlns.attrib&#10;&#9;"xmlns:xlink</xsl:text>
    <xsl:text>&#9;CDATA&#9;#FIXED 'http://www.w3.org/1999/xlink'"&#10;>&#10;</xsl:text>

    <xsl:for-each select="$prefixes">
      <xsl:text>&lt;!ENTITY % </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>.prefix&#10;&#9;"</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"&#10;>&#10;</xsl:text>
      <xsl:text>&lt;!ENTITY % </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>.xmlns.attrib&#10;&#9;"xmlns:%</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>.prefix;&#9;CDATA&#9;#FIXED '</xsl:text>
      <xsl:value-of select="namespace-uri-for-prefix(., $root)"/>
      <xsl:text>'"&#10;>&#10;</xsl:text>
    </xsl:for-each>

    <!-- Now we need all the names... -->
    <xsl:for-each select="//dtx:element[contains(@gi,':')]">
      <xsl:text>&lt;!ENTITY % </xsl:text>
      <xsl:value-of select="translate(@gi, ':', '.')"/>
      <xsl:text>.name&#9;"%</xsl:text>
      <xsl:value-of select="substring-before(@gi, ':')"/>
      <xsl:text>.prefix;:</xsl:text>
      <xsl:value-of select="substring-after(@gi, ':')"/>
      <xsl:text>">&#10;</xsl:text>
    </xsl:for-each>

    <xsl:apply-templates/>
  </dtd>
</xsl:template>

<xsl:template match="dtx:dtd">
  <xsl:apply-templates select="dtx:pe">
    <xsl:sort select="@depth"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="*[not(self::dtx:pe)]"/>
</xsl:template>

<xsl:template match="dtx:pe">
  <xsl:text>  &lt;!ENTITY % </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>&#10;&#9;"</xsl:text>

  <xsl:choose>
    <xsl:when test="dtx:attref|dtx:attdecl">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="implicit-group"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>"&#10;&gt;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtx:element">
  <xsl:text>  &lt;!ATTLIST </xsl:text>

  <xsl:choose>
    <xsl:when test="contains(@gi, ':')">
      <xsl:text>%</xsl:text>
      <xsl:value-of select="translate(@gi, ':', '.')"/>
      <xsl:text>.name;</xsl:text>
      <xsl:text>&#10;&#9;</xsl:text>
      <xsl:text>%</xsl:text>
      <xsl:value-of select="substring-before(@gi, ':')"/>
      <xsl:text>.xmlns.attrib;&#10;&#9;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@gi"/>
      <xsl:text>&#10;&#9;</xsl:text>
      <xsl:text>%db.xmlns.attrib;&#10;&#9;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>%xlink.xmlns.attrib;&#10;&#9;</xsl:text>

  <xsl:apply-templates select="dtx:attref"/>

  <xsl:text>&#10;&gt;&#10;&#10;</xsl:text>

  <xsl:text>  &lt;!ELEMENT </xsl:text>

  <xsl:choose>
    <xsl:when test="contains(@gi, ':')">
      <xsl:text>%</xsl:text>
      <xsl:value-of select="translate(@gi, ':', '.')"/>
      <xsl:text>.name;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@gi"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;&#9;</xsl:text>

  <xsl:variable name="cm" select="*[not(self::dtx:attref)]"/>

  <xsl:choose>
    <xsl:when test="count($cm) = 1 and $cm[1]/self::dtx:text">
      <xsl:text>(#PCDATA)*</xsl:text>
    </xsl:when>
    <xsl:when test=".//dtx:text">
      <xsl:call-template name="mixed-content">
        <xsl:with-param name="cm" select="$cm"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="count($cm) &gt; 1">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="$cm">
        <xsl:if test="position() &gt; 1">, </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$cm"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#10;&gt;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtx:attdecl">
  <xsl:value-of select="@name"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:choose>
    <xsl:when test="not(*)">CDATA</xsl:when>
    <xsl:when test="dtx:data">
      <xsl:apply-templates select="dtx:data"/>
    </xsl:when>
    <xsl:when test="dtx:value">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="dtx:value">
        <xsl:if test="position()&gt;1">|</xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:when test="dtx:choice">
      <xsl:apply-templates select="."/>
    </xsl:when>
    <xsl:when test="dtx:ref">
      <xsl:text>%</xsl:text>
      <xsl:value-of select="dtx:ref/@name"/>
      <xsl:text>;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Unknown attribute type: <xsl:copy-of select="*"/></xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#9;</xsl:text>
  <xsl:choose>
    <xsl:when test="@optional = 'true' or @name = 'xlink:href'">
      <xsl:text>&#9;#IMPLIED</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#9;#REQUIRED</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#10;&#9;</xsl:text>
</xsl:template>

<xsl:template match="dtx:ref">
  <xsl:variable name="target" select="key('name', @name)"/>

  <xsl:choose>
    <xsl:when test="$target/self::dtx:pe">
      <xsl:choose>
        <xsl:when test="@optional = 'true'">
          <xsl:text>(%</xsl:text>
          <xsl:value-of select="@name"/>
          <xsl:text>;)?</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>%</xsl:text>
          <xsl:value-of select="@name"/>
          <xsl:text>;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$target/self::dtx:element">
      <xsl:choose>
        <xsl:when test="contains($target/@gi, ':')">
          <xsl:text>%</xsl:text>
          <xsl:value-of select="translate($target/@gi, ':', '.')"/>
          <xsl:text>.name;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$target/@gi"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@optional = 'true'">?</xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>dtx:ref points to neither pe nor element? </xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:attref">
  <xsl:text>%</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>;&#10;&#9;</xsl:text>
</xsl:template>

<xsl:template match="dtx:text">#PCDATA</xsl:template>

<xsl:template match="dtx:empty">EMPTY</xsl:template>

<xsl:template match="dtx:optional">
  <xsl:call-template name="implicit-group"/>
  <xsl:text>?</xsl:text>
</xsl:template>

<xsl:template match="dtx:value">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="dtx:data">
  <xsl:choose>
    <xsl:when test="@type='IDREF' or @type='IDREFS' or @type='ID'
                    or @type='ENTITY' or @type='NMTOKEN'">
      <xsl:value-of select="@type"/>
    </xsl:when>
    <xsl:when test="@type='anyURI' or @type='token'
                    or @type='decimal' or @type='integer'
                    or @type='positiveInteger'
                    or @type='nonNegativeInteger'
                    or @type='date' or @type='dateTime'
                    or @type='gYearMonth' or @type='gYear'">
      <xsl:text>CDATA</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>DATA: <xsl:copy-of select="."/></xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:choice|dtx:zeroOrMore|dtx:oneOrMore">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:if test="position() &gt; 1"> | </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
  <xsl:if test="self::dtx:zeroOrMore">*</xsl:if>
  <xsl:if test="self::dtx:oneOrMore">+</xsl:if>
</xsl:template>

<xsl:template match="dtx:group">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:if test="position() &gt; 1">, </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="*">
  <xsl:message>Unhandled: <xsl:value-of select="local-name(.)"/>
  </xsl:message>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

<xsl:template name="implicit-group">
  <xsl:choose>
    <xsl:when test="count(*) &gt; 1">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="*">
        <xsl:if test="position() &gt; 1">, </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="mixed-content">
  <xsl:param name="cm"/>

  <xsl:variable name="gis" as="xs:string*">
    <xsl:apply-templates select="$cm" mode="mixed"/>
  </xsl:variable>

  <xsl:text>(#PCDATA</xsl:text>
  <xsl:for-each select="distinct-values($gis)">
    <xsl:sort select="."/>
    <xsl:if test=". != '#PCDATA'">
      <xsl:text> | </xsl:text>

      <xsl:choose>
        <xsl:when test="contains(., ':')">
          <xsl:text>%</xsl:text>
          <xsl:value-of select="translate(., ':', '.')"/>
          <xsl:text>.name;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>)*</xsl:text>
</xsl:template>

<xsl:template match="dtx:text" mode="mixed">
  <xsl:text>#PCDATA</xsl:text>
</xsl:template>

<xsl:template match="dtx:ref" mode="mixed">
  <xsl:variable name="target" select="key('name', @name)"/>

  <xsl:choose>
    <xsl:when test="$target/self::dtx:element">
      <xsl:value-of select="$target/@gi"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$target/*" mode="mixed"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:choice|dtx:zeroOrMore|dtx:oneOrMore|dtx:optional"
              mode="mixed">
  <xsl:apply-templates mode="mixed"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="dtx:ref" mode="mixed-refs">
  <xsl:variable name="target" select="key('name', @name)"/>

  <xsl:choose>
    <xsl:when test="$target/self::dtx:element">
      <xsl:value-of select="$target/@gi"/>
    </xsl:when>
    <xsl:when test="$target/self::dtx:pe and f:ref-bottom($target)">
      <xsl:value-of select="@name"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$target/*" mode="mixed-refs"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtx:choice|dtx:zeroOrMore|dtx:oneOrMore|dtx:optional"
              mode="mixed-refs">
  <xsl:apply-templates mode="mixed-refs"/>
</xsl:template>

<xsl:template match="dtx:text"
              mode="mixed-refs"/>

<xsl:template match="*"
              mode="mixed-refs">
  <xsl:message>Not handled in mixed-refs mode: <xsl:value-of select="local-name(.)"/></xsl:message>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="mixed-refs"/>

<!-- ============================================================ -->

<xsl:function name="f:ref-bottom" as="xs:boolean">
  <xsl:param name="elem" as="element(dtx:pe)"/>

  <xsl:variable name="allatts" as="xs:string*">
    <xsl:for-each select="$elem//dtx:ref">
      <xsl:variable name="target" select="key('name',@name)"/>
      <xsl:choose>
        <xsl:when test="$target/self::dtx:element">YES</xsl:when>
        <xsl:when test="$target/self::dtx:pe">NO</xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Unexpected ref: </xsl:text>
            <xsl:value-of select="local-name($target)"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:value-of select="not($allatts = 'NO')"/>
</xsl:function>

<!-- ============================================================ -->

<xsl:template name="collapse-mixed">
  <xsl:param name="refs" as="xs:string*"/>
  <xsl:param name="elements" as="xs:string*" select="()"/>
  <xsl:param name="pes" as="xs:string*" select="()"/>

  <xsl:variable name="allelem" as="xs:string*">
    <xsl:for-each select="$elements"><xsl:value-of select="."/></xsl:for-each>
    <xsl:for-each select="$refs">
      <xsl:variable name="target" select="key('name', .)"/>
      <xsl:if test="$target/self::dtx:element">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

<!--
  <xsl:variable name="newelem" select="distinct-values($allelem)"/>

  <xsl:variable name="newpes" as="xs:string*">
    <xsl:for-each select="$refs">
      <xsl:if test="not(. = $newelem)">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:message>ELEM: <xsl:value-of select="$newelem"/></xsl:message>
  <xsl:message>PES: <xsl:value-of select="$newpes"/></xsl:message>
-->

  <xsl:value-of select="''"/>

</xsl:template>

</xsl:stylesheet>
