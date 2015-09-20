<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <!--
   * $Id$
   * $Revision$ $Date$ $Author$ -->

  <xsl:param name="refentry.generate.name" select="0"/>
  <xsl:param name="refentry.generate.title" select="1"/>

  <xsl:param name="generate.manifest" select="1"></xsl:param>

  <xsl:param name="use.id.as.filename" select="1"/>
  <xsl:param name="chunk.fast" select="1"/>
  <xsl:param name="chunker.output.indent" select="'yes'"/>
  <xsl:param name="html.stylesheet" select="'style.css'"></xsl:param>

  <xsl:param name="generate.section.toc.level" select="2"></xsl:param>

  <xsl:param name="admon.graphics" select="1"></xsl:param>
  <xsl:param name="admon.graphics.path">images/</xsl:param>
  <xsl:param name="admon.graphics.extension" select="'.png'"></xsl:param>
  <xsl:param name="admon.style">
    <xsl:text>margin-left: 2%; margin-right: 5%;</xsl:text>
  </xsl:param>

  <xsl:param name="navig.graphics" select="1"></xsl:param>
  <xsl:param name="navig.graphics.path">images/</xsl:param>
  <xsl:param name="navig.graphics.extension" select="'.png'"></xsl:param>
  <xsl:param name="navig.showtitles">0</xsl:param>

  <xsl:param name="shade.verbatim" select="1"></xsl:param>

  <xsl:param name="variablelist.as.table" select="1"></xsl:param>

  <xsl:param name="generate.toc">
    appendix toc,title
    article/appendix nop
    article toc,title,figure
    book toc,title,figure,table,example,equation
    chapter toc,title
    part toc,title
    preface toc,title
    qandadiv toc
    qandaset toc
    reference toc,title
    sect1 toc
    sect2 toc
    sect3 toc
    sect4 toc
    sect5 toc
    section toc
    set toc,title
  </xsl:param>

  <!-- change admonition formatting -->
  <xsl:template name="graphical.admonition">
    <div class="{name(.)}">
      <xsl:if test="$admon.style != ''">
	<xsl:attribute name="style">
	  <xsl:value-of select="$admon.style"/>
	</xsl:attribute>
      </xsl:if>
      <table border="0">
	<tr>
	  <td align="center" valign="center">
	    <xsl:attribute name="width">
	      <xsl:call-template name="admon.graphic.width"/>
	    </xsl:attribute>
	    <img>
	      <xsl:attribute name="src">
		<xsl:call-template name="admon.graphic"/>
	      </xsl:attribute>
	    </img>
	  </td>
	  <th align="left">
	    <xsl:call-template name="anchor"/>
	    <p>
	      <xsl:apply-templates select="." mode="object.title.markup"/>
	    </p>
	  </th>
	</tr>
	<tr>
	  <td></td>
	  <td align="left" valign="top">
	    <xsl:apply-templates/>
	  </td>
	</tr>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
