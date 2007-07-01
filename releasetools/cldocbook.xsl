<?xml version="1.0"?>
<!-- * -->
<!-- * This is a static copy of the cldocbook.xsl file from the litprog module. -->
<!-- * It *MAY NOT BE UP TO DATE*. It is provided for the convenience of -->
<!-- * developers who don't want to generate the file themselves from -->
<!-- * the sources in the ../litprog directory. To create a fresh up-to-date -->
<!-- * copy of the file, check out that directory from the source repository -->
<!-- * and build it. -->
<!-- * -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" xmlns:verb="com.nwalsh.saxon.Verbatim" exclude-result-prefixes="verb src" version="1.0">
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>

    

  <xsl:template match="revhistory" mode="titlepage.mode"/>

  <xsl:param name="section.autolabel" select="1"/>
<xsl:param name="linenumbering.everyNth" select="5"/>
<xsl:param name="linenumbering.separator" select="'| '"/>
  <xsl:param name="local.l10n.xml" select="document('')"/>

<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
   <l:context name="title">
      <l:template name="fragment" text="%t"/>
    </l:context>
  </l:l10n>
</l:i18n>
  <xsl:template match="src:fragment">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:param name="linenumbering" select="'numbered'"/>

  <xsl:variable name="section" select="ancestor::section[1]"/>
  <xsl:variable name="id" select="@id"/>
  <xsl:variable name="referents" select="//src:fragment[.//src:fragref[@linkend=$id]]"/>

  <div class="src-fragment">
  <a name="{@id}"/>
  <table border="1" width="100%">
    <tr>
      <td>
        <p>
          <b>
            <xsl:apply-templates select="." mode="label.markup"/>
          </b>
          <xsl:if test="$referents">
            <xsl:text>: </xsl:text>
            <xsl:for-each select="$referents">
              <xsl:if test="position() &gt; 1">, </xsl:if>
              <a>
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="."/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="label.markup"/>
              </a>
            </xsl:for-each>
          </xsl:if>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="$suppress-numbers = '0'                           and $linenumbering = 'numbered'                           and $use.extensions != '0'                           and $linenumbering.extension != '0'">
            <xsl:variable name="rtf">
              <xsl:apply-templates/>
            </xsl:variable>
            <pre class="{name(.)}">
              <xsl:copy-of select="verb:numberLines($rtf)"/>
            </pre>
          </xsl:when>
          <xsl:otherwise>
            <pre class="{name(.)}">
              <xsl:apply-templates/>
            </pre>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </table>
  </div>
</xsl:template>

<xsl:template match="src:fragment" mode="label.markup">
  <xsl:variable name="section" select="ancestor::section[1]"/>

  <xsl:text>§</xsl:text>

  <xsl:choose>
    <xsl:when test="$section">
      <xsl:variable name="section.label">
        <xsl:apply-templates select="$section" mode="label.markup"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string($section.label) = ''">
          <xsl:number from="section"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$section.label"/>
          <xsl:text>.</xsl:text>
          <xsl:number from="section"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number from="/"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="src:fragment" mode="title.markup">
  <xsl:variable name="section" select="ancestor::section[1]"/>

  <xsl:if test="$section">
    <xsl:apply-templates select="$section" mode="title.markup"/>
  </xsl:if>
</xsl:template>
  <xsl:template match="src:fragref">
  <xsl:call-template name="xref"/>
</xsl:template>
<xsl:template match="src:fragment" mode="xref-to">
  <xsl:variable name="section" select="ancestor::section[1]"/>

  <i>
    <xsl:apply-templates select="." mode="label.markup"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates select="." mode="title.markup"/>
  </i>
</xsl:template>
</xsl:stylesheet>
