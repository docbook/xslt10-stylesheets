<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:i="urn:cz-kosek:functions:index"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="func exslt"
                exclude-result-prefixes="func exslt i l d"
                version="1.0">

<!-- ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or https://cdn.docbook.org/release/xsl/ for copyright
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- The "kosek" method contributed by Jirka Kosek. -->

<xsl:include href="../common/autoidx-kosek.xsl"/>

<xsl:template name="generate-kosek-index">
  <xsl:param name="scope" select="NOTANODE"/>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:if test="contains($vendor, 'libxslt')">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method does not </xsl:text>
      <xsl:text>work with the xsltproc XSLT processor.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="contains($vendor, 'Saxonica')">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method does not </xsl:text>
      <xsl:text>work with the Saxon 8 XSLT processor.</xsl:text>
    </xsl:message>
  </xsl:if>


  <xsl:if test="$exsl.node.set.available = 0">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method requires the </xsl:text>
      <xsl:text>exslt:node-set() function. Use a processor that </xsl:text>
      <xsl:text>has it, or use a different index method.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="not(function-available('i:group-index'))">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method requires the&#xA;</xsl:text>
      <xsl:text>index extension functions be imported:&#xA;</xsl:text>
      <xsl:text>  xsl:import href="common/autoidx-kosek.xsl"</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="role">
    <xsl:if test="$index.on.role != 0">
      <xsl:value-of select="@role"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:if test="$index.on.type != 0">
      <xsl:value-of select="@type"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="terms"
                select="//d:indexterm[count(.|key('group-code',
                                          i:group-index(&primary;))
                                          [&scope;][1]) = 1
                                and not(@class = 'endofrange')]"/>
  <fo:block>
    <xsl:apply-templates select="$terms" mode="index-div-kosek">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="i:group-index(&primary;)" data-type="number"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-div-kosek">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key"
                select="i:group-index(&primary;)"/>

  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:variable>

  <xsl:if test="key('group-code', $key)[&scope;]
                [count(.|key('primary', &primary;)[&scope;][1]) = 1]">
    <fo:block>
      <xsl:call-template name="indexdiv.title">
        <xsl:with-param name="titlecontent">
          <xsl:choose>
            <xsl:when test="$key = 0">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'index symbols'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="i:group-letter($key)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
      <fo:block>
        <xsl:apply-templates select="key('group-code', $key)[&scope;]
                                     [count(.|key('primary', &primary;)
                                     [&scope;][1])=1]"
                             mode="index-primary-kosek">
          <xsl:sort select="i:term-index(&primary;)" lang="{$lang}"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </fo:block>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-primary-kosek">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$autolink.index.see != 0">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('ientry-', generate-id())"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:primary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:primary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see) and not(d:secondary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see) and not(d:secondary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties"
                ref-key="{$primary.significant}"/>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see) and not(d:secondary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties"
                ref-key="{$primary}"/>
            </xsl:if>
          </rx:page-index>        
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)
                                and not(d:secondary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:secondary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="i:term-index(d:see)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:seealso]">
    <fo:block start-indent="1pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso-kosek">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="i:term-index(d:seealso)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[d:secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[&scope;][1]) = 1]"
                           mode="index-secondary-kosek">
       <xsl:with-param name="scope" select="$scope"/>
       <xsl:with-param name="role" select="$role"/>
       <xsl:with-param name="type" select="$type"/>
       <xsl:sort select="i:term-index(&secondary;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-secondary-kosek">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:secondary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:secondary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see) and not(d:tertiary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see) and not(d:tertiary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see) and not(d:tertiary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)
                                and not(d:tertiary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:tertiary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="i:index-term(d:see)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:seealso]">
    <fo:block start-indent="2pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso-kosek">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="i:index-term(d:seealso)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[d:tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[&scope;][1]) = 1]"
                           mode="index-tertiary-kosek">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="i:index-term(&tertiary;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-tertiary-kosek">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:tertiary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:tertiary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="tertiary" select="&tertiary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs/d:see">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="i:term-index(d:see)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:seealso">
    <fo:block>
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso-kosek">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="i:term-index(d:seealso)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

  <xsl:template match="d:indexterm" mode="index-seealso-kosek">
    <xsl:param name="scope" select="."/>
    <xsl:param name="role" select="''"/>
    <xsl:param name="type" select="''"/>
    
    <xsl:for-each select="d:seealso">
      <xsl:sort select="translate(., &lowercase;, &uppercase;)"/>
      
      <xsl:variable name="seealso" select="normalize-space(.)"/>
      
      <!-- can only link to primary, which should appear before comma
    in seealso "primary, secondary" entry -->
      <xsl:variable name="seealsoprimary">
        <xsl:choose>
          <xsl:when test="contains($seealso, ',')">
            <xsl:value-of select="substring-before($seealso, ',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$seealso"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable> 
      
      <xsl:variable name="seealsotarget" select="key('primaryonly', $seealsoprimary)[1]"/>
      
      <xsl:variable name="linkend">
        <xsl:if test="$seealsotarget">
          <xsl:value-of select="concat('ientry-', generate-id($seealsotarget))"/>
        </xsl:if>
      </xsl:variable>
      
      <fo:block>
        <xsl:text>(</xsl:text>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'seealso'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <!-- manual links have precedence -->
          <xsl:when test="@linkend or @xlink:href">
            <xsl:call-template name="simple.xlink">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="content" select="$seealso"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$autolink.index.see = 0">
            <xsl:value-of select="$seealso"/>
          </xsl:when>
          <xsl:when test="$seealsotarget">
            <fo:basic-link internal-destination="{$linkend}"
              xsl:use-attribute-sets="xref.properties">
              <xsl:value-of select="$seealso"/>
            </fo:basic-link>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$seealso"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
      </fo:block>
      
    </xsl:for-each>
    
  </xsl:template>
  
  
</xsl:stylesheet>
