<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xcat="urn:oasis:names:tc:entity:xmlns:xml:catalog"
		exclude-result-prefixes="xcat"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:param name="version" select="'undef'"/>

<xsl:variable name="catalog">
<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog" prefer="public"
	 xml:space="preserve">

<xsl:comment> ............................................................ </xsl:comment>
<xsl:comment> XML Catalog for DocBook .................................... </xsl:comment>
<xsl:comment> File catalog.xml ........................................... </xsl:comment>

<xsl:comment> Please direct all questions, bug reports, or suggestions for
     changes to the docbook@lists.oasis-open.org mailing list.
     For more information, see http://www.oasis-open.org/.
</xsl:comment>

<xsl:comment> This is a catalog data file for DocBook. It is provided as a
     convenience in building your own catalog files. You need not
     use the filenames listed here, and need not use the filename
     method of identifying storage objects at all. See the
     documentation for detailed information on the files associated
     with the DocBook DTD. See XML Catalogs at
     http://www.oasis-open.org/committees/entity/ for detailed
     information on supplying and using catalog data.
</xsl:comment>

<public publicId="-//OASIS//DTD DocBook XML {$version}//EN"
        uri="dtd/docbook.dtd"/>

<system systemId="http://www.oasis-open.org/docbook/xml/{$version}/dtd/docbook.dtd"
	uri="dtd/docbook.dtd"/>

<system systemId="http://docbook.org/xml/{$version}/dtd/docbook.dtd"
	uri="dtd/docbook.dtd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/rng/docbook.rng"
     uri="rng/docbook.rng"/>

<uri name="http://docbook.org/xml/{$version}/rng/docbook.rng"
     uri="rng/docbook.rng"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/rng/docbookxi.rng"
     uri="rng/docbookxi.rng"/>

<uri name="http://docbook.org/xml/{$version}/rng/docbookxi.rng"
     uri="rng/docbookxi.rng"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/rng/docbook.rnc"
     uri="rng/docbook.rnc"/>

<uri name="http://docbook.org/xml/{$version}/rng/docbook.rnc"
     uri="rng/docbook.rnc"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/rng/docbookxi.rnc"
     uri="rng/docbookxi.rnc"/>

<uri name="http://docbook.org/xml/{$version}/rng/docbookxi.rnc"
     uri="rng/docbookxi.rnc"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/xsd/docbook.xsd"
     uri="xsd/docbook.xsd"/>

<uri name="http://docbook.org/xml/{$version}/xsd/docbook.xsd"
     uri="xsd/docbook.xsd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/xsd/docbookxi.xsd"
     uri="xsd/docbookxi.xsd"/>

<uri name="http://docbook.org/xml/{$version}/xsd/docbookxi.xsd"
     uri="xsd/docbookxi.xsd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/xsd/xi.xsd"
     uri="xsd/xi.xsd"/>

<uri name="http://docbook.org/xml/{$version}/xsd/xi.xsd"
     uri="xsd/xi.xsd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/xsd/xlink.xsd"
     uri="xsd/xlink.xsd"/>

<uri name="http://docbook.org/xml/{$version}/xsd/xlink.xsd"
     uri="xsd/xlink.xsd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/xsd/xml.xsd"
     uri="xsd/xml.xsd"/>

<uri name="http://docbook.org/xml/{$version}/xsd/xml.xsd"
     uri="xsd/xml.xsd"/>

<uri name="http://www.oasis-open.org/docbook/xml/{$version}/sch/docbook.sch"
     uri="sch/docbook.sch"/>

<uri name="http://docbook.org/xml/{$version}/sch/docbook.sch"
     uri="sch/docbook.sch"/>

<xsl:comment> End of XML Catalog for DocBook ............................. </xsl:comment>
<xsl:comment> ............................................................ </xsl:comment>
</catalog>
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates select="$catalog/xcat:catalog"/>
</xsl:template>

<xsl:template match="xcat:catalog">
  <xsl:element name="catalog"
	       namespace="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <xsl:copy-of select="@*[name(.) != 'xml:space']"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="xcat:*">
  <xsl:element name="{local-name(.)}"
	       namespace="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
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
