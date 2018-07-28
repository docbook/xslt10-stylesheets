<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:i="urn:cz-kosek:functions:index"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:func="http://exslt.org/functions"
                xmlns:k="http://www.isogen.com/functions/com.isogen.saxoni18n.Saxoni18nService"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="func exslt"
                exclude-result-prefixes="func exslt i l k d"
                version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- The "kosek" method contributed by Jirka Kosek. -->

<xsl:include href="../common/autoidx-kosek.xsl"/>

<xsl:template name="generate-kosek-index">
  <xsl:param name="scope" select="(ancestor::d:book|/)[last()]"/>

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
                select="//d:indexterm[count(.|key('group-code', i:group-index(&primary;))[&scope;][1]) = 1 and not(@class = 'endofrange')]"/>

  <div class="index">
    <xsl:apply-templates select="$terms" mode="index-div-kosek">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="i:group-index(&primary;)" data-type="number"/>
    </xsl:apply-templates>
  </div>
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

  <xsl:if test="key('group-code', $key)[&scope;][count(.|key('primary', &primary;)[&scope;][1]) = 1]">
    <div class="indexdiv">
      <h3>
        <xsl:value-of select="i:group-letter($key)"/>
      </h3>
      <dl>
        <xsl:apply-templates select="key('group-code', $key)[&scope;][count(.|key('primary', &primary;)[&scope;][1])=1]"
                             mode="index-primary">
          <xsl:sort select="i:term-index(&primary;)" lang="{$lang}"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </dl>
    </div>
  </xsl:if>
</xsl:template>

  <xsl:template match="d:indexterm" mode="index-primary">
    <xsl:param name="scope" select="."/>
    <xsl:param name="role" select="''"/>
    <xsl:param name="type" select="''"/>
    
    <xsl:variable name="key" select="&primary;"/>
    <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>
    <dt>
      <xsl:if test="$autolink.index.see != 0">
        <!-- add internal id attribute to form see and seealso links -->
        <xsl:attribute name="id">
          <xsl:value-of select="concat('ientry-', generate-id())"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="$refs/d:primary">
        <xsl:if test="@id or @xml:id">
          <xsl:choose>
            <xsl:when test="$generate.id.attributes = 0">
              <a name="{(@id|@xml:id)[1]}"/>
            </xsl:when>
            <xsl:otherwise>
              <span>
                <xsl:call-template name="id.attribute"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="d:primary"/>
      <xsl:choose>
        <xsl:when test="$index.links.to.section = 1">
          <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('primary-section', concat($key, &sep;, &section.id;))[&scope;][1])]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$refs[not(d:see)
            and not(d:secondary)][&scope;]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="$refs[not(d:secondary)]/*[self::d:see]">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[&scope;][1])]"
          mode="index-see">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="i:term-index(d:see)"/>
        </xsl:apply-templates>
      </xsl:if>
    </dt>
    <xsl:choose>
      <xsl:when test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:seealso]">
        <dd>
          <dl>
            <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[&scope;][1])]"
              mode="index-seealso">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:sort select="i:term-index(d:seealso)"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$refs[d:secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[&scope;][1]) = 1]"
              mode="index-secondary">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:sort select="i:term-index(&secondary;)"/>
            </xsl:apply-templates>
          </dl>
        </dd>
      </xsl:when>
      <!-- HTML5 requires dd for each dt -->
      <xsl:when test="$div.element = 'section'">
        <dd></dd>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="d:indexterm" mode="index-secondary">
    <xsl:param name="scope" select="."/>
    <xsl:param name="role" select="''"/>
    <xsl:param name="type" select="''"/>
    
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
    <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>
    <dt>
      <xsl:for-each select="$refs/d:secondary">
        <xsl:if test="@id or @xml:id">
          <xsl:choose>
            <xsl:when test="$generate.id.attributes = 0">
              <a name="{(@id|@xml:id)[1]}"/>
            </xsl:when>
            <xsl:otherwise>
              <span>
                <xsl:call-template name="id.attribute"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="d:secondary"/>
      <xsl:choose>
        <xsl:when test="$index.links.to.section = 1">
          <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('secondary-section', concat($key, &sep;, &section.id;))[&scope;][1])]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$refs[not(d:see)
            and not(d:tertiary)][&scope;]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="$refs[not(d:tertiary)]/*[self::d:see]">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[&scope;][1])]"
          mode="index-see">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="i:term-index(d:see)"/>
        </xsl:apply-templates>
      </xsl:if>
    </dt>
    <xsl:choose>
      <xsl:when test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:seealso]">
        <dd>
          <dl>
            <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[&scope;][1])]"
              mode="index-seealso">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:sort select="i:term-index(d:seealso)"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$refs[d:tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[&scope;][1]) = 1]"
              mode="index-tertiary">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:sort select="i:term-index(&tertiary;)"/>
            </xsl:apply-templates>
          </dl>
        </dd>
      </xsl:when>
      <!-- HTML5 requires dd for each dt -->
      <xsl:when test="$div.element = 'section'">
        <dd></dd>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="d:indexterm" mode="index-tertiary">
    <xsl:param name="scope" select="."/>
    <xsl:param name="role" select="''"/>
    <xsl:param name="type" select="''"/>
    
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
    <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>
    <dt>
      <xsl:for-each select="$refs/d:tertiary">
        <xsl:if test="@id or @xml:id">
          <xsl:choose>
            <xsl:when test="$generate.id.attributes = 0">
              <a name="{(@id|@xml:id)[1]}"/>
            </xsl:when>
            <xsl:otherwise>
              <span>
                <xsl:call-template name="id.attribute"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="d:tertiary"/>
      <xsl:choose>
        <xsl:when test="$index.links.to.section = 1">
          <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('tertiary-section', concat($key, &sep;, &section.id;))[&scope;][1])]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$refs[not(d:see)][&scope;]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="$refs/d:see">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[&scope;][1])]"
          mode="index-see">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="i:term-index(d:see)"/>
        </xsl:apply-templates>
      </xsl:if>
    </dt>
    <xsl:choose>
      <xsl:when test="$refs/d:seealso">
        <dd>
          <dl>
            <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[&scope;][1])]"
              mode="index-seealso">
              <xsl:with-param name="position" select="position()"/>
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:sort select="i:term-index(d:seealso)"/>
            </xsl:apply-templates>
          </dl>
        </dd>
      </xsl:when>
      <!-- HTML5 requires dd for each dt -->
      <xsl:when test="$div.element = 'section'">
        <dd></dd>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="d:indexterm" mode="index-seealso">
    <xsl:param name="scope" select="."/>
    <xsl:param name="role" select="''"/>
    <xsl:param name="type" select="''"/>
    
    <xsl:for-each select="seealso">
      <xsl:sort select="i:term-index(.)"/>
      
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
          <xsl:value-of select="concat('#ientry-', generate-id($seealsotarget))"/>
        </xsl:if>
      </xsl:variable>
      
      <dt>
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
            <a href="{$linkend}">
              <xsl:value-of select="$seealso"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$seealso"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
      </dt>
      
      <xsl:if test="$div.element = 'section'">
        <dd></dd>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
