<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:import href="../../../xsl/html/chunker.xsl"/>

  <xsl:output method="text" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>

  <xsl:param name="chunker.output.method" select="'xml'"/>
  <xsl:param name="chunker.output.encoding" select="'utf-8'"/>
  <xsl:param name="chunker.output.indent" select="'yes'"/>

  <xsl:param name="src" select="''"/>

  <xsl:template match="/">
    <xsl:if test="$src = ''">
      <xsl:message terminate="yes">You must specify a src.</xsl:message>
    </xsl:if>

    <xsl:variable name="rnx-doc" select="document($src, .)"/>
    <xsl:variable name="grammar" select="exsl:node-set($rnx-doc)/rng:grammar"/>

    <xsl:apply-templates select="$grammar" mode="includes">
      <xsl:with-param name="rng"
                      select="concat(substring-before($src, '.rnx'),'.rng')"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="rng:grammar" priority="2">
    <xsl:param name="rng" select="''"/>

    <xsl:value-of select="$rng"/>
    <xsl:text>&#xA;</xsl:text>

    <xsl:variable name="grammar">
      <xsl:copy>
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
                <rng:empty/>
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
                                and substring(@name, string-length(@name)-6)
                                    = '.attrib'">
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
      </xsl:copy>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$rng != ''">
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename" select="$rng"/>
          <xsl:with-param name="content">
            <xsl:copy-of select="$grammar"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$grammar"/>
      </xsl:otherwise>
    </xsl:choose>
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

  <xsl:template match="rng:include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:attribute name="href">
        <xsl:value-of select="substring-before(@href, '.rnx')"/>
        <xsl:text>.rng</xsl:text>
      </xsl:attribute>

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
  <!-- Includes -->

  <xsl:template match="rng:grammar" mode="includes">
    <xsl:param name="rng" select="''"/>

    <xsl:apply-templates select=".">
      <xsl:with-param name="rng" select="$rng"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//rng:include" mode="includes"/>
  </xsl:template>

  <xsl:template match="rng:include" mode="includes">
    <xsl:variable name="rnx-doc" select="document(@href, .)"/>
    <xsl:variable name="grammar" select="exsl:node-set($rnx-doc)/rng:grammar"/>

    <xsl:apply-templates select="$grammar" mode="includes">
      <xsl:with-param name="rng"
                      select="concat(substring-before(@href, '.rnx'),'.rng')"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ====================================================================== -->

</xsl:stylesheet>
