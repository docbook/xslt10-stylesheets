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
        <xsl:copy-of select="@*[not(name(.) = 'xml:id')]"/>
	<xsl:if test="@xml:id">
	  <xsl:attribute name="id">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	</xsl:if>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*[not(name(.) = 'xml:id')]"/>
	<xsl:if test="@xml:id">
	  <xsl:attribute name="id">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	</xsl:if>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:info" mode="stripNS">
  <xsl:variable name="info">
    <xsl:choose>
      <xsl:when test="parent::db:article
	              |parent::db:appendix
	              |parent::db:bibliography
	              |parent::db:book
	              |parent::db:chapter
	              |parent::db:glossary
	              |parent::db:index
	              |parent::db:part
	              |parent::db:preface
	              |parent::db:refentry
	              |parent::db:reference
	              |parent::db:refsect1
	              |parent::db:refsect2
	              |parent::db:refsect3
	              |parent::db:refsection
	              |parent::db:refsynopsisdiv
	              |parent::db:sect1
	              |parent::db:sect2
	              |parent::db:sect3
	              |parent::db:sect4
	              |parent::db:sect5
	              |parent::db:section
	              |parent::db:setindex
	              |parent::db:set
	              |parent::db:sidebar">
	<xsl:value-of select="local-name(parent::*)"/>
	<xsl:text>info</xsl:text>
      </xsl:when>
      <xsl:when test="parent::db:audioobject
	              |parent::db:imageobject
	              |parent::db:inlinemediaobject
	              |parent::db:mediaobject
	              |parent::db:mediaobjectco
	              |parent::db:textobject
	              |parent::db:videoobject">
	<xsl:text>objectinfo</xsl:text>
      </xsl:when>
      <xsl:otherwise>blockinfo</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$info}">
    <xsl:copy-of select="@*[not(name(.) = 'xml:id')]"/>
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="stripNS"/>
  </xsl:element>
</xsl:template>

<xsl:template match="ng:link|db:link" mode="stripNS">
  <xsl:variable xmlns:xlink="http://www.w3.org/1999/xlink"
		name="href" select="@xlink:href|@href"/>
  <xsl:choose>
    <xsl:when test="$href != '' and not(starts-with($href,'#'))">
      <ulink url="{$href}">
	<xsl:for-each select="@*">
	  <xsl:if test="local-name(.) != 'href' and name(.) != 'xml:id'">
	    <xsl:copy/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:if test="@xml:id">
	  <xsl:attribute name="id">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:apply-templates mode="stripNS"/>
      </ulink>
    </xsl:when>
    <xsl:when test="$href != '' and starts-with($href,'#')">
      <link linkend="{substring-after($href,'#')}">
	<xsl:for-each select="@*">
	  <xsl:if test="local-name(.) != 'href' and name(.) != 'xml:id'">
	    <xsl:copy/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:if test="@xml:id">
	  <xsl:attribute name="id">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:apply-templates mode="stripNS"/>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <link>
        <xsl:copy-of select="@*[not(name(.) = 'xml:id')]"/>
	<xsl:if test="@xml:id">
	  <xsl:attribute name="id">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	</xsl:if>
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
    <xsl:copy-of select="@*[not(name(.) = 'xml:id')]"/>
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
	<xsl:value-of select="@xml:id"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@fileref
	              and not(contains(@fileref,':'))
		      and not(starts-with(@fileref,'/'))
		      and function-available('saxon:systemId')">
	<xsl:attribute name="xml:base">
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
	<xsl:attribute name="xml:base">
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
