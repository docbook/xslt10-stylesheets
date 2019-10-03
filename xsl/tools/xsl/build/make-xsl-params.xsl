<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:xslt="dummy"
                version="1.0">
  <xsl:output indent="yes"/>
  <xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>
  <!-- ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or https://cdn.docbook.org/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- ==================================================================== -->

  <!-- * This stylesheet expects itself as input  -->
  <xsl:param name="param.dirs">html fo manpages roundtrip slides/fo slides/xhtml website</xsl:param>

  <xsl:template match="/">
    <xslt:stylesheet version="1.0"> 
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * This stylesheet was generated automatically. </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * Edit the make-xsl-params.xsl file to rebuild this. </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> * WARNING WARNING WARNING </xsl:comment>

      <!-- * Process params for each output format listed in $param.dirs -->
      <!-- * by splitting the value of $param.dirs into two parts: the part -->
      <!-- * before the first space (first directory name in the list), and -->
      <!-- * the part after the first space (all other directory names) -->
      <xsl:call-template name="make.param.list">
        <xsl:with-param name="dir">
          <xsl:choose>
            <xsl:when test="contains($param.dirs, ' ')">
              <xsl:value-of select="normalize-space(substring-before($param.dirs, ' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$param.dirs"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param
            name="remaining.dirs"
            select="concat(normalize-space(substring-after($param.dirs, ' ')),' ')"/>
      </xsl:call-template>
      <xsl:call-template name="make.is.parameter.template">
        <xsl:with-param name="dir">
          <xsl:choose>
            <xsl:when test="contains($param.dirs, ' ')">
              <xsl:value-of select="normalize-space(substring-before($param.dirs, ' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$param.dirs"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param
            name="remaining.dirs"
            select="concat(normalize-space(substring-after($param.dirs, ' ')),' ')"/>
      </xsl:call-template>
    </xslt:stylesheet>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <!-- ==================================================================== -->

  <!-- * The following templates do tail-recursion through a space-separated -->
  <!-- * list of directories, popping off directory names until they -->
  <!-- * deplete the list. -->
  
  <xsl:template name="make.param.list">
    <!-- * For each directory, construct a relative URL for a -->
    <!-- * param.xsl file, then read through that param.xsl file -->
    <!-- * to collect parameter names. -->
    <xsl:param name="dir"/>
    <xsl:param name="adjusted-dir">
      <xsl:call-template name="make.adjusted-dir">
        <xsl:with-param name="dir" select="$dir"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:param name="remaining.dirs"/>
    <!-- * When the value of $dir reaches empty, then we have depleted -->
    <!-- * the list of directories and it's time to stop recursing -->
    <xsl:if test="not($dir = '')">
      <xsl:variable name="param.xsl" select="concat('../../../', $dir, '/', 'param.xsl')"/>
      <xslt:variable name="xsl-{$adjusted-dir}-parameters-list">
        <simplelist role="param">
          <xsl:for-each select="document($param.xsl)//*[local-name() = 'param' or local-name() = 'attribute-set']">
            <xsl:sort select="@name"/>
            <member><xsl:value-of select="@name"/></member>
          </xsl:for-each>
        </simplelist>
      </xslt:variable>
      <xslt:variable name="xsl-{$adjusted-dir}-parameters"
                     select="exsl:node-set($xsl-{$adjusted-dir}-parameters-list)/simplelist"/>
      <xsl:call-template name="make.param.list">
        <!-- * pop the name of the next directory off the list of -->
        <!-- * remaining directories -->
        <xsl:with-param
            name="dir"
            select="substring-before($remaining.dirs, ' ')"/>
        <!-- * remove the current directory from the list of -->
        <!-- * remaining directories -->
        <xsl:with-param
            name="remaining.dirs"
            select="substring-after($remaining.dirs, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make.is.parameter.template">
    <xsl:param name="dir"/>
    <xsl:param name="adjusted-dir">
      <xsl:call-template name="make.adjusted-dir">
        <xsl:with-param name="dir" select="$dir"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:param name="remaining.dirs"/>
    <xsl:if test="not($dir = '')">
      <!-- * for each directory, construct a template. -->
      <xslt:template name="is-{$adjusted-dir}-parameter">
        <xslt:param name="param" select="''"/>
        <xslt:choose>
          <xslt:when test="$xsl-{$adjusted-dir}-parameters/member[. = $param]">1</xslt:when>
          <xslt:otherwise>0</xslt:otherwise>
        </xslt:choose>
      </xslt:template>
      <xsl:call-template name="make.is.parameter.template">
        <!-- * pop the name of the next directory off the list of -->
        <!-- * remaining directories -->
        <xsl:with-param
            name="dir"
            select="substring-before($remaining.dirs, ' ')"/>
        <!-- * remove the current directory from the list of -->
        <!-- * remaining directories -->
        <xsl:with-param
            name="remaining.dirs"
            select="substring-after($remaining.dirs, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make.adjusted-dir">
    <xsl:param name="dir"/>
    <xsl:param name="basedir">
      <xsl:value-of select="substring-before($dir, '/')"/>
    </xsl:param>
    <xsl:param name="subdir">
      <xsl:value-of select="substring-after($dir, '/')"/>
    </xsl:param>
      <xsl:choose>
        <xsl:when test="contains($dir,'/')">
          <xsl:value-of select="concat($basedir,'-',$subdir)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$dir"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
