<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <!-- This stylesheet does a fair bit of work.

       1. It merges modules passed as a parameter into the primary grammar
       2. It expands several elements in the ctrl: namespace
       3. It augments the grammar with some standard constructs:
          a. Every element gets a role attribute
          b. Every element gets some common attributes (absent ctrl:*)
          c. The attribute list is added to the element definition

       The resulting grammar is ready for use by a validator. -->

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>
  <xsl:key name="choice-lists" match="ctrl:choice-list" use="@name"/>

  <xsl:param name="modules" select="''"/>

  <xsl:template match="/">
    <xsl:variable name="merged">
      <xsl:apply-templates select="/" mode="include"/>
    </xsl:variable>

    <xsl:variable name="expanded">
      <xsl:apply-templates select="exsl:node-set($merged)/rng:grammar" mode="expand"/>
    </xsl:variable>

    <xsl:message>Augmenting grammar</xsl:message>
    <xsl:apply-templates select="exsl:node-set($expanded)/rng:grammar"/>
  </xsl:template>

  <xsl:template match="rng:grammar" priority="2">
    <grammar xmlns="http://relaxng.org/ns/structure/1.0"
             datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="*">
        <xsl:choose>
          <xsl:when test="self::rng:define and rng:element[@name]">
            <xsl:variable name="basename">
              <xsl:choose>
                <xsl:when test="starts-with(@name, 'db.')">
                  <xsl:value-of select="substring-after(@name, 'db.')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@name"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <rng:define name="{$basename}.role.attrib">
              <rng:optional>
                <rng:attribute name="role"/>
              </rng:optional>
            </rng:define>

            <rng:define name="local.{$basename}.attrib">
              <rng:optional>
                <rng:notAllowed/>
              </rng:optional>
            </rng:define>

            <rng:define name="{$basename}.attlist">
              <xsl:variable name="ctrl:common-attributes"
                            select="//ctrl:common-attributes[@element=$basename][1]"/>
              <xsl:variable name="ctrl:common-linking"
                            select="//ctrl:common-linking[@element=$basename][1]"/>

              <xsl:choose>
                <xsl:when test="$ctrl:common-attributes/@suppress">
                  <!-- nop -->
                </xsl:when>
                <xsl:when test="$ctrl:common-attributes">
                  <rng:ref name="{$ctrl:common-attributes/@attributes}"/>
                </xsl:when>
                <xsl:otherwise>
                  <rng:ref name="common.attributes"/>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:choose>
                <xsl:when test="$ctrl:common-linking/@suppress">
                  <!-- nop -->
                </xsl:when>
                <xsl:when test="$ctrl:common-linking">
                  <rng:ref name="{$ctrl:common-linking/@attributes}"/>
                </xsl:when>
                <xsl:when test="key('defs',concat($basename,'.linkend.attrib'))
                                or key('defs',concat($basename,'.linkends.attrib'))">
                  <!-- no common linking attributes -->
                </xsl:when>
                <xsl:otherwise>
                  <rng:ref name="common.linking.attributes"/>
                </xsl:otherwise>
              </xsl:choose>

              <rng:ref name="{$basename}.role.attrib"/>

              <xsl:for-each select="/rng:grammar/rng:define[not(@combine)]">
                <xsl:if test="string-length(@name) &gt; 7
                              and starts-with(@name,concat($basename,'.'))
                              and substring(@name, string-length(@name)-6) = '.attrib'">
                  <rng:ref name="{@name}"/>
                </xsl:if>
              </xsl:for-each>

              <rng:ref name="local.{$basename}.attrib"/>
            </rng:define>

            <xsl:apply-templates select="."/>
          </xsl:when>

          <xsl:when test="self::ctrl:common-linking|self::ctrl:common-attributes">
            <!-- suppress -->
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </grammar>
  </xsl:template>

  <xsl:template match="rng:element[@name]" priority="2">
    <xsl:variable name="basename">
      <xsl:choose>
        <xsl:when test="starts-with(parent::rng:define/@name, 'db.')">
          <xsl:value-of select="substring-after(parent::rng:define/@name, 'db.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="parent::rng:define/@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <rng:ref name="{$basename}.attlist"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Merge grammars -->

  <xsl:template match="/" mode="include">
    <xsl:apply-templates mode="include"/>
  </xsl:template>

  <xsl:template match="rng:grammar" priority="2" mode="include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="include"/>

      <xsl:if test="$modules != ''">
        <xsl:call-template name="merge-grammars">
          <xsl:with-param name="modules" select="$modules"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="include"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="include">
    <xsl:copy/>
  </xsl:template>

  <xsl:template name="merge-grammars">
    <xsl:param name="modules" select="''"/>

    <xsl:variable name="module">
      <xsl:choose>
        <xsl:when test="contains($modules, ' ')">
          <xsl:value-of select="substring-before($modules, ' ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$modules"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:message>Loading module: <xsl:value-of select="$module"/></xsl:message>

    <xsl:variable name="grammar" select="document($module, .)"/>
    <xsl:apply-templates select="$grammar/rng:grammar/node()" mode="include"/>

    <xsl:if test="contains($modules, ' ')">
      <xsl:call-template name="merge-grammars">
        <xsl:with-param name="modules" select="substring-after($modules, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Expand ctrl: elements -->

  <xsl:template match="/" mode="expand">
    <xsl:apply-templates mode="expand"/>
  </xsl:template>

  <xsl:template match="ctrl:other-attribute" priority="2" mode="expand">
    <xsl:message>Expanding other attribute: <xsl:value-of select="@name"/></xsl:message>

    <rng:define name="{@name}.enum{@attribute-name}.attribute">
      <rng:optional>
        <rng:attribute name="{@attribute-name}">
          <rng:choice>
            <xsl:call-template name="values">
              <xsl:with-param name="string"
                              select="normalize-space(@attribute-values)"/>
            </xsl:call-template>
          </rng:choice>
        </rng:attribute>
      </rng:optional>
    </rng:define>

    <rng:define name="{@name}.other{@attribute-name}.attributes">
      <rng:attribute name="{@attribute-name}">
        <rng:value>
          <xsl:value-of select="@other-attribute-value"/>
        </rng:value>
      </rng:attribute>
      <rng:attribute name="{@other-attribute-name}">
        <rng:text/>
      </rng:attribute>
    </rng:define>

    <rng:define name="{@name}.{@attribute-name}.attrib">
      <rng:choice>
        <rng:ref name="{@name}.enum{@attribute-name}.attribute"/>
        <rng:ref name="{@name}.other{@attribute-name}.attributes"/>
      </rng:choice>
    </rng:define>
  </xsl:template>

  <xsl:template match="ctrl:choice-list" priority="2" mode="expand">
    <xsl:variable name="name" select="@name"/>
    <xsl:if test="not(preceding::ctrl:choice-list[@name=$name])">
      <xsl:message>Expanding choice list: <xsl:value-of select="@name"/></xsl:message>
      <rng:define name="{$name}">
        <rng:choice>
          <xsl:for-each select="key('choice-lists', $name)">
            <xsl:choose>
              <xsl:when test="@choose = '#notAllowed'">
                <rng:notAllowed/>
              </xsl:when>
              <xsl:otherwise>
                <rng:ref name="{@choose}"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </rng:choice>
      </rng:define>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="expand">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="expand"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="expand">
    <xsl:copy/>
  </xsl:template>

  <xsl:template name="values">
    <xsl:param name="string" select="''"/>

    <xsl:choose>
      <xsl:when test="contains($string, ' ')">
        <rng:value>
          <xsl:value-of select="substring-before($string, ' ')"/>
        </rng:value>
        <xsl:call-template name="values">
          <xsl:with-param name="string" select="substring-after($string, ' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <rng:value>
          <xsl:value-of select="$string"/>
        </rng:value>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
