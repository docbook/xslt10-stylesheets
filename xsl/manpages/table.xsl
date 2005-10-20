<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

  <!-- ==================================================================== -->

  <xsl:template match="table|informaltable">
    <!-- * We first process the table by applying templates to the whole -->
    <!-- * thing; because we don’t override any of the <row>, <entry>, -->
    <!-- * <tr>, <td>, etc. templates, the templates in the HTML -->
    <!-- * stylesheets (which we import) are used to process those; but -->
    <!-- * for the element child content of <entry> and <td>, the -->
    <!-- * templates in the manpages stylesheet get applied; so the result -->
    <!-- * is a table marked up in HTML <tr><td>, etc., markup, but with -->
    <!-- * all contents of each <td> cell marked up correctly in roff -->
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <!-- * put first-pass transformed output into a node-set so that -->
    <!-- * we can walk through it again and do further transformation -->
    <!-- * to generate correct markup for tbl(1) -->
    <xsl:param name="table" select="exsl:node-set($contents)"/>
    <!-- * .TS = "Table Start" -->
    <xsl:text>.TS&#10;</xsl:text>
    <!-- * put box around table and between all cells -->
    <xsl:text>allbox;&#10;</xsl:text>
    <!-- * create the table “format” spec, which tells tbl(1) how to -->
    <!-- * format each row and column -->
    <xsl:apply-templates select="$table//tr" mode="create.table.format" />
    <xsl:for-each select="$table//tr">
      <xsl:text>&#10;</xsl:text>
      <!-- * embed a comment to show where each row starts -->
      <xsl:text>.\" ==============================================&#10;</xsl:text>
      <xsl:text>.\" ROW </xsl:text>
      <xsl:value-of select="position()"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:for-each select="td|th">
        <!-- * the “T{" and “T}” stuff are delimiters to tell tbl(1) that -->
        <!-- * the delimited contents are “text blocks” that groff(1) -->
        <!-- * needs to process -->
        <xsl:text>T{&#10;</xsl:text>
        <xsl:apply-templates mode="trim" select="."/>
        <xsl:text>&#10;T}</xsl:text>
        <xsl:choose>
          <!-- * tbl(1) treats tab characters as delimiters between -->
          <!-- * cells; so we need to output a tab after each <td> except -->
          <!-- * the last one in the row -->
          <xsl:when test="position() = last()"/> <!-- do nothing -->
          <xsl:otherwise>
            <xsl:text>&#09;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <!-- * .TE = "Table End" -->
    <xsl:text>.TE&#10;</xsl:text>
    <!-- * put a blank line of space below the table -->
    <xsl:text>.sp&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="tr" mode="create.table.format">
    <!-- *  this template creates a “format” spec at the top of the table -->
    <!-- *  that looks something like the following: -->
    <!-- * -->
    <!-- *   cfB cfB cfB cfB -->
    <!-- *   l l s l -->
    <!-- *   l l l l -->
    <!-- * -->
    <xsl:for-each select="td|th">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'th'">
          <!-- * c = "center"; fB = "bold" -->
          <xsl:text>cfB</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- * l = "left" -->
          <xsl:text>l</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- * if <td> source for this cell has a “colspan” attribute, we -->
      <!-- * need to tell tbl(1) to format the corresponding cell as a -->
      <!-- * “spanned heading”; we do this by generating an "s" format -->
      <!-- * letter n-1 times, where n is hte value of the colspan attr -->
      <xsl:if test="@colspan and @colspan > 1">
        <!-- put a space before each additional format letter -->
        <xsl:text> </xsl:text>
        <xsl:call-template name="copy-string">
          <!-- * s = “spanned heading” -->
          <xsl:with-param name="string" select="'s'"/>
          <xsl:with-param name="count">
            <xsl:value-of select="@colspan - 1"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:choose>
        <!-- * output a space after each format letter except -->
        <!-- * the last one in the row -->
        <xsl:when test="position() = last()"/> <!-- do nothing -->
        <xsl:otherwise>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!-- * the following dot signals end of table "format" spec -->
    <xsl:choose>
      <xsl:when test="position() = last()">
      <xsl:text> .&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
