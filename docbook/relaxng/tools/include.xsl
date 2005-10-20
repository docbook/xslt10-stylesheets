<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:ctrl="http://nwalsh.com/xmlns/schema-control/"
                exclude-result-prefixes="exsl ctrl"
                version="1.0">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>
  <xsl:key name="combines" match="rng:define[@combine='choice']" use="@name"/>
  <xsl:key name="interleaves"
	   match="rng:define[@combine='interleave']"
	   use="@name"/>
  <xsl:key name="overrides" match="rng:define[@override]" use="@name"/>

  <xsl:template match="/">
    <xsl:variable name="expanded">
      <xsl:apply-templates mode="include"/>
    </xsl:variable>

    <xsl:variable name="conditional">
      <xsl:apply-templates select="exsl:node-set($expanded)/*"
			   mode="conditional"/>
    </xsl:variable>

    <xsl:variable name="overridden">
      <xsl:apply-templates select="exsl:node-set($conditional)/*"
			   mode="override"/>
    </xsl:variable>

    <xsl:apply-templates select="exsl:node-set($overridden)/*"
			 mode="combine"/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:include" mode="include">
    <xsl:variable name="doc" select="document(@href,.)"/>

    <xsl:variable name="nestedGrammar">
      <xsl:apply-templates select="$doc/rng:grammar/*" mode="include"/>
      <xsl:apply-templates mode="markOverride"/>
    </xsl:variable>

    <xsl:apply-templates select="exsl:node-set($nestedGrammar)/*"
			 mode="override"/>

    <xsl:message>Included <xsl:value-of select="@href"/></xsl:message>
  </xsl:template>

  <xsl:template match="*" mode="include">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="include"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="include">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="*" mode="markOverride">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="parent::rng:include">
	<xsl:if test="not(self::rng:define) and not(self::rng:start)">
	  <xsl:message>
	    <xsl:text>Warning: only expecting rng:define children </xsl:text>
	    <xsl:text>of rng:include (got </xsl:text>
	    <xsl:value-of select="name(.)"/>
	    <xsl:text>)</xsl:text>
	  </xsl:message>
	</xsl:if>

	<xsl:if test="not(@combine)
		      or (@combine != 'choice' and @combine != 'interleave')">
	  <xsl:message>Adding override to <xsl:value-of select="@name"/></xsl:message>
	  <xsl:attribute name="override">
	    <xsl:value-of select="parent::rng:include/@href"/>
	  </xsl:attribute>
	</xsl:if>
      </xsl:if>
      <xsl:apply-templates mode="markOverride"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="markOverride">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:define" mode="combine">
    <xsl:choose>
      <xsl:when test="@combine = 'choice'"/>
      <xsl:when test="@combine = 'interleave'"/>
      <xsl:when test="@combine">
	<!-- what's this!? -->
	<xsl:message>
	  <xsl:text>Warning: unexpected combine on rng:define for </xsl:text>
	  <xsl:value-of select="@name"/>
	</xsl:message>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="combine"/>
	</xsl:copy>
      </xsl:when>

      <xsl:otherwise>
	<xsl:variable name="choices" select="key('combines', @name)"/>
	<xsl:variable name="ileaves" select="key('interleaves', @name)"/>
	<xsl:choose>
	  <xsl:when test="$choices and $ileaves">
	    <xsl:message>
	      <xsl:text>Warning: choice and interleave for </xsl:text>
	      <xsl:value-of select="@name"/>
	    </xsl:message>
	  </xsl:when>
	  <xsl:when test="$ileaves">
	    <!-- these are always attributes, right? -->
	    <xsl:message>
	      <xsl:text>Interleaving definitions for </xsl:text>
	      <xsl:value-of select="@name"/>
	    </xsl:message>

	    <xsl:if test="not(rng:interleave) or count(*) &gt; 1">
	      <xsl:message>
		<xsl:text>Unexpected content for </xsl:text>
		<xsl:value-of select="@name"/>
	      </xsl:message>
	    </xsl:if>

	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <rng:interleave>
		<xsl:apply-templates select="rng:interleave/*" mode="combine"/>
		<xsl:apply-templates select="$ileaves/*" mode="combine"/>
	      </rng:interleave>
	    </xsl:copy>
	  </xsl:when>
	  <xsl:when test="$choices">
	    <xsl:message>
	      <xsl:text>Combining definitions for </xsl:text>
	      <xsl:value-of select="@name"/>
	    </xsl:message>

	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <rng:choice>
		<xsl:apply-templates mode="combine"/>
		<xsl:for-each select="$choices">
		  <xsl:choose>
		    <xsl:when test="count(*) &gt; 1">
		      <!-- implicit group -->
		      <rng:group>
			<xsl:apply-templates select="*" mode="combine"/>
		      </rng:group>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:apply-templates select="*" mode="combine"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:for-each>
	      </rng:choice>
	    </xsl:copy>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <xsl:apply-templates mode="combine"/>
	    </xsl:copy>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:start" mode="combine">
    <xsl:choose>
      <xsl:when test="@combine = 'choice'"/>
      <xsl:when test="@combine">
	<!-- what's this!? -->
	<xsl:message>
	  <xsl:text>Warning: unexpected combine on rng:start</xsl:text>
	</xsl:message>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="combine"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="choices" select="//rng:start[@combine='choice']"/>
	<xsl:choose>
	  <xsl:when test="$choices">
	    <xsl:message>
	      <xsl:text>Combining start definitions</xsl:text>
	    </xsl:message>

	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <rng:choice>
		<xsl:apply-templates mode="combine"/>
		<xsl:apply-templates select="$choices/*" mode="combine"/>
	      </rng:choice>
	    </xsl:copy>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy>
	      <xsl:copy-of select="@*"/>
	      <xsl:apply-templates mode="combine"/>
	    </xsl:copy>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="combine">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="combine"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()" mode="combine">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="ctrl:conditional" mode="conditional">
    <xsl:variable name="pat" select="@pattern"/>

    <xsl:choose>
      <xsl:when test="//rng:define[@name = $pat]">
	<xsl:message>
	  <xsl:text>Including conditional pattern=</xsl:text>
	  <xsl:value-of select="$pat"/>
	</xsl:message>
	<xsl:apply-templates mode="conditional"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
	  <xsl:text>Excluding conditional pattern=</xsl:text>
	  <xsl:value-of select="$pat"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="conditional">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="conditional"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()"
		mode="conditional">
    <xsl:copy/>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="rng:start" mode="override">
    <xsl:choose>
      <xsl:when test="@override">
	<xsl:copy>
	  <xsl:copy-of select="@*[name(.) != 'override']"/>
	  <xsl:apply-templates mode="override"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="//rng:start[@override]">
	<xsl:message>
	  <xsl:text>Suppressing original definition of start</xsl:text>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="override"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:define" mode="override">
    <xsl:variable name="over" select="key('overrides', @name)"/>
    <xsl:choose>
      <xsl:when test="@override">
	<xsl:copy>
	  <xsl:copy-of select="@*[name(.) != 'override']"/>
	  <xsl:apply-templates mode="override"/>
	</xsl:copy>
      </xsl:when>
      <xsl:when test="$over">
	<xsl:message>
	  <xsl:text>Suppressing original definition of </xsl:text>
	  <xsl:value-of select="@name"/>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="override"/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="override">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="override"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()|text()"
		mode="override">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
