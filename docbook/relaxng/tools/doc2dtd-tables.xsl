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

</xsl:stylesheet>

