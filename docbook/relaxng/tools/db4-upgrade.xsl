<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		xmlns:db = "http://docbook.org/docbook-ng"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="exsl db"
                version="1.0">

<!-- ======================================================================
# This file is part of DocBook NG: The "Gin" Release.
# A prototype DocBook V4.2 to DocBoook V.next converter.
#
# This stylesheet is a "work-in-progress". It converts (some) valid
# DocBook V4.2 instances to instances that are valid DocBook-like
# instances as defined by docbook.rnc. It doesn't (yet) work for every
# valid DocBook V4.2 instance and it may never.
#
# At the moment, it's just an exploration by Norm. It has utterly no normative
# value at all.
#
# Author: Norman Walsh, <ndw@nwalsh.com>
# Release: $Id$
#
====================================================================== -->

<xsl:output method="xml" encoding="utf-8" indent="no"/>
<xsl:preserve-space elements="*"/>

<xsl:param name="defaultDate" select="'1970-01-01'"/>

<xsl:template match="/">
  <xsl:variable name="converted">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:apply-templates select="exsl:node-set($converted)/*" mode="addNS"/>
</xsl:template>

<xsl:template match="bookinfo|chapterinfo|articleinfo|artheader|appendixinfo
		     |blockinfo
                     |bibliographyinfo|glossaryinfo|indexinfo|setinfo
		     |setindexinfo
                     |sect1info|sect2info|sect3info|sect4info|sect5info
                     |sectioninfo
                     |refsect1info|refsect2info|refsect3info|refsectioninfo
		     |referenceinfo|partinfo"
              priority="200">
  <info>
    <xsl:call-template name="copy.attributes"/>

    <!-- titles can be inside or outside or both. fix that -->
    <xsl:choose>
      <xsl:when test="title and following-sibling::title">
        <xsl:if test="title != following-sibling::title">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> title.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="title" mode="copy"/>
      </xsl:when>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::title">
        <xsl:apply-templates select="following-sibling::title" mode="copy"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Check </xsl:text>
          <xsl:value-of select="name(..)"/>
          <xsl:text>: no title.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="titleabbrev and following-sibling::titleabbrev">
        <xsl:if test="titleabbrev != following-sibling::titleabbrev">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> titleabbrev.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
      </xsl:when>
      <xsl:when test="titleabbrev">
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::titleabbrev">
        <xsl:apply-templates select="following-sibling::titleabbrev" mode="copy"/>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="subtitle and following-sibling::subtitle">
        <xsl:if test="subtitle != following-sibling::subtitle">
          <xsl:message>
            <xsl:text>Check </xsl:text>
            <xsl:value-of select="name(..)"/>
            <xsl:text> subtitle.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </xsl:when>
      <xsl:when test="subtitle">
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </xsl:when>
      <xsl:when test="following-sibling::subtitle">
        <xsl:apply-templates select="following-sibling::subtitle" mode="copy"/>
      </xsl:when>
    </xsl:choose>

    <xsl:apply-templates/>
  </info>
</xsl:template>

<xsl:template match="refentryinfo"
              priority="200">
  <info>
    <xsl:call-template name="copy.attributes"/>

    <!-- titles can be inside or outside or both. fix that -->
    <xsl:if test="title">
      <xsl:message>Discarding title from refentryinfo!</xsl:message>
    </xsl:if>

    <xsl:if test="titleabbrev">
      <xsl:message>Discarding titleabbrev from refentryinfo!</xsl:message>
    </xsl:if>

    <xsl:if test="subtitle">
      <xsl:message>Discarding subtitle from refentryinfo!</xsl:message>
    </xsl:if>

    <xsl:apply-templates/>
  </info>
</xsl:template>

<xsl:template match="corpauthor" priority="200">
  <author>
    <xsl:call-template name="copy.attributes"/>
    <orgname>
      <xsl:apply-templates/>
    </orgname>
  </author>
</xsl:template>

<xsl:template match="corpname" priority="200">
  <orgname>
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </orgname>
</xsl:template>

