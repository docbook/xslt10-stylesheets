<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dtd="http://nwalsh.com/xmlns/dtd/"
		version="1.0">

<xsl:variable name="merged-thead">
  <dtd:element name="thead">
    <dtd:group>
      <dtd:choice repeat="*">
        <dtd:ref name="colspec"/>
      </dtd:choice>
      <dtd:choice>
        <dtd:ref name="row" repeat="+"/>
        <dtd:ref name="tr" repeat="+"/>
      </dtd:choice>
    </dtd:group>
  </dtd:element>
</xsl:variable>

<xsl:variable name="merged-tfoot">
  <dtd:element name="tfoot">
    <dtd:group>
      <dtd:choice repeat="*">
        <dtd:ref name="colspec"/>
      </dtd:choice>
      <dtd:choice>
        <dtd:ref name="row" repeat="+"/>
        <dtd:ref name="tr" repeat="+"/>
      </dtd:choice>
    </dtd:group>
  </dtd:element>
</xsl:variable>

<xsl:variable name="merged-tbody">
  <dtd:element name="tbody">
    <dtd:group>
      <dtd:choice>
        <dtd:ref name="row" repeat="+"/>
        <dtd:ref name="tr" repeat="+"/>
      </dtd:choice>
    </dtd:group>
  </dtd:element>
</xsl:variable>

<xsl:variable name="merged-informaltable">
  <dtd:element name="informaltable">
    <dtd:group>
      <dtd:ref name="info" occurs="optional"/>
      <dtd:choice>
	<dtd:group>
	  <dtd:ref name="textobject" repeat="*"/>
	  <dtd:choice>
	    <dtd:ref name="mediaobject" repeat="+"/>
	    <dtd:ref name="tgroup" repeat="+"/>
	  </dtd:choice>
	</dtd:group>
	<dtd:group>
	  <dtd:choice>
	    <dtd:ref name="col" repeat="*"/>
	    <dtd:ref name="colgroup" repeat="*"/>
	  </dtd:choice>
	  <dtd:ref name="thead" occurs="?"/>
	  <dtd:ref name="tfoot" occurs="?"/>
	  <dtd:choice>
	    <dtd:ref name="tbody" repeat="+"/>
	    <dtd:ref name="tr" repeat="+"/>
	  </dtd:choice>
	</dtd:group>
      </dtd:choice>
    </dtd:group>
  </dtd:element>
</xsl:variable>

<xsl:variable name="merged-table">
  <dtd:element name="table">
    <dtd:choice>
      <dtd:group>
	<dtd:ref name="info" occurs="optional"/>
	<dtd:group>
	  <dtd:ref name="title"/>
	  <dtd:ref name="titleabbrev" occurs="optional"/>
	</dtd:group>
	<dtd:ref name="indexterm" occurs="*"/>
	<dtd:ref name="textobject" occurs="*"/>
	<dtd:choice>
	  <dtd:ref name="mediaobject" repeat="+"/>
	  <dtd:ref name="tgroup" repeat="+"/>
	</dtd:choice>
      </dtd:group>
      <dtd:group>
	<dtd:ref name="caption"/>
	<dtd:choice>
	  <dtd:ref name="col" repeat="*"/>
	  <dtd:ref name="colgroup" repeat="*"/>
	</dtd:choice>
	<dtd:ref name="thead" occurs="?"/>
	<dtd:ref name="tfoot" occurs="?"/>
	<dtd:choice>
	  <dtd:ref name="tbody" repeat="+"/>
	  <dtd:ref name="tr" repeat="+"/>
	</dtd:choice>
      </dtd:group>
    </dtd:choice>
  </dtd:element>
</xsl:variable>

<xsl:variable name="merged-caption">
  <dtd:element name="caption">
    <dtd:group>
      <dtd:choice repeat="*">
	<dtd:PCDATA/>
        <dtd:ref name="itemizedlist"/>
        <dtd:ref name="orderedlist"/>
        <dtd:ref name="procedure"/>
        <dtd:ref name="simplelist"/>
        <dtd:ref name="variablelist"/>
        <dtd:ref name="segmentedlist"/>
        <dtd:ref name="glosslist"/>
        <dtd:ref name="bibliolist"/>
        <dtd:ref name="calloutlist"/>
        <dtd:ref name="qandaset"/>
        <dtd:ref name="caution"/>
        <dtd:ref name="important"/>
        <dtd:ref name="note"/>
        <dtd:ref name="tip"/>
        <dtd:ref name="warning"/>
        <dtd:ref name="example"/>
        <dtd:ref name="figure"/>
        <dtd:ref name="table"/>
        <dtd:ref name="informalexample"/>
        <dtd:ref name="informalfigure"/>
        <dtd:ref name="informaltable"/>
        <dtd:ref name="sidebar"/>
        <dtd:ref name="blockquote"/>
        <dtd:ref name="address"/>
        <dtd:ref name="epigraph"/>
        <dtd:ref name="mediaobject"/>
        <dtd:ref name="screenshot"/>
        <dtd:ref name="task"/>
        <dtd:ref name="productionset"/>
        <dtd:ref name="constraintdef"/>
        <dtd:ref name="msgset"/>
        <dtd:ref name="programlisting"/>
        <dtd:ref name="screen"/>
        <dtd:ref name="literallayout"/>
        <dtd:ref name="synopsis"/>
        <dtd:ref name="programlistingco"/>
        <dtd:ref name="screenco"/>
        <dtd:ref name="cmdsynopsis"/>
        <dtd:ref name="funcsynopsis"/>
        <dtd:ref name="classsynopsis"/>
        <dtd:ref name="methodsynopsis"/>
        <dtd:ref name="constructorsynopsis"/>
        <dtd:ref name="destructorsynopsis"/>
        <dtd:ref name="fieldsynopsis"/>
        <dtd:ref name="bridgehead"/>
        <dtd:ref name="remark"/>
        <dtd:ref name="revhistory"/>
        <dtd:ref name="indexterm"/>
        <dtd:ref name="equation"/>
        <dtd:ref name="informalequation"/>
        <dtd:ref name="anchor"/>
        <dtd:ref name="para"/>
        <dtd:ref name="formalpara"/>
        <dtd:ref name="simpara"/>
        <dtd:ref name="html:form"/>
        <dtd:ref name="annotation"/>
      </dtd:choice>
    </dtd:group>
  </dtd:element>
</xsl:variable>

</xsl:stylesheet>

