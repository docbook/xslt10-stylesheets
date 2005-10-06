<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ng="http://docbook.org/docbook-ng"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="db ng saxon"
                version='1.0'>

<xsl:template match="*" mode="stripNS">
  <xsl:choose>
    <xsl:when test="self::ng:* or self::db:*">
      <xsl:element name="{local-name(.)}">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ng:link|db:link" mode="stripNS">
  <xsl:variable xmlns:xlink="http://www.w3.org/1999/xlink"
		name="href" select="@xlink:href|@href"/>
  <xsl:choose>
    <xsl:when test="$href != '' and not(starts-with($href,'#'))">
      <ulink url="{$href}">
	<xsl:for-each select="@*">
	  <xsl:if test="local-name(.) != 'href'">
	    <xsl:copy/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:apply-templates mode="stripNS"/>
      </ulink>
    </xsl:when>
    <xsl:when test="$href != '' and starts-with($href,'#')">
      <link linkend="{substring-after($href,'#')}">
	<xsl:for-each select="@*">
	  <xsl:if test="local-name(.) != 'href'">
	    <xsl:copy/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:apply-templates mode="stripNS"/>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <link>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="stripNS"/>
      </link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ng:textdata|db:textdata
		     |ng:imagedata|db:imagedata
		     |ng:videodata|db:videodata
		     |ng:audiodata|db:audiodata" mode="stripNS">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*[name(.) != 'fileref' and name(.) != 'entityref']"/>

    <xsl:choose>
      <xsl:when test="@fileref
	              and not(contains(@fileref,':'))
		      and not(starts-with(@fileref,'/'))
		      and function-available('saxon:systemId')">
	<xsl:attribute name="fileref">
	  <xsl:call-template name="systemIdToBaseURI">
	    <xsl:with-param name="systemId">
	      <xsl:choose>
		<!-- file: seems to confuse some processors. -->
		<xsl:when test="starts-with(saxon:systemId(), 'file:')">
		  <xsl:value-of select="substring-after(saxon:systemId(),
					                'file:')"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="saxon:systemId()"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:with-param>
	  </xsl:call-template>
	  <xsl:value-of select="@fileref"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="fileref">
	  <xsl:value-of select="@fileref"/>
	</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="@entityref">
	<xsl:attribute name="fileref">
	  <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
	</xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:apply-templates mode="stripNS"/>
  </xsl:element>
</xsl:template>

<xsl:template name="systemIdToBaseURI">
  <xsl:param name="systemId" select="''"/>
  <xsl:if test="contains($systemId,'/')">
    <xsl:value-of select="substring-before($systemId,'/')"/>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="systemIdToBaseURI">
      <xsl:with-param name="systemId"
		      select="substring-after($systemId,'/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="stripNS">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
