<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:doc="http://nwalsh.com/xmlns/documentation"
                xmlns:db="http://nwalsh.com/xmlns/docbook-grammar-structure"
                version="1.1">

<xsl:output method="xml"/>

<xsl:preserve-space elements="*"/>

<xsl:key name="name" match="*" use="@name"/>
<xsl:key name="define" match="rng:define" use="@name"/>
<xsl:key name="ref" match="rng:ref" use="@name"/>

<xsl:param name="elements" select="'elements.xml'"/>
<xsl:param name="elements.doc" select="document($elements, /)"/>

<xsl:param name="remove.start" select="0"/>

<xsl:template match="/">
  <xsl:variable name="schema">
    <xsl:apply-templates select="/" mode="include"/>
  </xsl:variable>

  <xsl:call-template name="prune">
    <xsl:with-param name="grammar" select="$schema"/>
    <xsl:with-param name="pass" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="prune">
  <xsl:param name="grammar"/>
  <xsl:param name="pass"/>

  <xsl:message>Pruning, pass <xsl:value-of select="$pass"/></xsl:message>

  <xsl:variable name="pruned">
    <xsl:apply-templates select="$grammar/*" mode="prune"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$pruned//db:pruned">
      <!-- try again ... -->
      <xsl:variable name="cleaned">
        <xsl:apply-templates select="$pruned/*" mode="prunecleanup"/>
      </xsl:variable>

      <xsl:call-template name="prune">
        <xsl:with-param name="grammar" select="$cleaned"/>
        <xsl:with-param name="pass" select="$pass + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$pruned" mode="trim.start"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="include">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="include"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="include">
  <xsl:copy/>
</xsl:template>

<xsl:template match="rng:include" mode="include" priority="2">
  <xsl:variable name="schema" select="document(@href, .)"/>

  <xsl:message>Including <xsl:value-of select="@href"/>...</xsl:message>

  <xsl:apply-templates select="$schema/rng:grammar/node()" mode="include"/>
</xsl:template>

<xsl:template match="rng:div[rng:define/rng:element]" mode="include" priority="2">
  <xsl:variable name="in.subset">
    <xsl:apply-templates select="$elements.doc" mode="in.subset">
      <xsl:with-param name="name" select="@db:name"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$in.subset = 1">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="include"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Removing <xsl:value-of select="@db:name"/></xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="prune">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="prune"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="prune">
  <xsl:copy/>
</xsl:template>

<xsl:template match="rng:ref" mode="prune" priority="2">
  <xsl:choose>
    <xsl:when test="key('define', @name)">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="prune"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <db:pruned/>
      <xsl:message>Pruning ref to <xsl:value-of select="@name"/></xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:define" mode="prune" priority="2">
  <xsl:variable name="allowed">
    <xsl:choose>
      <xsl:when test="(rng:choice and count(*) = 1)
                      and (count(rng:choice/rng:ref) = count(rng:choice/*))">
        <!-- if the define consists of a choice and the choice has nothing but refs -->
        <xsl:call-template name="allowed">
          <xsl:with-param name="refs" select="rng:choice/rng:ref"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="key('ref', @name) and ($allowed > 0)">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="prune"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <db:pruned/>
      <xsl:choose>
        <xsl:when test="key('ref', @name)">
          <xsl:message>Pruning notallowed <xsl:value-of select="@name"/></xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>Pruning unreferenced <xsl:value-of select="@name"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:div|rng:optional|rng:zeroOrMore|rng:choice"
              mode="prune" priority="2">
  <xsl:choose>
    <xsl:when test="*">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="prune"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <db:pruned/>
      <xsl:message>
        <xsl:text>Pruning empty </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@db:name">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@db:name"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:oneOrMore" mode="prune" priority="2">
  <xsl:choose>
    <xsl:when test="*">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="prune"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <!-- If it's in a choice, and it's not alone, we can toss it because -->
      <!-- there may be other branches to choose. -->
      <xsl:if test="parent::rng:choice
                    and (preceding-sibling::* or following-sibling::*)">
        <db:pruned/>
        <xsl:message>
          <xsl:text>Pruning empty </xsl:text>
          <xsl:value-of select="name(.)"/>
          <xsl:if test="@db:name">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@db:name"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </xsl:message>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="allowed">
  <xsl:param name="refs"/>
  <xsl:for-each select="$refs">
    <xsl:choose>
      <xsl:when test="key('define', @name)/rng:notAllowed">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="prunecleanup">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="prunecleanup"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="prunecleanup">
  <xsl:copy/>
</xsl:template>

<xsl:template match="db:pruned" mode="prunecleanup" priority="2">
  <!-- throw it away -->
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="trim.start">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="trim.start"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="trim.start">
  <xsl:copy/>
</xsl:template>

<xsl:template match="rng:start" mode="trim.start" priority="2">
  <xsl:choose>
    <xsl:when test="$remove.start = 0">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="trim.start"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Removing start</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="/|*" mode="in.subset">
  <xsl:param name="name" select="'**no**'"/>
  <xsl:choose>
    <xsl:when test="key('name', $name)">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->


</xsl:stylesheet>
