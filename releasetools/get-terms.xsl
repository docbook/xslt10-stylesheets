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
  
  <!-- * Given a list of files, this stylesheet collects certain -->
  <!-- * element names (or "terms") from those files. The resulting -->
  <!-- * list of terms is intended for use by another stylesheet that-->
  <!-- * does processing of docs containing instances of the terms. -->
 
  <!-- * the name of the root element to put into the result tree -->
  <xsl:param name="result.root.element">terms</xsl:param>

  <!-- * $element.files is a space-separated list of file names of RELAX -->
  <!-- * NG schema files (.rng files, in the XML syntax) -->
  <xsl:param name="element.files"/>

  <!-- * $param.files is a space-separated list of file names of -->
  <!-- * XSL files that contain param instances -->
  <xsl:param name="param.files"/>

  <xsl:template match="/">
    <xsl:text>&#xa;</xsl:text>
    <xsl:element name="{$result.root.element}">
      <xsl:text>&#xa;</xsl:text>
      <!-- * The following calls to the process.file template each pass data -->
      <!-- * from a *.files param split into two parts: the part before the -->
      <!-- * first space (the first filenames in the list), and the part -->
      <!-- * after (all the other filenames) -->

      <!-- * process the param files -->
      <xsl:call-template name="process.file">
        <xsl:with-param name="element">param</xsl:with-param>
        <xsl:with-param name="file">
          <xsl:choose>
            <xsl:when test="contains($param.files, ' ')">
              <xsl:value-of select="normalize-space(substring-before($param.files, ' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$param.files"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param
            name="remaining.files"
            select="concat(normalize-space(substring-after($param.files, ' ')),' ')"/>
      </xsl:call-template>

      <!-- * process the element files -->
      <xsl:call-template name="process.file">
        <xsl:with-param name="element">element</xsl:with-param>
        <xsl:with-param name="file">
          <xsl:choose>
            <xsl:when test="contains($element.files, ' ')">
              <xsl:value-of select="normalize-space(substring-before($element.files, ' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$element.files"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param
            name="remaining.files"
            select="concat(normalize-space(substring-after($element.files, ' ')),' ')"/>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <xsl:template name="process.file">
    <!-- * This template does tail-recursion through a space-separated -->
    <!-- * list of filenames, popping off filenames until it depletes the -->
    <!-- * list. For each filename, it looks through the file for any -->
    <!-- * elements matching the name given by $element, then runs -->
    <!-- * apply-templates on that. -->
    <xsl:param name="element"/>
    <xsl:param name="file"/>
    <xsl:param name="remaining.files"/>
    <!-- * When the value of $file reaches empty, then we have depleted -->
    <!-- * the list of filenames and it is time to stop recursing -->
    <xsl:if test="not($file = '')">
      <!-- * Only process elements that have a "name" attribute and  -->
      <!-- * that are not in our list of "stop words" (common words -->
      <!-- * that we don't want want to handle as terms. FIXME: -->
      <!-- * ideally, the list of stop words probably ought to be -->
      <!-- * parameterized somehow; but this works fine for now. -->
      <xsl:for-each
          select="document($file)//*[local-name() = $element]
                  [@name
                  and not(@name = 'set')
                  and not(@name = 'part')
                  and not(@name = 'parameter')
                  and not(@name = 'optional')
                  and not(@name = 'note')
                  and not(@name = 'example')
                  and not(@name = 'warning')
                  and not(@name = 'type')
                  and not(@name = 'markup')
                  ]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:call-template name="process.file">
        <xsl:with-param name="element">param</xsl:with-param>
        <!-- * pop the name of the next file off the list of -->
        <!-- * remaining files -->
        <xsl:with-param
            name="file"
            select="substring-before($remaining.files, ' ')"/>
        <!-- * remove the current file from the list of -->
        <!-- * remaining files -->
        <xsl:with-param
            name="remaining.files"
            select="substring-after($remaining.files, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*">
    <!-- * For each match, add an element to the result tree, with the -->
    <!-- * name of the element being the local name of the element in the -->
    <!-- * source, and the content being the value of the "name" attribute -->
    <!-- * on the element in the original source. -->
    <xsl:element name="{local-name(.)}"><xsl:value-of select="@name"/></xsl:element>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