<xsl:template match="author[not(personname)]|editor[not(personname)]|othercredit[not(personname)]" priority="200">
  <xsl:copy>
    <xsl:call-template name="copy.attributes"/>
    <personname>
      <xsl:apply-templates select="honorific|firstname|surname|othername|lineage"/>
    </personname>
    <xsl:apply-templates select="*[not(self::honorific|self::firstname|self::surname
                                   |self::othername|self::lineage)]"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="address|programlisting|screen|funcsynopsisinfo
                     |classsynopsisinfo|literallayout" priority="200">
  <xsl:copy>
    <xsl:call-template name="copy.attributes">
      <xsl:with-param name="suppress.format" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="productname[@class]" priority="200">
  <xsl:message>Dropping class attribute from productname</xsl:message>
  <xsl:copy>
    <xsl:call-template name="copy.attributes">
      <xsl:with-param name="suppress.class" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="dedication|preface|chapter|appendix|part|partintro
                     |article|bibliography|glossary|glossdiv|index
                     |book" priority="200">
  <xsl:choose>
    <xsl:when test="not(dedicationinfo|prefaceinfo|chapterinfo|appendixinfo|partinfo
                        |articleinfo|artheader|bibliographyinfo|glossaryinfo|indexinfo
                        |bookinfo)">
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <xsl:if test="title|subtitle|titleabbrev">
          <info>
            <xsl:apply-templates select="title" mode="copy"/>
            <xsl:apply-templates select="titleabbrev" mode="copy"/>
            <xsl:apply-templates select="subtitle" mode="copy"/>
          </info>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="formalpara|figure|table[tgroup]|example|blockquote
                     |caution|important|note|warning|tip
                     |bibliodiv|glossarydiv|indexdiv" priority="200">
  <xsl:choose>
    <xsl:when test="blockinfo">
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <info>
          <xsl:apply-templates select="title" mode="copy"/>
          <xsl:apply-templates select="titleabbrev" mode="copy"/>
          <xsl:apply-templates select="subtitle" mode="copy"/>
        </info>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equation" priority="200">
  <xsl:choose>
    <xsl:when test="not(title)">
      <xsl:message>Convert equation without title to informal equation.</xsl:message>
      <informalequation>
        <xsl:call-template name="copy.attributes"/>
        <xsl:apply-templates/>
      </informalequation>
    </xsl:when>
    <xsl:when test="blockinfo">
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:call-template name="copy.attributes"/>
        <info>
          <xsl:apply-templates select="title" mode="copy"/>
          <xsl:apply-templates select="titleabbrev" mode="copy"/>
          <xsl:apply-templates select="subtitle" mode="copy"/>
        </info>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sect1|sect2|sect3|sect4|sect5|section|simplesect"
	      priority="200">
  <section>
    <xsl:call-template name="copy.attributes"/>

    <xsl:if test="not(sect1info|sect2info|sect3info|sect4info|sect5info|sectioninfo)">
      <info>
        <xsl:apply-templates select="title" mode="copy"/>
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </info>
    </xsl:if>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="refsect1|refsect2|refsect3|refsection" priority="200">
  <refsection>
    <xsl:call-template name="copy.attributes"/>

    <xsl:if test="not(refsect1info|refsect2info|refsect3info|refsectioninfo)">
      <info>
        <xsl:apply-templates select="title" mode="copy"/>
        <xsl:apply-templates select="titleabbrev" mode="copy"/>
        <xsl:apply-templates select="subtitle" mode="copy"/>
      </info>
    </xsl:if>
    <xsl:apply-templates/>
  </refsection>
</xsl:template>

<xsl:template match="imagedata|videodata|audiodata|textdata" priority="200">
  <xsl:copy>
    <xsl:call-template name="copy.attributes">
      <xsl:with-param name="suppress.srccredit" select="1"/>
    </xsl:call-template>
    <xsl:if test="@srccredit">
      <xsl:message>
        <xsl:text>Check conversion of srccredit </xsl:text>
        <xsl:text>(othercredit role="srccredit").</xsl:text>
      </xsl:message>
      <info>
        <othercredit role="srccredit">
          <orgname>???</orgname>
          <contrib>
            <xsl:value-of select="@srccredit"/>
          </contrib>
        </othercredit>
      </info>
    </xsl:if>
  </xsl:copy>
</xsl:template>

<xsl:template match="sgmltag" priority="200">
  <tag>
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </tag>
</xsl:template>

<xsl:template match="pubsnumber" priority="200">
  <biblioid class="pubnumber">
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </biblioid>
</xsl:template>

