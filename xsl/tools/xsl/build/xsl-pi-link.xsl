<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:include href="xsl-pi.xsl"/>

  <!-- * We check for tag@class=xmlpi|pi instances and generate doc -->
  <!-- * links for those that reference PIs used in the docbook-xsl -->
  <!-- * stylsesheets code; but do exclude the ones that appear in -->
  <!-- * synopsis content (because we want those to appear literally, -->
  <!-- * not as hyperlinks) -->
  <xsl:template match="
    tag[@class = 'xmlpi' or @class='pi'][not(ancestor::synopsis)]
    |sgmltag[@class = 'xmlpi' or @class='pi'][not(ancestor::synopsis)]">
    <xsl:variable name="tagmarkup">
      <xsl:apply-imports/>
    </xsl:variable>
    <xsl:variable name="underscored-pi">
      <!-- * Replace any space, non-breaking space, or @ mark in the -->
      <!-- * marked-up PI with an underscore (because that's the from we -->
      <!-- * use for the PI ID/filenames in the docs). -->
      <xsl:value-of select="translate(normalize-space(.),' &#xa0;@','___')"/>
    </xsl:variable>
    <xsl:variable name="adjusted-pi-name">
      <xsl:choose>
        <!-- * If the marked-up PI is of the form, e.g., <?dbhtml foo="bar"?>, -->
        <!-- * then just get the part before the equal sign (=), because -->
        <!-- * that part is what we use as the "name" of hte PI in our docs -->
        <xsl:when test="contains($underscored-pi,'=')">
          <xsl:value-of select="substring-before($underscored-pi,'=')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$underscored-pi"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ispi">
      <!-- * check the PI name we have to see if it is in the -->
      <!-- * auto-geneated list of PIs in the docbook-xsl code -->
      <xsl:call-template name="is-pi">
        <xsl:with-param name="pi" select="$adjusted-pi-name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not($ispi = 0)">
        <!-- * If $ispi is non-zero, it means we have the name of a PI -->
        <!-- * that's used in the docbook-xsl stylesheets, and -->
        <!-- * documented; so we created a hyperlink to its doc page -->
        <!-- * doc-baseuri is declared in the xsl-param-link.xsl file -->
        <a href="{concat($doc-baseuri, 'pi/',normalize-space($adjusted-pi-name))}.html">
          <xsl:copy-of select="$tagmarkup"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$tagmarkup"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
