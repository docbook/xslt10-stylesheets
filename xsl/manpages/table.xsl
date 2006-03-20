<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                exclude-result-prefixes="exsl set"
                version='1.0'>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://docbook.sf.net/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- ==================================================================== -->

  <!-- * This stylesheet transforms DocBook source to tbl(1) markup. -->
  <!-- * -->
  <!-- * See M. E. Lesk, "Tbl – A Program to Format Tables" for details -->
  <!-- * on tbl(1) and its markup syntaxt. -->
  <!-- * -->
  <!-- *   http://cm.bell-labs.com/cm/cs/doc/76/tbl.ps.gz -->
  <!-- *   http://www.snake.net/software/troffcvt/tbl.html -->

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
    <xsl:param name="table" select="exsl:node-set($contents)/table"/>
    <xsl:param name="total-rows" select="count($table//tr)"/>

    <xsl:variable name="rows-set">
      <xsl:copy-of select="$table/thead/tr"/>
      <xsl:copy-of select="$table/tbody/tr|$table/tr"/>
      <xsl:copy-of select="$table/tfoot/tr"/>
    </xsl:variable>

    <xsl:variable name="rows" select="exsl:node-set($rows-set)"/>

    <xsl:variable name="cells">
      <xsl:call-template name="build.cell.list">
        <xsl:with-param name="rows" select="$rows"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * .TS = "Table Start" -->
    <xsl:text>.TS&#10;</xsl:text>
    <!-- * put box around table and between all cells -->
    <xsl:text>allbox;&#10;</xsl:text>

    <!-- * create the table "format" spec, which tells tbl(1) how to -->
    <!-- * format each row and column -->
    <xsl:call-template name="create.table.format">
      <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
    </xsl:call-template>

    <xsl:for-each select="$rows/tr">
      <xsl:call-template name="output.row">
        <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
        <xsl:with-param name="row" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:text>&#10;</xsl:text>
    <!-- * .TE = "Table End" -->
    <xsl:text>.TE&#10;</xsl:text>
    <!-- * put a blank line of space below the table -->
    <xsl:text>.sp&#10;</xsl:text>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="output.row">
    <xsl:param name="cells"/>
    <xsl:param name="row"/>
    <xsl:param name="total-columns" select="count(td|th)"/>
    <xsl:text>&#10;</xsl:text>
    <!-- * embed a comment to show where each row starts -->
    <xsl:text>.\" ==============================================&#10;</xsl:text>
    <xsl:text>.\" ROW </xsl:text>
    <xsl:value-of select="$row"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="td|th">
      <xsl:call-template name="output.cell">
        <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
        <xsl:with-param name="row" select="$row"/>
        <xsl:with-param name="slot" select="position()"/>
        <xsl:with-param name="total-columns" select="$total-columns"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="output.cell">
    <xsl:param name="cells"/>
    <xsl:param name="row"/>
    <xsl:param name="slot"/>
    <xsl:param name="total-columns"/>
    <xsl:param name="format-letter">
      <xsl:value-of
          select="$cells//cell[@row = $row and @slot = $slot]/@type"/>
    </xsl:param>                            
    <xsl:choose>
      <xsl:when test="contains($format-letter,'^')">
        <xsl:text>&#09;</xsl:text>
        <xsl:call-template name="output.cell">
          <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
          <xsl:with-param name="row" select="$row"/>
          <xsl:with-param name="slot" select="$slot + 1"/>
          <xsl:with-param name="total-columns" select="$total-columns"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * the "T{" and "T}" stuff are delimiters to tell tbl(1) that -->
        <!-- * the delimited contents are "text blocks" that groff(1) -->
        <!-- * needs to process -->
        <xsl:text>T{&#10;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#10;T}</xsl:text>
        <xsl:if test="@colspan and @colspan > 1">
          <xsl:call-template name="copy-string">
            <xsl:with-param name="string">&#09;</xsl:with-param>
            <xsl:with-param name="count">
              <xsl:value-of select="@colspan"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$slot = $total-columns"/> <!-- do nothing -->
          <xsl:otherwise>
            <!-- * tbl(1) treats tab characters as delimiters between -->
            <!-- * cells; so we need to output a tab after each <td> except -->
            <!-- * the last one in the row -->
            <xsl:text>&#09;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="build.cell.list">
    <xsl:param name="rows"/>
    <xsl:variable name="cell-data-unsorted">
      <xsl:apply-templates select="$rows" mode="cell.list"/>
    </xsl:variable>
    <xsl:variable name="cell-data-sorted">
      <xsl:for-each select="exsl:node-set($cell-data-unsorted)/cell">
        <xsl:sort select="@row"/>
        <xsl:sort select="@slot"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$cell-data-sorted"/>
  </xsl:template>

  <xsl:template match="tr" mode="cell.list">
    <xsl:variable name="row">
      <xsl:value-of select="count(preceding-sibling::tr) + 1"/>
    </xsl:variable>
    <xsl:for-each select="td|th">
      <xsl:call-template name="td">
        <xsl:with-param name="row" select="$row"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="td" mode="cell.list">
    <xsl:param name="row"/>
    <xsl:param name="slot">
      <xsl:value-of select="position()"/>
    </xsl:param>
    <cell row="{$row}" slot="{$slot}" type="l" colspan="{@colspan}">
      <xsl:apply-templates/>
    </cell>
    <xsl:if test="@rowspan and @rowspan > 0">
      <xsl:call-template name="process.rowspan">
        <xsl:with-param name="row" select="$row + 1"/>
        <xsl:with-param name="slot" select="$slot"/>
        <xsl:with-param name="colspan" select="@colspan"/>
        <xsl:with-param name="rowspan" select="@rowspan"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="process.rowspan">
    <xsl:param name="row"/>
    <xsl:param name="slot"/>
    <xsl:param name="colspan"/>
    <xsl:param name="rowspan"/>
    <xsl:choose>
      <xsl:when test="$rowspan > 1">
        <cell row="{$row}" slot="{$slot}"  type="^" colspan="{@colspan}"/>
        <xsl:call-template name="process.rowspan">
          <xsl:with-param name="row" select="$row + 1"/>
          <xsl:with-param name="slot" select="$slot"/>
          <xsl:with-param name="colspan" select="$colspan"/>
          <xsl:with-param name="rowspan" select="$rowspan - 1"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="create.table.format">
    <xsl:param name="cells"/>
    <xsl:apply-templates mode="table.format" select="$cells"/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="cell" mode="table.format">
    <xsl:if test="preceding-sibling::cell[1]/@row != @row">
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@type = '^'">
        <xsl:text>^</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>l</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@colspan > 0">
      <xsl:call-template name="process.colspan">
        <xsl:with-param name="colspan" select="@colspan - 1"/>
        <xsl:with-param name="type" select="@type"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="process.colspan">
    <xsl:param name="colspan"/>
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = '^'">
        <xsl:text>^</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>s</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$colspan > 1">
      <xsl:call-template name="process.colspan">
        <xsl:with-param name="colspan" select="$colspan - 1"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