<xsl:template match="invpartnumber" priority="200">
  <xsl:message>
    <xsl:text>Converting invpartnumber to biblioid otherclass="invpartnumber".</xsl:text>
  </xsl:message>
  <biblioid class="other" otherclass="invpartnumber">
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </biblioid>
</xsl:template>

<xsl:template match="contractsponsor" priority="200">
  <xsl:variable name="contractnum"
                select="preceding-sibling::contractnum|following-sibling::contractnum"/>

  <xsl:message>
   <xsl:text>Converting contractsponsor to othercredit role="contractsponsor".</xsl:text>
  </xsl:message>

  <othercredit role="contractsponsor">
    <orgname>
      <xsl:call-template name="copy.attributes"/>
      <xsl:apply-templates/>
    </orgname>
    <xsl:for-each select="$contractnum">
      <contrib role="contractnum">
        <xsl:apply-templates select="node()"/>
      </contrib>
    </xsl:for-each>
  </othercredit>
</xsl:template>

<xsl:template match="contractnum" priority="200">
  <xsl:if test="not(preceding-sibling::contractsponsor
                    |following-sibling::contractsponsor)
                and not(preceding-sibling::contractnum)">
    <xsl:message>
      <xsl:text>Converting contractnum to othercredit role="contractnum".</xsl:text>
    </xsl:message>

    <othercredit role="contractnum">
      <orgname>???</orgname>
      <xsl:for-each select="self::contractnum
                            |preceding-sibling::contractnum
                            |following-sibling::contractnum">
        <contrib>
          <xsl:apply-templates select="node()"/>
        </contrib>
      </xsl:for-each>
    </othercredit>
  </xsl:if>
</xsl:template>

<xsl:template match="isbn|issn" priority="200">
  <biblioid class="{local-name(.)}">
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </biblioid>
</xsl:template>

<xsl:template match="authorblurb" priority="200">
  <personblurb>
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </personblurb>
</xsl:template>

<xsl:template match="ackno" priority="200">
  <xsl:message>
    <xsl:text>Converting ackno to para role="ackno".</xsl:text>
  </xsl:message>
  <para role="ackno">
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="collabname" priority="200">
  <xsl:message>
    <xsl:text>Check conversion of collabname </xsl:text>
    <xsl:text>(orgname role="collabname").</xsl:text>
  </xsl:message>
  <orgname role="collabname">
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </orgname>
</xsl:template>

<xsl:template match="modespec" priority="200">
  <xsl:message>
    <xsl:text>Discarding modespec (</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>).</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="mediaobjectco" priority="200">
  <mediaobject>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </mediaobject>
</xsl:template>

<xsl:template match="mediaobject/caption" priority="200">
  <xsl:message>
    <xsl:text>Discarding caption (</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>).</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="remark" priority="200">
  <!-- get rid of any embedded markup -->
  <remark>
    <xsl:copy-of select="@*"/>
    <xsl:value-of select="."/>
  </remark>
</xsl:template>

<xsl:template match="biblioentry/contrib
                     |bibliomset/contrib
                     |bibliomixed/contrib" priority="200">
  <xsl:message>
    <xsl:text>Check conversion of contrib </xsl:text>
    <xsl:text>(othercontrib role="contrib").</xsl:text>
  </xsl:message>
  <othercredit>
    <orgname>???</orgname>
    <contrib>
      <xsl:call-template name="copy.attributes"/>
      <xsl:apply-templates/>
    </contrib>
  </othercredit>
</xsl:template>

