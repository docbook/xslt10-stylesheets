<?xml version="1.0" encoding="utf-8"?>
<!--
   Copyright (c) 2002 Douglas Gregor <doug.gregor -at- gmail.com>
  
   Distributed under the Boost Software License, Version 1.0.
   (See accompanying file LICENSE_1_0.txt or copy at
   http://www.boost.org/LICENSE_1_0.txt)
  -->
<xsl:stylesheet exclude-result-prefixes="d"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
version="1.0">
  <xsl:key name="library-categories" match="d:library" 
    use="d:libraryinfo/d:librarycategory/@name"/>

  <xsl:template match="d:librarylist">
    <itemizedlist spacing="compact">
      <xsl:apply-templates select="//d:library"
        mode="build-library-list">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </itemizedlist>
  </xsl:template>

  <xsl:template name="library.link">
    <xsl:param name="node" select="."/>
    <xsl:param name="name" select="$node/attribute::d:name"/>

    <xsl:choose>
      <xsl:when test="$node/attribute::html-only = 1">
        <xsl:variable name="url">
          <xsl:choose>
            <xsl:when test="$node/attribute::xlink:href">
              <xsl:value-of select="$node/attribute::xlink:href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($boost.root,
                                           '/libs/', 
                                           $node/attribute::d:dirname, 
                                           '/index.html')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <ulink>
          <xsl:attribute name="url">
            <xsl:value-of select="$url"/>
          </xsl:attribute>
          <xsl:value-of select="$name"/>
        </ulink>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="internal-link">
          <xsl:with-param name="to">
            <xsl:choose>
              <xsl:when test="$node/attribute::xml:id">
                <xsl:value-of select="$node/attribute::xml:id"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="generate.id">
                  <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>                 
          </xsl:with-param>
          <xsl:with-param name="text" select="$name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="d:library" mode="build-library-list">
    <listitem>
      <simpara>
        <xsl:call-template name="library.link"/>
        <xsl:text> - </xsl:text>
        <xsl:apply-templates select="d:libraryinfo/d:librarypurpose"
          mode="build-library-list"/>
      </simpara>
    </listitem>
  </xsl:template>

  <xsl:template match="d:librarypurpose" mode="build-library-list">
    <xsl:apply-templates/>
    <xsl:text>, from </xsl:text>
    <xsl:apply-templates select="../d:author" mode="display-author-list"/>
  </xsl:template>

  <xsl:template match="d:author" mode="display-author-list">
    <xsl:if test="(position() &gt; 1) and (count(../d:author) &gt; 2)">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="(position() = count(../d:author)) and (position() &gt; 1)">
      <xsl:if test="position() &lt; 3">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:text>and </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="d:firstname/text()"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="d:surname/text()"/>
    <xsl:if test="(position() = count(../d:author))">
      <xsl:text>.</xsl:text>      
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:librarycategorylist">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:librarycategorydef">
    <section>
      <title><xsl:apply-templates/></title>
      <xsl:variable name="name" select="@name"/>
      <itemizedlist spacing="compact">
        <xsl:apply-templates select="key('library-categories', $name)"
          mode="build-library-list">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </itemizedlist>
    </section>
  </xsl:template>

  <xsl:template match="d:libraryinfo">
    <chapterinfo>
      <xsl:apply-templates select="d:author|d:authorgroup/d:author|d:copyright|d:legalnotice"/>
    </chapterinfo>
  </xsl:template>

  <xsl:template match="d:librarypurpose|d:librarycategory"/>

</xsl:stylesheet>
