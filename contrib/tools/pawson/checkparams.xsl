<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dp="http://www.dpawson.co.uk/ns#"
  xmlns:xs="http://www.w3.org/2001/XMLSchema-datatypes"
  xmlns:db="http://docbook.org/ns/docbook"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xi="http://www.w3.org/2001/XInclude"
          xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
  version="2.0">


 

<d:doc xmlns:d="rnib.org.uk/tbs#">
 <revhistory>
   <purpose><para>Validate the contents of a parameter files, via list of files which is the input instance.</para></purpose>
   <revision>
    <revnumber>1.0</revnumber>
    <date>2007-07-17T11:19:47Z</date>
    <authorinitials>DaveP</authorinitials>
    <revdescription>
     <para></para>
    </revdescription>
    <revremark></revremark>
   </revision>
   <revision>
    <revnumber>1.1</revnumber>
    <date>2007-07-26T08:16:12Z</date>
    <authorinitials>DaveP</authorinitials>
    <revdescription>
     <para>Amended to work with directory listing from dirlist.py</para>
    </revdescription>
    <revremark></revremark>
   </revision>



  </revhistory>
  </d:doc>
  

  <xsl:output method="text" indent="yes" encoding="utf-8"/>

  <xsl:template match="/">
    <xsl:variable name="path" select="concat(directory/@name,'/')"/>
    <xsl:for-each select="directory/file/@name">
      <!--     <xsl:message>
        <xsl:value-of select="concat($path,.)"/>
      </xsl:message>
-->
      <xsl:apply-templates select="document(concat($path,.))/db:refentry"/>
    </xsl:for-each>
        
  </xsl:template>


  <xsl:template match="db:refentry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="db:refnamediv">
    <xsl:choose>
      <xsl:when test="db:refname =/db:refentry/@xml:id" />
      <xsl:otherwise>
        refnamediv id = <xsl:value-of select="db:refname"/>
        refentry/@xml:id = <xsl:value-of select="/db:refentry/@xml:id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




  <xsl:template match="src:fragment">
     <xsl:choose>
      <xsl:when test="contains(@xml:id, /db:refentry/@xml:id)"/>
      <xsl:otherwise>
        <xsl:message>
-------------------
<xsl:text>File </xsl:text>  <xsl:value-of select="base-uri()"/>       
<xsl:text>
refentry id, </xsl:text><xsl:value-of select="/db:refentry/@xml:id"/>
        <xsl:if test="string(@xml:id)">
src:fragment/@xml:id <xsl:value-of select="@xml:id"/>   
        </xsl:if>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="not(contains(@xml:id, '.frag')) ">
      <xsl:message>
        <xsl:text>
          refentry id, </xsl:text>'<xsl:value-of select="/db:refentry/@xml:id"/>'
        <xsl:if test="string(@xml:id)">
          <xsl:text>  src:fragment/@xml:id '</xsl:text><xsl:value-of select="@xml:id"/>'  
          Missing .frag extension
        </xsl:if>
      </xsl:message>
    </xsl:if>


    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="xsl:param">
    <xsl:choose>
      <xsl:when test="@select= '1' or 
                      @select='0' or 
                      (not(@select)) or 
                      contains(@select, 'concat') or
                      contains(@select, '$') or
                      contains(@select, ';')"/>
      <xsl:otherwise>
        <xsl:message>
<xsl:text>File </xsl:text>  <xsl:value-of select="base-uri()"/>    
<xsl:text>
        xsl:param, </xsl:text> [<xsl:value-of select="@select"/>]
        </xsl:message>      
 
  
      </xsl:otherwise>

    </xsl:choose>


  </xsl:template>


  <!--
  <xsl:template match="*">
  <xsl:message>
    *****<xsl:value-of select="name(..)"/>/{<xsl:value-of select="namespace-uri()"/>}<xsl:value-of select="name()"/>******
    </xsl:message>
</xsl:template>
-->


</xsl:stylesheet>