<xsl:template match="link" priority="200">
  <xsl:copy>
    <xsl:call-template name="copy.attributes"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="ulink" priority="200">
  <xsl:choose>
    <xsl:when test="node()">
      <xsl:message>
	<xsl:text>Converting ulink to link.</xsl:text>
      </xsl:message>

      <link xlink:href="{@url}">
	<xsl:call-template name="copy.attributes">
	  <xsl:with-param name="suppress.url" select="1"/>
	</xsl:call-template>
	<xsl:apply-templates/>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Converting ulink to uri.</xsl:text>
      </xsl:message>

      <uri xlink:href="{@url}">
	<xsl:call-template name="copy.attributes">
	  <xsl:with-param name="suppress.url" select="1"/>
	</xsl:call-template>
	<xsl:value-of select="@url"/>
      </uri>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="biblioentry/firstname
                     |biblioentry/surname
                     |biblioentry/othername
                     |biblioentry/lineage
                     |biblioentry/honorific
                     |bibliomset/firstname
                     |bibliomset/surname
                     |bibliomset/othername
                     |bibliomset/lineage
                     |bibliomset/honorific" priority="200">
  <xsl:choose>
    <xsl:when test="preceding-sibling::firstname
                    |preceding-sibling::surname
                    |preceding-sibling::othername
                    |preceding-sibling::lineage
                    |preceding-sibling::honorific">
      <!-- nop -->
    </xsl:when>
    <xsl:otherwise>
      <personname>
        <xsl:apply-templates select="../firstname
                                     |../surname
                                     |../othername
                                     |../lineage
                                     |../honorific" mode="copy"/>
      </personname>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="areaset" priority="200">
  <xsl:copy>
    <xsl:call-template name="copy.attributes">
      <xsl:with-param name="suppress.coords" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="date|pubdate" priority="200">
  <xsl:variable name="rp1" select="substring-before(normalize-space(.), ' ')"/>
  <xsl:variable name="rp2"
		select="substring-before(substring-after(normalize-space(.), ' '),
		                         ' ')"/>
  <xsl:variable name="rp3"
		select="substring-after(substring-after(normalize-space(.), ' '), ' ')"/>

  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="contains($rp1, ',')">
	<xsl:value-of select="substring-before($rp1, ',')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$rp1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="p2">
    <xsl:choose>
      <xsl:when test="contains($rp2, ',')">
	<xsl:value-of select="substring-before($rp2, ',')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$rp2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="p3">
    <xsl:choose>
      <xsl:when test="contains($rp3, ',')">
	<xsl:value-of select="substring-before($rp3, ',')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$rp3"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="date">
    <xsl:choose>
      <xsl:when test="string($p1+1) != 'NaN' and string($p3+1) != 'NaN'">
	<xsl:choose>
	  <xsl:when test="$p2 = 'Jan' or $p2 = 'January'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-01-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Feb' or $p2 = 'February'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-02-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Mar' or $p2 = 'March'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-03-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Apr' or $p2 = 'April'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-04-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'May'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-05-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Jun' or $p2 = 'June'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-06-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Jul' or $p2 = 'July'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-07-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Aug' or $p2 = 'August'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-08-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Sep' or $p2 = 'September'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-09-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Oct' or $p2 = 'October'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-10-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Nov' or $p2 = 'November'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-11-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p2 = 'Dec' or $p2 = 'December'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-12-</xsl:text>
	    <xsl:number value="$p1" format="01"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="string($p2+1) != 'NaN' and string($p3+1) != 'NaN'">
	<xsl:choose>
	  <xsl:when test="$p1 = 'Jan' or $p1 = 'January'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-01-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Feb' or $p1 = 'February'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-02-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Mar' or $p1 = 'March'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-03-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Apr' or $p1 = 'April'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-04-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'May'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-05-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Jun' or $p1 = 'June'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-06-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Jul' or $p1 = 'July'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-07-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Aug' or $p1 = 'August'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-08-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Sep' or $p1 = 'September'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-09-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Oct' or $p1 = 'October'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-10-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Nov' or $p1 = 'November'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-11-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:when test="$p1 = 'Dec' or $p1 = 'December'">
	    <xsl:number value="$p3" format="0001"/>
	    <xsl:text>-12-</xsl:text>
	    <xsl:number value="$p2" format="01"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="normalize-space($date) != normalize-space(.)">
      <xsl:message>
	<xsl:text>Converted </xsl:text>
	<xsl:value-of select="normalize-space(.)"/>
	<xsl:text> into </xsl:text>
	<xsl:value-of select="$date"/>
	<xsl:text> for </xsl:text>
	<xsl:value-of select="name(.)"/>
      </xsl:message>

      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:value-of select="$date"/>
      </xsl:copy>
    </xsl:when>

    <xsl:when test="$defaultDate != ''">
      <xsl:message>
	<xsl:text>Unparseable date: </xsl:text>
	<xsl:value-of select="normalize-space(.)"/>
	<xsl:text> in </xsl:text>
	<xsl:value-of select="name(.)"/>
	<xsl:text> (Using default: </xsl:text>
	<xsl:value-of select="$defaultDate"/>
	<xsl:text>)</xsl:text>
      </xsl:message>

      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="$defaultDate"/>
	<xsl:comment>
	  <xsl:value-of select="."/>
	</xsl:comment>
      </xsl:copy>
    </xsl:when>

    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unparseable date: </xsl:text>
	<xsl:value-of select="normalize-space(.)"/>
	<xsl:text> in </xsl:text>
	<xsl:value-of select="name(.)"/>
      </xsl:message>

      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>      
