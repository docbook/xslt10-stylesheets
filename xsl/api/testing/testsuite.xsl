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
  <xsl:template match="d:testsuite">
    <section>
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="../@id">
          <xsl:attribute name="id">
            <xsl:value-of select="concat(../@id, '.tests')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <title>Testsuite</title>

      <xsl:if test="d:compile-test|d:link-test|d:run-test">
        <section>
          <xsl:if test="@id">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
              <xsl:text>.acceptance</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <title>Acceptance tests</title>
          <informaltable>
            <tgroup cols="3">
              <colspec colnum="2" colwidth="1in"/>
              <thead>
                <row>
                  <entry>Test</entry>
                  <entry>Type</entry>
                  <entry>Description</entry>
                  <entry>If failing...</entry>
                </row>
              </thead>
              <tbody>
                <xsl:apply-templates select="d:compile-test|d:link-test|d:run-test"/>
              </tbody>
            </tgroup>
          </informaltable>
        </section>          
      </xsl:if>
      
      <xsl:if test="d:compile-fail-test|d:link-fail-test|d:run-fail-test">
        <section>
          <xsl:if test="@id">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
              <xsl:text>.negative</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <title>Negative tests</title>
          <informaltable>
            <tgroup cols="3">
              <colspec colnum="2" colwidth="1in"/>
              <thead>
                <row>
                  <entry>Test</entry>
                  <entry>Type</entry>
                  <entry>Description</entry>
                  <entry>If failing...</entry>
                </row>
              </thead>
              <tbody>
                <xsl:apply-templates 
                  select="d:compile-fail-test|d:link-fail-test|d:run-fail-test"/>
              </tbody>
            </tgroup>
          </informaltable>
        </section>
      </xsl:if> 
    </section>
  </xsl:template>

  <xsl:template match="d:compile-test|d:link-test|d:run-test|
                       d:compile-fail-test|d:link-fail-test|d:run-fail-test">
    <row>
      <entry>
        <simpara>
          <ulink>
            <xsl:attribute name="url">
              <xsl:value-of 
                select="concat('../../libs/',
                               ancestor::d:library/attribute::d:dirname, '/test/',
                               @filename)"/>
            </xsl:attribute>
            <xsl:value-of select="@filename"/>
          </ulink>
        </simpara>
      </entry>
      <entry>
        <simpara>
          <xsl:value-of select="substring-before(local-name(.), '-test')"/>
        </simpara>
      </entry>
      <entry><xsl:apply-templates select="d:purpose/*"/></entry>
      <entry><xsl:apply-templates select="if-fails/*"/></entry>
    </row>
  </xsl:template>

  <xsl:template match="d:snippet">
    <xsl:variable name="snippet-name" select="@name"/>
    <xsl:apply-templates select="//d:programlisting[@name=$snippet-name]"/>
  </xsl:template>
</xsl:stylesheet>
