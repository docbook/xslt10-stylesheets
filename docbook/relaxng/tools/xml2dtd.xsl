<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:dtd="http://nwalsh.com/xmlns/dtd/"
		exclude-result-prefixes="exsl dtd"
		version="1.0">

<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:param name="ns" select="'http://docbook.org/ns/docbook'"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dtd:dtd">
  <!-- put the PEs first -->
  <xsl:apply-templates select="dtd:pe"/>
  <xsl:apply-templates select="*[not(self::dtd:pe)]"/>
</xsl:template>

<xsl:template match="dtd:element">
  <xsl:text>&lt;!ELEMENT </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text> </xsl:text>

  <!-- it's late and I'm tired, I wonder if there's an easier way to -->
  <!-- remove duplicates. note that they aren't at the same level -->

  <xsl:variable name="elemsNS">
    <xsl:for-each select=".//dtd:ref">
      <elem name="{@name}"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="elems" select="exsl:node-set($elemsNS)/elem"/>

  <xsl:choose>
    <xsl:when test=".//dtd:PCDATA">
      <xsl:text>(#PCDATA</xsl:text>
      <xsl:for-each select="$elems">
	<xsl:variable name="name" select="@name"/>
	<xsl:if test="not(preceding-sibling::elem[@name=$name])">
	  <xsl:text>|</xsl:text>
	  <xsl:value-of select="@name"/>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>)*</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&gt;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtd:attlist">
  <xsl:text>&lt;!ATTLIST </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>&#9;xmlns&#9;CDATA&#9;#FIXED&#9;"</xsl:text>
  <xsl:value-of select="$ns"/>
  <xsl:text>"&#10;</xsl:text>

  <xsl:apply-templates/>
  <xsl:text>&#10;&gt;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtd:pe">
  <xsl:text>&lt;!ENTITY % </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text> "&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;"&gt;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtd:attribute">
  <xsl:variable name="name" select="@name"/>
  <xsl:variable name="next" select="following-sibling::dtd:attribute"/>
  <xsl:variable name="prev" select="preceding-sibling::dtd:attribute"/>

  <xsl:choose>
    <xsl:when test="$prev[@name = $name]">
      <!--
      <xsl:message>
	<xsl:text>Warning: duplicate attribute (</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> on </xsl:text>
	<xsl:value-of select="../@name"/>
	<xsl:text>)</xsl:text>
      </xsl:message>
      -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#9;</xsl:text>
      <xsl:choose>
	<xsl:when test="@type">
	  <xsl:choose>
	    <xsl:when test="@type = 'anyURI'">CDATA</xsl:when>
	    <xsl:when test="@type = 'integer'">NMTOKEN</xsl:when>
	    <xsl:when test="@type = 'token'">NMTOKEN</xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="@type"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:when test="@occurs='fixed'">
	  <xsl:text>CDATA&#9;#FIXED&#9;'</xsl:text>
	  <xsl:value-of select="."/>
	  <xsl:text>'</xsl:text>
	</xsl:when>
	<xsl:when test="string-length(.) != 0">
	  <!-- handle the special case of duplicate lists, etc. -->
	  <xsl:choose>
	    <xsl:when test="$next[@name=$name]">
	      <xsl:text>(</xsl:text>
	      <xsl:call-template name="merge-values">
		<xsl:with-param name="values"
				select="../dtd:attribute[@name = $name]"/>
	      </xsl:call-template>
	      <xsl:text>)</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="."/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>CDATA</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#9;</xsl:text>
      <xsl:choose>
	<xsl:when test="@default">
	  <xsl:text>"</xsl:text>
	  <xsl:value-of select="@default"/>
	  <xsl:text>"</xsl:text>
	</xsl:when>
	<xsl:when test="@occurs='optional'">
	  <xsl:text>#IMPLIED</xsl:text>
	</xsl:when>
	<xsl:when test="@occurs='fixed'">
	  <!-- nop; handled above -->
	</xsl:when>
	<xsl:otherwise>#REQUIRED</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtd:peref">
  <xsl:text>&#9;%</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>;&#10;</xsl:text>
</xsl:template>

<xsl:template match="dtd:group">
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:if test="position() &gt; 1">, </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
  <xsl:value-of select="@repeat"/>
</xsl:template>

<xsl:template match="dtd:choice">
  <xsl:choose>
    <xsl:when test="not(*)">
      <xsl:text>(#PCDATA)*</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:for-each select="*">
	<xsl:if test="position() &gt; 1">|</xsl:if>
	<xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:value-of select="@repeat"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dtd:ref">
  <xsl:value-of select="@name"/>
  <xsl:value-of select="@repeat"/>
</xsl:template>

<xsl:template match="dtd:EMPTY">
  <xsl:text>EMPTY</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="merge-values">
  <xsl:param name="values"/>
  <xsl:param name="value" select="$values[1]"/>
  <xsl:param name="list" select="'|'"/>

  <xsl:variable name="newlist">
    <xsl:call-template name="merge-lists">
      <xsl:with-param name="list" select="$list"/>
      <xsl:with-param name="value"
		      select="substring-before(substring-after($value,'('),')')"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <xsl:message>
    <xsl:text>merge: </xsl:text>
    <xsl:value-of select="count($values)"/>
    <xsl:text>: </xsl:text>

    <xsl:text>(</xsl:text>
    <xsl:value-of select="$list"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$value"/>
    <xsl:text>) </xsl:text>

    <xsl:value-of select="$newlist"/>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="count($values) &gt; 1">
      <xsl:call-template name="merge-values">
	<xsl:with-param name="values" select="$values[position() &gt; 1]"/>
	<xsl:with-param name="list" select="$newlist"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- trim off the leading and trainling |'s -->
      <xsl:value-of select="substring($newlist,2,string-length($newlist)-2)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="merge-lists">
  <xsl:param name="list" select="$list"/>
  <xsl:param name="value" select="$value"/>

  <xsl:variable name="first">
    <xsl:choose>
      <xsl:when test="contains($value, '|')">
	<xsl:value-of select="substring-before($value, '|')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="rest">
    <xsl:choose>
      <xsl:when test="contains($value, '|')">
	<xsl:value-of select="substring-after($value, '|')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>list: <xsl:value-of select="$list"/></xsl:message>
  <xsl:message>first: <xsl:value-of select="$first"/></xsl:message>
  <xsl:message>rest: <xsl:value-of select="$rest"/></xsl:message>
-->

  <xsl:choose>
    <xsl:when test="$value = ''">
      <xsl:value-of select="$list"/>
    </xsl:when>
    <xsl:when test="contains($list, concat('|',$first,'|'))">
      <xsl:call-template name="merge-lists">
	<xsl:with-param name="list" select="$list"/>
	<xsl:with-param name="value" select="$rest"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="merge-lists">
	<xsl:with-param name="list" select="concat($list,$first,'|')"/>
	<xsl:with-param name="value" select="$rest"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

