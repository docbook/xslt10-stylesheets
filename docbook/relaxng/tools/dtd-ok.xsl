<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <!-- The plan is that this stylesheet cleans up a DocBook RNG file, refactoring
       the constructs that Trang can't handle into appropriate deterministic
       (and less constrained) alternatives. -->

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="rng:define[string-length(@name) &gt; 7
                       and starts-with(@name,'local.')
                       and substring(@name, string-length(@name)-6) = '.attrib']"
                priority="2">
    <!-- delete this -->
  </xsl:template>

  <xsl:template match="rng:ref[string-length(@name) &gt; 7
                       and starts-with(@name,'local.')
                       and substring(@name, string-length(@name)-6) = '.attrib']"
                priority="2">
    <!-- delete this -->
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
