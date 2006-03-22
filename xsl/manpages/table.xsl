<?xml version="1.0" encoding="utf-8"?>
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
  <!-- *   http://cm.bell-labs.com/7thEdMan/vol2/tbl -->
  <!-- *   http://cm.bell-labs.com/cm/cs/doc/76/tbl.ps.gz -->
  <!-- *   http://www.snake.net/software/troffcvt/tbl.html -->

  <xsl:template match="table|informaltable">
    <!-- * ============================================================== -->
    <!-- *    Set global table parameters                                 -->
    <!-- * ============================================================== -->
    <!-- * First, set a few parameters based on attributes specified in -->
    <!-- * the table source. -->
    <xsl:param name="allbox">
    <xsl:if test="not(@frame = 'none') and not(@border = '0')">
      <!-- * By default, put a box around table and between all cells - -->
      <!-- * unless frame="none" or border="0" -->
      <xsl:text>allbox </xsl:text>
    </xsl:if>
    </xsl:param>
    <xsl:param name="center">
    <!-- * If align="center", center the table. Otherwise, tbl(1) -->
    <!-- * left-aligns it by default; note that there is no support -->
    <!-- * in tbl(1) for specifying right alignment. -->
    <xsl:if test="@align = 'center' or tgroup/@align = 'center'">
      <xsl:text>center </xsl:text>
    </xsl:if>
    </xsl:param>
    <xsl:param name="expand">
    <!-- * If pgwide="1" or width="100%", then "expand" the table by -->
    <!-- * making it "as wide as the current line length" (to quote -->
    <!-- * the tbl(1) guide). -->
    <xsl:if test="@pgwide = '1' or @width = '100%'">
      <xsl:text>expand </xsl:text>
    </xsl:if>
    </xsl:param>

    <!-- * ============================================================== -->
    <!-- *    Convert table to HTML                                       -->
    <!-- * ============================================================== -->
    <!-- * Process the table by applying HTML templates to the whole -->
    <!-- * thing; because we don’t override any of the <row>, <entry>, -->
    <!-- * <tr>, <td>, etc. templates, the templates in the HTML -->
    <!-- * stylesheets (which we import) are used to process those. -->
    <xsl:param name="html-table-output">
      <xsl:choose>
        <xsl:when test=".//tr">
          <!-- * If this table has a TR child, it means that it's an -->
          <!-- * HTML table in the DocBook source, instead of a CALS -->
          <!-- * table. So we just copy it as-is, while wrapping it -->
          <!-- * in a Table element -->
          <table>
            <xsl:copy-of select="*"/>
          </table>
        </xsl:when>
        <xsl:otherwise>
          <!-- * Otherwise, this is a CALS table in the DocBook source, -->
          <!-- * so we need to apply the templates in the HTML -->
          <!-- * stylesheets to transform it into HTML before we do -->
          <!-- * any further processing of it. -->
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="contents" select="exsl:node-set($html-table-output)"/>

    <xsl:for-each select="$contents/table">
    <!-- * ============================================================== -->
    <!-- *   Flatten table contents into row set                          -->
    <!-- * ============================================================== -->
    <!-- * Flatten the structure into just a set of rows without any -->
    <!-- * thead, tbody, or tfoot parents. And reorder the rows in -->
    <!-- * such a way that the tfoot rows are at the end, -->
    <xsl:variable name="rows-set">
      <xsl:copy-of select="thead/tr"/>
      <xsl:copy-of select="tbody/tr|tr"/>
      <xsl:copy-of select="tfoot/tr"/>
    </xsl:variable>
    <xsl:variable name="rows" select="exsl:node-set($rows-set)"/>

    <!-- * ============================================================== -->
    <!-- *   Flatten row set into simple list of cells                    -->
    <!-- * ============================================================== -->
    <!-- * Now we flatten the structure further into just a set of -->
    <!-- * cells without the row parents. This basically creates a -->
    <!-- * copy of the entire contents of the original table, but -->
    <!-- * restructured in such a way that we can more easily generate -->
    <!-- * the corresponding roff markup we need to output. -->
    <xsl:variable name="cells-list">
      <xsl:call-template name="build.cell.list">
        <xsl:with-param name="rows" select="$rows"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="cells" select="exsl:node-set($cells-list)"/>

    <!-- * ============================================================== -->
    <!-- *    Output the table.                                           -->
    <!-- * ============================================================== -->
    <!-- * This is where we generate the actual roff output, including -->
    <!-- * the optional "options line", required "format section", and -->
    <!-- * finally, the actual contents of each cell. -->

    <!-- * .TS = "Table Start" -->
    <xsl:text>.TS&#10;</xsl:text>

    <!-- * Output the "options line" with global attributes for the table -->
    <xsl:variable name="options-line">
      <xsl:value-of select="$allbox"/>
      <xsl:value-of select="$center"/>
      <xsl:value-of select="$expand"/>
    </xsl:variable>
    <xsl:if test="normalize-space($options-line) != ''">
      <xsl:value-of select="normalize-space($options-line)"/>
      <xsl:text>;&#10;</xsl:text>
    </xsl:if>

    <!-- * Output the table "format section", which tells tbl(1) how to -->
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
    </xsl:for-each>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *    Output the roff-formatted contents of each cell.            -->
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
  <!-- *   Build a restructured "cell list" copy of the entire table    -->
  <!-- * ============================================================== -->
  <xsl:template name="build.cell.list">
    <xsl:param name="rows"/>
    <xsl:param  name="cell-data-unsorted">
      <!-- * This param collect all the "real" cells from the table, -->
      <!-- * along with "dummy" rows that we generate for keeping -->
      <!-- * track of Rowspan instances. -->
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
    <!-- * Return the sorted cell list -->
    <xsl:copy-of select="$cell-data-sorted"/>
  </xsl:template>

  <xsl:template match="tr" mode="cell.list">
    <xsl:variable name="row">
      <xsl:value-of select="count(preceding-sibling::tr) + 1"/>
    </xsl:variable>
    <xsl:for-each select="td|th">
      <xsl:call-template name="cell">
        <xsl:with-param name="row" select="$row"/>
        <!-- * pass on the element name so we can select the appropriate -->
        <!-- * font for styling the cell contents -->
        <xsl:with-param name="class" select="name(.)"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="cell" mode="cell.list">
    <xsl:param name="row"/>
    <xsl:param name="class"/>
    <xsl:param name="slot">
      <!-- * The "slot" is the horizontal position of this cell (usually -->
      <!-- * just the same as its column, but not so when it is preceded -->
      <!-- * by cells that have colspans or cells in preceding rows that -->
      <!-- * that have rowspans). -->
      <xsl:value-of select="position()"/>
    </xsl:param>
    <!-- * For each real TD cell, create a Cell instance; contents will -->
    <!-- * be the roff-formatted contents of its original table cell. -->
    <cell type=""
          row="{$row}"
          slot="{$slot}"
          class="{$class}"
          colspan="{@colspan}"
          align="{@align}">
      <xsl:choose>
        <xsl:when test=".//tr">
          <xsl:message>Warn: Discarding nested table. Not supported in tbl(1).</xsl:message>
          <xsl:text>[Source&#160;had&#160;nested]&#10;</xsl:text>
          <xsl:text>[table,&#160;but&#160;tbl(1)]&#10;</xsl:text>
          <xsl:text>[lacks&#160;any&#160;support]&#10;</xsl:text>
          <xsl:text>[for&#160;nested&#160;table;]&#10;</xsl:text>
          <xsl:text>[so&#160;was&#160;discarded.]</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- * Apply templates to the child contents of this cell, to -->
          <!-- * transform them into marked-up roff. -->
          <xsl:variable name="contents">
            <xsl:apply-templates/>
          </xsl:variable>
          <!-- * We now have the contents in roff (plain-text) form, -->
          <!-- * but we may also still have unnecessary whitespace at -->
          <!-- * the beginning and/or end of it, so trim it off. -->
          <xsl:call-template name="trim.text">
            <xsl:with-param name="contents" select="$contents"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </cell>

    <!-- * For each instance of a rowspan attribute found, we create N -->
    <!-- * dummy cells, where N is equal to the value of the rowspan. -->
    <xsl:if test="@rowspan and @rowspan > 0">
      <!-- * If this cell is preceded in the same row by cells that -->
      <!-- * have colspan attributes, then we need to calculate the -->
      <!-- * "offset" caused by those colspan instances; the formula -->
      <!-- * is to (1) check for all the preceding cells that have -->
      <!-- * colspan attributes that are not empty and which have a -->
      <!-- * value greater than 1, then (2) take the sum of the values -->
      <!-- * of all those colspan attributes, and subtract from that -->
      <!-- * the number such colspan instances found. -->
      <xsl:variable name="colspan-offset">
        <xsl:value-of
            select="sum(preceding-sibling::td[@colspan != ''
                    and @colspan > 1]/@colspan) -
                    count(preceding-sibling::td[@colspan != ''
                    and @colspan > 1]/@colspan)"/>
      </xsl:variable>
      <xsl:call-template name="create.dummy.cells">
        <xsl:with-param name="row" select="$row + 1"/>
        <!-- * The slot value on each dummy cell must be offset by the -->
        <!-- * value of $colspan-offset to adjust for preceding colpans -->
        <xsl:with-param name="slot" select="$slot + $colspan-offset"/>
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
        <!-- * empty dummy cell each time. The type value, '^' -->
        <!-- * is the marker that tbl(1) uses for indicates a -->
        <!-- * "vertically spanned heading". -->
        <cell row="{$row}" slot="{$slot}" type="^" colspan="{@colspan}"/>
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
  <!-- * Description from the tbl(1) guide: -->
  <!-- * -->
  <!-- * "The format section of the table specifies the layout of the -->
  <!-- * columns.  Each line in this section corresponds to one line of -->
  <!-- * the table... and each line contains a key-letter for each -->
  <!-- * column of the table." -->
  <xsl:template name="create.table.format">
    <xsl:param name="cells"/>
    <xsl:apply-templates mode="table.format" select="$cells"/>
    <!-- * last line of table format section must end with a dot -->
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="cell" mode="table.format">
    <xsl:choose>
      <xsl:when test="preceding-sibling::cell[1]/@row != @row">
        <!-- * If the value of the row attribute on this cell is -->
        <!-- * different from the value of that on the previous cell, it -->
        <!-- * means we have a new row. So output a line break. -->
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- * If this isn't the first cell, output a space before it to -->
        <!-- * separate it from the preceding key letter. -->
        <xsl:if test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <!--* Select an appropriate key letter based on this cell's attributes. -->
    <xsl:choose>
      <xsl:when test="@type = '^'">
        <xsl:text>^</xsl:text>
      </xsl:when>
      <xsl:when test="@align = 'center'">
        <xsl:text>c</xsl:text>
      </xsl:when>
      <xsl:when test="@align = 'right'">
        <xsl:text>r</xsl:text>
      </xsl:when>
      <xsl:when test="@align = 'char'">
        <xsl:text>n</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Default to left alignment. -->
        <xsl:text>l</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@class = 'th'">
      <!-- * If this is a heading row, generate a font indicator (B or I), -->
      <!-- * or if the value of $man.table.heading.font is empty, nothing. -->
      <xsl:value-of select="$man.table.heading.font"/>
    </xsl:if>
    <!-- * We only need to deal with colspans whose value is greater -->
    <!-- * than one (a colspan="1" is the same as having no colspan -->
    <!-- * attribute at all. -->
    <xsl:if test="@colspan > 1">
      <xsl:call-template name="process.colspan">
        <xsl:with-param name="colspan" select="@colspan - 1"/>
        <xsl:with-param name="type" select="@type"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="process.colspan">
    <xsl:param name="colspan"/>
    <xsl:param name="type"/>
    <!-- * Output a space to separate this key letter from preceding one. -->
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="$type = '^'">
        <!-- * A '^' ("vertically spanned heading" marker) indicates -->
        <!-- * that the "parent" of this spanned cell is a dummy cell; -->
        <!-- * in this case, we need to generate a '^' instead of the -->
        <!-- * normal 's'. -->
        <xsl:text>^</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- * s = 'spanned heading' -->
        <xsl:text>s</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$colspan > 1">
      <!-- * Tail recurse until we have no more colspans, outputting -->
      <!-- * another marker each time. -->
      <xsl:call-template name="process.colspan">
        <xsl:with-param name="colspan" select="$colspan - 1"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- * Not sure what if anything to do with colgroup -->
  <xsl:template match="colgroup"/>
  <xsl:template match="col"/>

  <!-- * The following templates are needed for dealing with -->
  <!-- * table-footnote markup generated by the HTML stylesheets. -->
  <xsl:template match="div">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="sup">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="a">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
