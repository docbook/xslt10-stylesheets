<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- This file contains named and "non element" templates that are called -->
<!-- by templates in the other manpages stylesheet files. -->

<!-- ==================================================================== -->

  <!-- replace Unicode entities in all text nodes -->
  <xsl:template match="text()">
    <xsl:call-template name="replace-entities">
      <xsl:with-param name="content">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- for anything that gets boldfaced -->
  <xsl:template mode="bold" match="*">
    <xsl:for-each select="child::node()">
      <xsl:text>\fB</xsl:text>
      <xsl:apply-templates select="."/>
      <xsl:text>\fR</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- for anything that gets italicized -->
  <xsl:template mode="italic" match="*">
    <xsl:for-each select="node()">
      <xsl:text>\fI</xsl:text>
      <xsl:apply-templates select="."/>
      <xsl:text>\fR</xsl:text>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="nested-section-title">
    <xsl:text>.sp
.it 1 an-trap
.nr an-no-space-flag 1
.nr an-break-flag 1
.br</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test="title">
            <xsl:value-of select="normalize-space(title[1])"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  


  <!-- jump through a few hoops to deal with mixed-content blocks, so that -->
  <!-- we don't end up munging verbatim environments or lists and so that we -->
  <!-- don't gobble up whitespace when we shouldn't -->
  <xsl:template name="mixed-block">
    <xsl:for-each select="node()">
      <xsl:choose>
        <xsl:when test="self::address|self::literallayout|self::programlisting|
                        self::screen|self::synopsis">
          <!-- Check to see if this node is a verbatim environment. -->
          <!-- If so, put a line break before it. -->
          
          <!-- Yes, address and synopsis are vertabim environments. -->
          
          <!-- The code here previously also treated informaltable as a -->
          <!-- verbatim, presumably to support some kludge; I removed it -->
          <xsl:text>&#10;</xsl:text>
          <xsl:apply-templates select="."/>
          <!-- we don't need an extra line break after verbatim environments
               <xsl:text> &#10;</xsl:text>
               -->
        </xsl:when>
        <xsl:when test="self::itemizedlist|self::orderedlist|
                        self::variablelist|self::simplelist[@type !='inline']">
          <!-- Check to see if this node is a list; if so, -->
          <!-- put a line break before it. -->
          <xsl:text>&#10;</xsl:text>
          <xsl:apply-templates select="."/>
          <!-- we don't need an extra line break after lists
               <xsl:text> &#10;</xsl:text>
               -->
        </xsl:when>
        <xsl:when test="self::text()">
          <!-- Check to see if this is a text node. -->
          
          <!-- If so, take any multiple whitespace at the beginning or end of -->
          <!-- it, and replace it with a space plus a linebreak. -->
          
          <!-- This hack results in some ugliness in the generated roff -->
          <!-- source. But it ensures the whitespace around text nodes in mixed -->
          <!-- content gets preserved; without the hack, that whitespace -->
          <!-- effectively gets gobbled. -->

          <!-- Note if the node is just space, we just pass it through -->
          <!-- without (re)adding a line break. -->
          
          <!-- There must be a better way to do with this...  -->
          <xsl:variable name="content">
            <xsl:apply-templates select="."/>
          </xsl:variable>
          <xsl:if
              test="starts-with(translate(.,'&#9;&#10;&#13; ','    '), ' ')
                    and preceding-sibling::node()[name(.)!='']
                    and normalize-space($content) != ''
                    ">
            <xsl:text> &#10;</xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space($content)"/>
          <xsl:if
              test="translate(substring(., string-length(.), 1),'&#x9;&#10;&#13; ','    ')  = ' '
                    and following-sibling::node()[name(.)!='']
                    ">
            <xsl:text> </xsl:text>
            <xsl:if test="normalize-space($content) != ''">
              <xsl:text>&#10;</xsl:text>
            </xsl:if>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- At this point, we know that this node is not a verbatim -->
          <!-- environment, list, or text node; so we can safely -->
          <!-- normailize-space() it. -->
          <xsl:variable name="content">
            <xsl:apply-templates select="."/>
          </xsl:variable>
          <xsl:value-of select="normalize-space($content)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- deal with Unicode entities -->
  <xsl:template name="replace-entities">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-hellip">
      <xsl:with-param name="content">
        <xsl:call-template name="replace-minus">
          <xsl:with-param name="content">
            <xsl:call-template name="replace-mdash">
              <xsl:with-param name="content">
                <xsl:call-template name="replace-ndash">
                  <xsl:with-param name="content">
                    <xsl:call-template name="replace-dash">
                      <xsl:with-param name="content">
                        <xsl:call-template name="replace-setmn">
                          <xsl:with-param name="content">
                            <xsl:call-template name="replace-period">
                              <xsl:with-param name="content">
                                <xsl:call-template name="replace-nbsp">
                                  <xsl:with-param name="content">
                                    <xsl:call-template name="replace-ldquo">
                                      <xsl:with-param name="content">
                                        <xsl:call-template name="replace-rdquo">
                                          <xsl:with-param name="content">
                                            <xsl:call-template name="replace-backslash">
                                              <xsl:with-param name="content" select="$content"/>
                                            </xsl:call-template>
                                          </xsl:with-param>
                                        </xsl:call-template>
                                      </xsl:with-param>
                                    </xsl:call-template>
                                  </xsl:with-param>
                                </xsl:call-template>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template match="dingbat.characters">
    <!-- now that I'm using the real serializer, all that dingbat malarky -->
    <!-- isn't necessary anymore... -->
    <xsl:param name="dingbat">bullet</xsl:param>
    <xsl:choose>
      <xsl:when test="$dingbat='bullet'">\(bu</xsl:when>
      <xsl:when test="$dingbat='copyright'">\(co</xsl:when>
      <xsl:when test="$dingbat='trademark'">\(tm</xsl:when>
      <xsl:when test="$dingbat='trade'">\(tm</xsl:when>
      <xsl:when test="$dingbat='registered'">\(rg</xsl:when>
      <xsl:when test="$dingbat='service'">(SM)</xsl:when>
      <xsl:when test="$dingbat='nbsp'">\~</xsl:when>
      <xsl:when test="$dingbat='ldquo'">\(lq</xsl:when>
      <xsl:when test="$dingbat='rdquo'">\(rq</xsl:when>
      <xsl:when test="$dingbat='lsquo'">`</xsl:when>
      <xsl:when test="$dingbat='rsquo'">'</xsl:when>
      <xsl:when test="$dingbat='em-dash'">\(em</xsl:when>
      <xsl:when test="$dingbat='mdash'">\(em</xsl:when>
      <xsl:when test="$dingbat='en-dash'">\(en</xsl:when>
      <xsl:when test="$dingbat='ndash'">\(en</xsl:when>
      <xsl:otherwise>
        <xsl:text>\(bu</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template name="replace-dash">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'-'"/>
      <xsl:with-param name="with" select="'\-'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-ndash">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8211;'"/>
      <xsl:with-param name="with" select="'-'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-mdash">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8212;'"/>
      <xsl:with-param name="with" select="'--'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-hellip">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8230;'"/>
      <xsl:with-param name="with" select="'...'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-setmn">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8726;'"/>
      <xsl:with-param name="with" select="'\\'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-minus">
    <xsl:param name="content" select="''"/>
    <xsl:value-of select="translate($content,'&#8722;','-')"/>
  </xsl:template>

  <xsl:template name="replace-nbsp">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#x00a0;'"/>
      <xsl:with-param name="with" select="'\~'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-ldquo">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8220;'"/>
      <xsl:with-param name="with" select="'\(lq'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-rdquo">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'&#8221;'"/>
      <xsl:with-param name="with" select="'\(rq'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="replace-backslash">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'\'"/>
      <xsl:with-param name="with" select="'\\'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- if a period character is output at the beginning of a line
       it will be interpreted as a groff macro, so prefix all periods
       with "\&", a zero-width space. -->
  <xsl:template name="replace-period">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="replace" select="'.'"/>
      <xsl:with-param name="with" select="'\&#38;.'"/>
    </xsl:call-template>
  </xsl:template>

<!-- ==================================================================== -->

  <!-- general string-replacement function -->
  <xsl:template name="replace-string">
    <xsl:param name="content" select="''"/>
    <xsl:param name="replace" select="''"/>
    <xsl:param name="with" select="''"/>
    <xsl:choose>
      <xsl:when test="not(contains($content,$replace))">
        <xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($content,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="content"
                          select="substring-after($content,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
