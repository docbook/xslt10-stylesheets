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
    
    <!-- * ============================================================== -->
    <!-- *   Get all the table contents and restructure them              -->
    <!-- * ============================================================== -->
    
    <!-- * Put first-pass transformed output into a node-set so that -->
    <!-- * we can walk through it again and do further transformation -->
    <!-- * to generate correct markup for tbl(1) -->
    <xsl:param name="table" select="exsl:node-set($contents)/table"/>

    <!-- * Flatten the structure into just a set of rows without any -->
    <!-- * thead, tbody, or tfoot parents. And reorder the rows in -->
    <!-- * such a way that the tfoot rows are at the end, -->
    <xsl:variable name="rows-set">
      <xsl:copy-of select="$table/thead/tr"/>
      <xsl:copy-of select="$table/tbody/tr|$table/tr"/>
      <xsl:copy-of select="$table/tfoot/tr"/>
    </xsl:variable>
    <xsl:variable name="rows" select="exsl:node-set($rows-set)"/>

    <!-- * Now we flatten the structure further into just a set of -->
    <!-- * cells without the row parents. This basically creates a -->
    <!-- * copy of the entire contents of the original table, but -->
    <!-- * restructured in such a way that we can more easily generate -->
    <!-- * the corresponding roff markup we need to output. -->
    <xsl:variable name="cells-set">
      <xsl:call-template name="build.cell.list">
        <xsl:with-param name="rows" select="$rows"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="cells" select="exsl:node-set($cells-set)"/>

    <!-- * ============================================================== -->
    <!-- *         Output the table.                                      -->
    <!-- * ============================================================== -->

    <!-- * .TS = "Table Start" -->
    <xsl:text>.TS&#10;</xsl:text>
    <!-- * put box around table and between all cells -->
    <xsl:text>allbox;&#10;</xsl:text>

    <!-- * Output the table "format" spec, which tells tbl(1) how to -->
    <!-- * format each row and column -->
    <xsl:call-template name="create.table.format">
      <xsl:with-param name="cells" select="$cells"/>
    </xsl:call-template>

    <!--* Output the formatted contents of each cell. -->
    <xsl:for-each select="$cells/cell">
      <xsl:call-template name="output.cell"/>
    </xsl:for-each>

    <xsl:text>&#10;</xsl:text>
    <!-- * .TE = "Table End" -->
    <xsl:text>.TE&#10;</xsl:text>
    <!-- * put a blank line of space below the table -->
    <xsl:text>.sp&#10;</xsl:text>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Output the actual cell contents and roff row/cell markup    -->
  <!-- * ============================================================== -->
  <xsl:template name="output.cell">
    <xsl:choose>
      <xsl:when test="preceding-sibling::cell[1]/@row != @row or
                      not(preceding-sibling::cell)">
        <!-- * If the value of the row attribute on this cell is -->
        <!-- * different from the value of that on the previous cell, it -->
        <!-- * means we have a new row. So output a line break (as long -->
        <!-- * as this isn’t the first cell in the table -->
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise we are not at the start of a new row, so we -->
        <!-- * output a tab character to delmit the contents of this -->
        <!-- * cell from the contents of the next one. -->
        <xsl:text>&#x2302;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@type = '^'">
        <!-- * If this is a dummy cell resulting from the presence of -->
        <!-- * rowpan attribute in the source, it has no contents, so -->
        <!-- * we need to handle it differently. -->
        <xsl:if test="@colspan and @colspan > 1">
          <!-- * If there is a colspan attribute on this dummy row, then -->
          <!-- * we need to output a tab character for each column that -->
          <!-- * it spans. -->
          <xsl:call-template name="copy-string">
            <xsl:with-param name="string">&#x2302;</xsl:with-param>
            <xsl:with-param name="count">
              <xsl:value-of select="@colspan - 1"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise, we have a "real" cell (not a dummy one) with -->
        <!-- * contents that we need to output, -->
        <!-- * -->
        <!-- * The "T{" and "T}" stuff are delimiters to tell tbl(1) that -->
        <!-- * the delimited contents are "text blocks" that groff(1) -->
        <!-- * needs to process -->
        <xsl:text>T{&#10;</xsl:text>
        <xsl:copy-of select="."/>
        <xsl:text>&#10;T}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Build a restructured "cell list" copy of the table          -->
  <!-- * ============================================================== -->
  <xsl:template name="build.cell.list">
    <xsl:param name="rows"/>
    <xsl:param  name="cell-data-unsorted">
      <!-- * This gets all the "real" cells from the table along with -->
      <!-- * "dummy" rows that we generate for keeping track of Rowspan -->
      <!-- * instances. -->
      <xsl:apply-templates select="$rows" mode="cell.list"/>
    </xsl:param>
    <xsl:param  name="cell-data-sorted">
      <!-- * Sort the cells so that the dummy cells get put where we -->
      <!-- * need them in the structure. -->
      <xsl:for-each select="exsl:node-set($cell-data-unsorted)/cell">
        <xsl:sort select="@row"/>
        <xsl:sort select="@slot"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:param>
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
    <!-- * For each real cell, create a Cell instance; its contents are -->
    <!-- * the roff-formatted contents of the corresponding original table -->
    <!-- * cell. -->
    <cell row="{$row}" slot="{$slot}" type="l" colspan="{@colspan}">
      <xsl:apply-templates/>
    </cell>
    <xsl:if test="@rowspan and @rowspan > 0">
      <!-- * For each instance of a rowspan attribute found, we create N -->
      <!-- * dummy cells, where N is equal to the value of the rowspan. -->
      <xsl:call-template name="create.dummy.cells">
        <xsl:with-param name="row" select="$row + 1"/>
        <xsl:with-param name="slot" select="$slot"/>
        <xsl:with-param name="colspan" select="@colspan"/>
        <xsl:with-param name="rowspan" select="@rowspan"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create.dummy.cells">
    <xsl:param name="row"/>
    <xsl:param name="slot"/>
    <xsl:param name="colspan"/>
    <xsl:param name="rowspan"/>
    <xsl:choose>
      <xsl:when test="$rowspan > 1">
        <!-- * Tail recurse until we have no more rowspans, creating an -->
        <!-- * empty dummy cell each time -->
        <cell row="{$row}" slot="{$slot}"  type="^" colspan="{@colspan}"/>
        <xsl:call-template name="create.dummy.cells">
          <xsl:with-param name="row" select="$row + 1"/>
          <xsl:with-param name="slot" select="$slot"/>
          <xsl:with-param name="colspan" select="$colspan"/>
          <xsl:with-param name="rowspan" select="$rowspan - 1"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Build the "format section" for the table                    -->
  <!-- * ============================================================== -->

  <xsl:template name="create.table.format">
    <xsl:param name="cells"/>
    <xsl:apply-templates mode="table.format" select="$cells"/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="cell" mode="table.format">
    <xsl:choose>
      <xsl:when test="preceding-sibling::cell[1]/@row != @row">
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if  test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:text> </xsl:text>
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
