<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
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
  <!-- * See M. E. Lesk, “Tbl – A Program to Format Tables” for details -->
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
    <xsl:param name="table" select="exsl:node-set($contents)"/>
    <xsl:param name="total-rows" select="count($table//tr)"/>

    <xsl:variable name="cells">
      <xsl:call-template name="build.cell.list">
        <xsl:with-param name="table" select="$table"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * .TS = "Table Start" -->
    <xsl:text>.TS&#10;</xsl:text>
    <!-- * put box around table and between all cells -->
    <xsl:text>allbox;&#10;</xsl:text>

    <!-- * create the table “format” spec, which tells tbl(1) how to -->
    <!-- * format each row and column -->
    <xsl:call-template name="create.table.format">
      <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
      <xsl:with-param name="total-rows" select="$total-rows"/>
    </xsl:call-template>

    <xsl:for-each select="$table//tr">
      <xsl:call-template name="output.row">
        <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
        <xsl:with-param name="row-number" select="position()"/>
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
    <xsl:param name="row-number"/>
    <xsl:param name="total-columns" select="count(td|th)"/>
    <xsl:text>&#10;</xsl:text>
    <!-- * embed a comment to show where each row starts -->
    <xsl:text>.\" ==============================================&#10;</xsl:text>
    <xsl:text>.\" ROW </xsl:text>
    <xsl:value-of select="$row-number"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="td|th">
      <xsl:call-template name="output.cell">
        <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
        <xsl:with-param name="row-number" select="$row-number"/>
        <xsl:with-param name="column-number" select="position()"/>
        <xsl:with-param name="total-columns" select="$total-columns"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="output.cell">
    <xsl:param name="cells"/>
    <xsl:param name="row-number"/>
    <xsl:param name="column-number"/>
    <xsl:param name="total-columns"/>
    <xsl:param name="format-letter">
      <xsl:value-of
          select="$cells//cell[@row = $row-number and @column = $column-number]"/>
    </xsl:param>                            
    <xsl:choose>
      <xsl:when test="contains($format-letter,'^')">
        <xsl:text>&#09;</xsl:text>
        <xsl:call-template name="output.cell">
          <xsl:with-param name="cells" select="exsl:node-set($cells)"/>
          <xsl:with-param name="row-number" select="$row-number"/>
          <xsl:with-param name="column-number" select="$column-number + 1"/>
          <xsl:with-param name="total-columns" select="$total-columns"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * the “T{" and “T}” stuff are delimiters to tell tbl(1) that -->
        <!-- * the delimited contents are “text blocks” that groff(1) -->
        <!-- * needs to process -->
        <xsl:text>T{&#10;</xsl:text>
        <!-- * trim any leading and trailing whitespace from cell contents -->
        <xsl:call-template name="trim.text">
          <xsl:with-param name="contents" select="."/>
        </xsl:call-template>
        <xsl:text>&#10;T}</xsl:text>
        <xsl:choose>
          <xsl:when test="$column-number = $total-columns"/> <!-- do nothing -->
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
    <xsl:param name="table"/>
    <xsl:param name="row-counter">1</xsl:param>
    <xsl:param name="total-rows" select="count($table//tr)"/>
    <xsl:param name="cell-data"/>
    <!-- * This template calls itself recursivingly until all rows are -->
    <!-- * processed. It uses the $cell-data param to keep a running -->
    <!-- * record of the table layout. That is necessary in order to -->
    <!-- * properly process Rowspan instances. -->
    <xsl:variable name="new-cell-data">
      <xsl:call-template name="process.source.row">
        <xsl:with-param name="content" select="$table//tr[$row-counter]"/>
        <xsl:with-param name="row-counter" select="$row-counter"/>
        <xsl:with-param name="total-rows" select="$total-rows"/>
        <xsl:with-param name="cell-data" select="exsl:node-set($cell-data)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- * When the value of row counter reaches the total number of -->
      <!-- * rows, it means we have processed all rows; so next steps are -->
      <!-- * to sort it and pass the cell list on for processing. -->
      <xsl:when test="$row-counter = $total-rows">
        <xsl:variable name="cell-list" select="exsl:node-set($new-cell-data)"/>
        <!-- * Sort the cell list by row and then by column within row -->
        <xsl:variable name="cell-list-sorted">
          <xsl:for-each select="set:distinct($cell-list//cell)">
            <xsl:sort select="@row"/>
            <xsl:sort select="@column"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="exsl:node-set($cell-list-sorted)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise, the value of row counter is still less than the -->
        <!-- * total number of rows, so we increment the row-counter count -->
        <!-- * and recursively re-call the current template to -->
        <!-- * process the next row. We pass the cell-data param so that -->
        <!-- * we will know the layout of rows we have processed so far. -->
        <xsl:call-template name="build.cell.list">
          <xsl:with-param name="table" select="$table"/>
          <xsl:with-param name="row-counter" select="$row-counter + 1"/>
          <xsl:with-param name="cell-data" select="exsl:node-set($new-cell-data)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="process.source.row">
    <xsl:param name="content"/>
    <xsl:param name="row-counter"/>
    <xsl:param name="cell-counter" select="1"/>
    <xsl:param name="total-rows"/>
    <xsl:param name="total-cells" select="count($content/*)"/>
    <xsl:param name="cell-data"/>
    <!-- * This template calls itself recursivingly until all cells in -->
    <!-- * a row are processed. It uses the $cell-data param to keep -->
    <!-- * a running record of the table layout. That is necessary in -->
    <!-- * order to properly process Rowspan instances. -->
    <!-- * -->
    <!-- * First copy in all cell data we have so far -->
    <xsl:copy-of select="$cell-data"/>
    <xsl:choose>
      <!-- * When the value of cell counter is less than or equal to the -->
      <!-- * total number of cells in the row, it means we still have -->
      <!-- * cells to process, so we call the template for generating -->
      <!-- * cell format data. -->
      <xsl:when test="$cell-counter &lt;= $total-cells">
        <xsl:variable name="new-cell-data">
          <xsl:call-template name="assemble.cell.data">
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="cell-content" select="$content[1]/*[$cell-counter]"/>
            <xsl:with-param name="row-counter" select="$row-counter"/>
            <xsl:with-param name="cell-counter" select="$cell-counter"/>
            <xsl:with-param name="cell-data" select="exsl:node-set($cell-data)"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- * Now we increment the cell-counter count and recursively -->
        <!-- * re-call the current template to process the next cell. -->
        <xsl:call-template name="process.source.row">
          <xsl:with-param name="content" select="$content[1]"/>
          <xsl:with-param name="row-counter" select="$row-counter"/>
          <xsl:with-param name="cell-counter" select="$cell-counter + 1"/>
          <xsl:with-param name="cell-data" select="exsl:node-set($new-cell-data)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- * Otherwise, the value of the cell counter exceeds the total number -->
      <!-- * of cells, meaning that we have run out of cells to process, so we -->
      <!-- * don’t do anything more – just return to the calling template. -->
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="assemble.cell.data">
    <xsl:param name="content"/>
    <xsl:param name="cell-content"/>
    <xsl:param name="row-counter"/>
    <xsl:param name="cell-counter" select="1"/>
    <xsl:param name="cell-data"/>
    <xsl:param name="column" select="$cell-counter"/>
    <!-- * This template processes each pair of row and column -->
    <!-- * coordinates and generates a “cell” with appropriate data for -->
    <!-- * each. It checks to see if a cell has Rowspan and/or Colspan -->
    <!-- * attributes. If so, it generates cells for those also. -->
    <!-- * -->
    <!-- * For each pair of cell coordinates, it checks the $cell-data -->
    <!-- * list to see if we have already generated a cell at those -->
    <!-- * coordinates (as a result of auto-generating one for a Colspan -->
    <!-- * or Rowspan instance); if we have, it does not generate a new -->
    <!-- * cell, but shifts the cell numbering for the rest of the cells -->
    <!-- * over as needed. -->
    <xsl:choose>
      <!-- * Check to see if we already have an existing cell at the -->
      <!-- * current coordinates. -->
      <xsl:when test="$cell-data//cell[@row = $row-counter and @column = $cell-counter]">
        <!-- * If we already have a cell here, increment cell counter -->
        <!-- * and then recursively call the current template to -->
        <!-- * check the next column, until we find an “open” column. -->
        <xsl:call-template name="assemble.cell.data">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="cell-content" select="$content[1]/*[$cell-counter + 1]"/>
          <xsl:with-param name="row-counter" select="$row-counter"/>
          <xsl:with-param name="cell-counter" select="$cell-counter + 1"/>
          <xsl:with-param name="cell-data" select="$cell-data"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise, we don’t have a existing cell at these -->
        <!-- * coordinates, so we need to generate one. -->
        <!-- * -->
        <!-- * ****************** HACK ALERT ************************* -->
        <!-- * We first re-copy the whole cell-data list. This results -->
        <!-- * in a potentially huge number of duplicates in the -->
        <!-- * list. So, we need to run set:distinct() on it each -->
        <!-- * time in order to get rid of the duplicates. I have not -->
        <!-- * yet found a way around this. -Mike -->
        <xsl:copy-of select="set:distinct($cell-data//cell)"/>
        <!-- * Now call the template that actually generates the Cell -->
        <!-- * instance for each “real” cell. -->
        <xsl:call-template name="cell">
          <xsl:with-param name="row" select="$row-counter"/>
          <xsl:with-param name="column" select="$cell-counter"/>
        </xsl:call-template>
        <!-- * Next, if we find a Colspan attribute in the source, -->
        <!-- * call the template that generates the bogus Cell -->
        <!-- * instances we need for outputting appropriate tbl(1) -->
        <!-- * markup we need for output of Colspan instances. -->
        <xsl:if test="$cell-content/@colspan">
          <xsl:call-template name="colspan">
            <xsl:with-param name="count" select="$cell-content/@colspan"/>
            <xsl:with-param name="row" select="$row-counter"/>
            <xsl:with-param name="column" select="$cell-counter + 1"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$cell-content/@rowspan">
          <!-- * Finally, if we find a Rowspan attribute in the source, -->
          <!-- * we first call a rowspans (plural) template, because we -->
          <!-- * need to check and see if there is also a Colspan -->
          <!-- * attribute on the same element; if there is, we have to -->
          <!-- * generate N number of bogus Cell instances for each -->
          <!-- * Rowspan, where N is the value of the Colspan attribute. -->
          <xsl:call-template name="rowspans">
            <xsl:with-param name="count" select="$cell-content/@rowspan - 1"/>
            <xsl:with-param name="row" select="$row-counter + 1"/>
            <xsl:with-param name="column" select="$cell-counter"/>
            <xsl:with-param name="iterations">
              <xsl:choose>
                <!-- * If this element actually has a Colspan attribute, -->
                <!-- * we use that value. -->
                <xsl:when test="$cell-content/@colspan">
                  <xsl:value-of select="$cell-content/@colspan"/>
                </xsl:when>
                <!-- * Otherwise, we only do one iteration -->
                <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="rowspans">
    <xsl:param name="count"/>
    <xsl:param name="iterations"/>
    <xsl:param name="row"/>
    <xsl:param name="column"/>
    <!-- * This is a special template needed to deal with cases where an -->
    <!-- * element has both Rowspan and Colspan attributes. -->
    <!-- * -->
    <!-- * This template calls the rowspan (singular) template N -->
    <!-- * number of times, where N=$iterations; it does that by -->
    <!-- * recursively calling itself. -->
    <xsl:choose>
      <!-- * When the value of $iterations reaches zero, we stop and -->
      <!-- * return to the calling template. -->
      <xsl:when test="$iterations = 0"/> <!-- * do nothing -->
      <xsl:otherwise>
             Otherwise, the value os $iterations is still non-zero, so
             we call the rowspan template to generate the bogus Cell
             instances we need for outputting appropriate tbl(1)
             markup we need for Rowspan instances.
        <xsl:call-template name="rowspan">
          <xsl:with-param name="count" select="$count"/>
          <xsl:with-param name="row" select="$row"/>
          <xsl:with-param name="column" select="$column"/>
        </xsl:call-template>
        <xsl:call-template name="rowspans">
          <xsl:with-param name="count" select="$count"/>
          <xsl:with-param name="iterations" select="$iterations - 1"/>
          <xsl:with-param name="row" select="$row"/>
          <xsl:with-param name="column" select="$column + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ==================================================================== -->

  <!-- * The following templates generate the actual Cell instances that -->
  <!-- * we need for assembling the tbel(1) table-format spec. -->

  <xsl:template name="cell">
    <xsl:param name="row"/>
    <xsl:param name="column"/>
    <!-- * This template gets called once for each real table cell in -->
    <!-- * the source. -->
    <cell>
      <!-- * Add row and column attributes, plus row and column data -->
      <!-- * in the string value of the element. -->
      <xsl:call-template name="row-column-data">
        <xsl:with-param name="row" select="$row"/>
        <xsl:with-param name="column" select="$column"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'th'">
          <!-- * c = "centered" -->
          <xsl:text>c</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- * l = "left" -->
          <xsl:text>l</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </cell>
  </xsl:template>

  <xsl:template name="colspan">
    <xsl:param name="count"/>
    <xsl:param name="row"/>
    <xsl:param name="column"/>
    <!-- * This template generates a bogus Cell instance for the number -->
    <!-- * of columns specified in the Colspan attribute. It does that -->
    <!-- * by recursively calling itself. -->
    <xsl:choose>
      <!-- * If count has reached 1, we have no more columns to process, -->
      <!-- * so we stop and return to the calling template. -->
      <xsl:when test="$count = 1"/> <!-- * do nothing -->
      <xsl:otherwise>
        <!-- * Otherwise, count has not reached 1, so we need to -->
        <!-- * generate a Cell. -->
        <cell>
          <!-- * Add row and column attributes, plus row and column data -->
          <!-- * in the string value of the element. -->
          <xsl:call-template name="row-column-data">
            <xsl:with-param name="row" select="$row"/>
            <xsl:with-param name="column" select="$column"/>
          </xsl:call-template>
          <!-- * s  = "spanned heading" -->
          <xsl:text>s</xsl:text>
        </cell>
        <!-- * Decrement the count, increment the column number, and -->
        <!-- * recursively call the current template with those values -->
        <!-- * in order to generate the next Cell for this Colspan. -->
        <xsl:call-template name="colspan">
          <xsl:with-param name="count" select="$count - 1"/>
          <xsl:with-param name="row" select="$row"/>
          <xsl:with-param name="column" select="$column + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="rowspan">
    <xsl:param name="count"/>
    <xsl:param name="row"/>
    <xsl:param name="column"/>
    <!-- * This template generates bogus Cell instances for the number -->
    <!-- * of rows specified in the Rowspan attribute. It does that -->
    <!-- * by recursively calling itself. -->
    <xsl:choose>
      <!-- * If count has reached 1, we have no more rows to process, -->
      <!-- * so we stop and return to the calling template. -->
      <xsl:when test="$count = 0"/> <!-- * do nothing -->
      <xsl:otherwise>
        <!-- * Otherwise, count has not reached 1, so we need to -->
        <!-- * generate a Cell. -->
        <cell>
          <!-- * Add row and column attributes, plus row and column data -->
          <!-- * in the string value of the element. -->
          <xsl:call-template name="row-column-data">
            <xsl:with-param name="row" select="$row"/>
            <xsl:with-param name="column" select="$column"/>
          </xsl:call-template>
          <!-- * ^  = "vertically spanned heading" -->
          <xsl:text>^</xsl:text>
        </cell>
        <!-- * Decrement the count, increment the row number, and -->
        <!-- * recursively call the current template with those values -->
        <!-- * in order to generate the next Cell for this Rowspan. -->
        <xsl:call-template name="rowspan">
          <xsl:with-param name="count" select="$count - 1"/>
          <xsl:with-param name="row" select="$row + 1"/>
          <xsl:with-param name="column" select="$column"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="row-column-data">
    <xsl:param name="row"/>
    <xsl:param name="column"/>
    <!-- * Generate row and column attributes for this Cell -->
    <xsl:attribute name="row"><xsl:value-of select="$row"/></xsl:attribute>
    <xsl:attribute name="column"><xsl:value-of select="$column"/></xsl:attribute>
    <!-- * Generate this first part of the three-part value of this -->
    <!-- * Cell; the three-part format is: -->
    <!-- * -->
    <!-- * $row,$column,[tbl(1) format letter] -->
    <!-- * -->
    <!-- * The reason we put the row and column numbers into the value -->
    <!-- * of the Cell is so that we can remove duplicates from the -->
    <!-- * cell list later (as far as why the duplicates are there to -->
    <!-- * begin with, see the HACK ALERT above. -->
    <xsl:value-of select="$row"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$column"/>
    <xsl:text>,</xsl:text>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="create.table.format">
    <xsl:param name="cells"/>
    <xsl:param name="total-rows"/>
    <xsl:param name="row-counter">1</xsl:param>
    <xsl:choose>
      <xsl:when test="$row-counter > $total-rows">
        <xsl:text>.&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates
            mode="create.table.format.row"
            select="$cells//cell[@row = $row-counter]"/>
        <xsl:call-template name="create.table.format">
          <xsl:with-param name="cells" select="$cells"/>
          <xsl:with-param name="total-rows" select="$total-rows"/>
          <xsl:with-param name="row-counter" select="$row-counter + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="cell" mode="create.table.format.row">
    <xsl:value-of select="substring(.,string-length(.),1)"/>
    <xsl:choose>
    <xsl:when test="position() = last()">
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> </xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
