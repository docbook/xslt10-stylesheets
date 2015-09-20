<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
		xmlns:doc="http://nwalsh.com/xsl/documentation"
		exclude-result-prefixes="l doc"
		version='1.0'>
  
  <xsl:output method="xml"
	      indent="yes"
	      />

  <!-- $Id$ -->

  <!-- cldr2dbk.xsl - convert CLDR locale data to DocBook locale format -->

  <!-- For information about the Common Locale Data Repository (CLDR) -->
  <!-- Project, see: -->
  <!-- http://www.unicode.org/cldr/ -->

  <!-- CLDR uses two files for some locales; for example, both an af.xml and -->
  <!-- af_ZA.xml file. Data seems to be spread out between the files, so we -->
  <!-- need to check both -->
  <xsl:param name="cldrfile"></xsl:param>
  <xsl:param name="altcldrfile"></xsl:param>
  <xsl:param name="contextname"></xsl:param>

  
  <xsl:template match="/">
    
    <!-- first check each CLDR file for date-format data -->
    <xsl:choose>
      <xsl:when test="document($cldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/dateFormats">
	<xsl:call-template name="getDateFormat">
	  <xsl:with-param name="file" select="$cldrfile"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="document($altcldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/dateFormats">
	<xsl:call-template name="getDateFormat">
	  <xsl:with-param name="file" select="$altcldrfile"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>&#10;WARNING: Could not find date-format data.&#10;</xsl:message>
	<xsl:message>&#10;Tried:&#10;</xsl:message>
	<xsl:message><xsl:value-of select="$cldrfile"/></xsl:message>
	<xsl:message><xsl:value-of select="$altcldrfile"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- next check each CLDR file for month- and day-names data -->
    <xsl:choose>
      <xsl:when test="document($cldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/months and
		      document($cldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/days">
	<xsl:call-template name="getMonthDay">
	  <xsl:with-param name="file" select="$cldrfile"/>
	  <xsl:with-param name="width" select="'wide'"/>
	  <xsl:with-param name="contextname" select="'datetime-full'"/>
	</xsl:call-template>
	<xsl:call-template name="getMonthDay">
	  <xsl:with-param name="file" select="$cldrfile"/>
	  <xsl:with-param name="width" select="'abbreviated'"/>
	  <xsl:with-param name="contextname" select="'datetime-abbrev'"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="document($altcldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/months and
		      document($altcldrfile)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/days">
	<xsl:call-template name="getMonthDay">
	  <xsl:with-param name="file" select="$altcldrfile"/>
	  <xsl:with-param name="width" select="'wide'"/>
	  <xsl:with-param name="contextname" select="'datetime-full'"/>
	</xsl:call-template>
	<xsl:call-template name="getMonthDay">
	  <xsl:with-param name="file" select="$altcldrfile"/>
	  <xsl:with-param name="width" select="'abbreviated'"/>
	  <xsl:with-param name="contextname" select="'datetime-abbrev'"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>&#10;WARNING: Could not find month and/or day data.&#10;</xsl:message>
	<xsl:message>&#10;Tried:&#10;</xsl:message>
	<xsl:message><xsl:value-of select="$cldrfile"/></xsl:message>
	<xsl:message><xsl:value-of select="$altcldrfile"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 
  
  <!-- ============================================================================ -->
  
  <xsl:template name="getDateFormat">
    <xsl:param name="file"></xsl:param>
    <xsl:for-each select="//context[@name = 'datetime']">
      <context name="datetime">
	<template name="format">
	  <xsl:value-of
	      select="document($file)/ldml/dates/calendars/calendar[@type
		      = 'gregorian']/dateFormats/dateFormatLength[@type
		      = 'long']/dateFormat/pattern"/>
	</template>
      </context>
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template  name="getMonthDay">
    <xsl:param name="file"></xsl:param>
    <xsl:param name="width"></xsl:param>
    <xsl:param name="contextname"></xsl:param>
    <xsl:for-each select="//context[@name = $contextname]">
      <context>
	<xsl:attribute name="name">
	  <xsl:value-of select="$contextname"/>
	</xsl:attribute>
	<xsl:for-each select="template">
	  <template>
	    <xsl:attribute name="name">
		<xsl:value-of select="@name"/>
	    </xsl:attribute>
	    
	    <!-- DocBook locale schema groupse day names together with -->
	    <!-- month names, but CLDR groups them separately; we need to -->
	    <!-- deal with first 12 calls to this template differently -->
	    <!-- than the last 7 -->
	    <xsl:choose>
	      <!-- first get month names -->
	      <xsl:when test="position() &lt; 13">
		<xsl:variable name="position" select="position()"/>
		<xsl:value-of
		    select="document($file)/ldml/dates/calendars/calendar[@type
			    = 'gregorian']/months/monthContext[@type 
			    = 'format']/monthWidth[@type
			    = $width]/month[$position]"/>
	      </xsl:when>
	      <xsl:otherwise>
		<!-- then get day names -->
		<xsl:variable name="position" select="position() - 12"/>
		<xsl:value-of
		    select="document($file)/ldml/dates/calendars/calendar[@type
			    = 'gregorian']/days/dayContext[@type 
			    = 'format']/dayWidth[@type
			    = $width]/day[$position]"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </template>
	</xsl:for-each>
      </context>
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
