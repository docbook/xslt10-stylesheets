<?xml version='1.0'?> <!-- -*- nxml -*- -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fm="http://freshmeat.net/projects/freshmeat-submit/"
		xmlns:sf="http://sourceforge.net/"
		exclude-result-prefixes="fm sf"
                version='1.0'>

<xsl:param name="version" select="''"/>
<xsl:param name="branch" select="'Simplified DocBook'"/>

<xsl:strip-space elements="fm:*"/>

<fm:project>
  <fm:Project>DocBook</fm:Project>
  <fm:Branch>{BRANCH}</fm:Branch>
  <fm:Version>{VERSION}</fm:Version>
  <fm:Release-Focus>
  <!-- initial freshmeat announcement -->
  <!-- documentation -->
  <!-- code cleanup -->
  <!--minor feature enhancements -->
  <!-- major feature enhancements -->
  Minor bugfixes
  <!-- major bugfixes -->
  <!-- minor security fixes -->
  <!-- major security fixes -->
  </fm:Release-Focus>
  <fm:Home-Page-URL>http://docbook.org/xml/simple/{VERSION}/</fm:Home-Page-URL>
  <fm:Zipped-Tar-URL>http://docbook.org/xml/simple/{VERSION}/docbook-simple-{VERSION}.zip</fm:Zipped-Tar-URL>
  <fm:Changelog-URL>http://docbook.org/xml/simple/{VERSION}/ChangeLog</fm:Changelog-URL>
  <fm:CVS-URL>http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/docbook/docbook/xml/simple/</fm:CVS-URL>
  <fm:Mailing-List-URL>http://lists.oasis-open.org/archives/docbook/</fm:Mailing-List-URL>
  <fm:Changes>Simplified DocBook V1.1 is an official release. It contains
no technical changes from V1.1CR2.
  </fm:Changes>  
</fm:project>

<xsl:template match="/" priority="-100">
  <xsl:if test="$version = ''">
    <xsl:message terminate="yes">
      <xsl:text>You must specify the version.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:apply-templates select="//fm:project"/>
</xsl:template>

<xsl:template match="fm:project">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="fm:Changes" mode="text"/>
</xsl:template>

<xsl:template match="fm:Changes"/>

<xsl:template match="fm:*">
  <xsl:value-of select="local-name(.)"/>
  <xsl:text>: </xsl:text>
  <xsl:call-template name="value">
    <xsl:with-param name="text" select="normalize-space(.)"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="value">
  <xsl:param name="text"/>

  <xsl:variable name="sub-version">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$text"/>
      <xsl:with-param name="target" select="'{VERSION}'"/>
      <xsl:with-param name="replacement" select="$version"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$sub-version"/>
    <xsl:with-param name="target" select="'{BRANCH}'"/>
    <xsl:with-param name="replacement" select="$branch"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="string.subst">
  <xsl:param name="string"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>

  <xsl:choose>
    <xsl:when test="contains($string, $target)">
      <xsl:variable name="rest">
        <xsl:call-template name="string.subst">
          <xsl:with-param name="string" select="substring-after($string, $target)"/>
          <xsl:with-param name="target" select="$target"/>
          <xsl:with-param name="replacement" select="$replacement"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat(substring-before($string, $target),                                    $replacement,                                    $rest)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