</xsl:template>

<xsl:template match="title|subtitle|titleabbrev" priority="300">
  <!-- nop -->
</xsl:template>

<!--
<xsl:template match="dedication/title|dedication/titleabbrev|dedication/subtitle
                     |preface/title|preface/titleabbrev|preface/subtitle
                     |chapter/title|chapter/titleabbrev|chapter/subtitle
                     |appendix/title|appendix/titleabbrev|appendix/subtitle
                     |article/title|article/titleabbrev|article/subtitle
                     |partintro/title|partintro/titleabbrev|partintro/subtitle
                     |part/title|part/titleabbrev|part/subtitle
                     |sect1/title|sect1/titleabbrev|sect1/subtitle
                     |sect2/title|sect2/titleabbrev|sect2/subtitle
                     |sect3/title|sect3/titleabbrev|sect3/subtitle
                     |sect4/title|sect4/titleabbrev|sect4/subtitle
                     |sect5/title|sect5/titleabbrev|sect5/subtitle
                     |section/title|section/titleabbrev|section/subtitle
                     |formalpara/title|figure/title|example/title|equation/title
                     |table/title|blockquote/title
                     |caution/title|important/title|note/title|warning/title|tip/title
                     |bibliodiv/title|glossarydiv/title|indexdiv/title
                     |book/title
                     |articleinfo/title
                     "
              priority="300">
</xsl:template>
-->

<!-- ====================================================================== -->

<xsl:template match="ulink" priority="200" mode="copy">
  <xsl:choose>
    <xsl:when test="node()">
      <xsl:message>
	<xsl:text>Converting ulink to phrase.</xsl:text>
      </xsl:message>

      <phrase xlink:href="{@url}">
	<xsl:call-template name="copy.attributes">
	  <xsl:with-param name="suppress.url" select="1"/>
	</xsl:call-template>
	<xsl:apply-templates/>
      </phrase>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Converting ulink to uri.</xsl:text>
      </xsl:message>

      <uri xlink:href="{@url}">
	<xsl:call-template name="copy.attributes">
	  <xsl:with-param name="suppress.url" select="1"/>
	</xsl:call-template>
	<xsl:value-of select="@url"/>
      </uri>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:copy>
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="copy">
  <xsl:copy/>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*">
  <xsl:copy>
    <xsl:call-template name="copy.attributes"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="copy.attributes">
  <xsl:param name="src" select="."/>
  <xsl:param name="suppress.format" select="0"/>
  <xsl:param name="suppress.class" select="0"/>
  <xsl:param name="suppress.srccredit" select="0"/>
  <xsl:param name="suppress.role" select="0"/>
  <xsl:param name="suppress.url" select="0"/>
  <xsl:param name="suppress.coords" select="0"/>

  <xsl:for-each select="$src/@*">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'moreinfo'">
        <xsl:message>
          <xsl:text>Discarding moreinfo on </xsl:text>
          <xsl:value-of select="local-name($src)"/>
        </xsl:message>
      </xsl:when>
      <xsl:when test="local-name(.) = 'lang'">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="local-name(.) = 'id'">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$suppress.format != 0 and local-name(.) = 'format'"/>
      <xsl:when test="$suppress.class != 0 and local-name(.) = 'class'"/>
      <xsl:when test="$suppress.srccredit != 0 and local-name(.) = 'srccredit'"/>
      <xsl:when test="$suppress.role != 0 and local-name(.) = 'role'"/>
      <xsl:when test="$suppress.url != 0 and local-name(.) = 'url'"/>
      <xsl:when test="$suppress.coords != 0 and local-name(.) = 'coords'"/>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="addNS">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}"
		   namespace="http://docbook.org/docbook-ng">
	<xsl:if test="not(parent::*)">
	  <xsl:attribute name="version">gin</xsl:attribute>
	</xsl:if>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="addNS"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:if test="not(parent::*)">
	  <xsl:attribute name="version">gin</xsl:attribute>
	</xsl:if>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="addNS"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="addNS">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
