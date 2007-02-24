<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db = "http://docbook.org/ns/docbook"
                version="1.0">

<xsl:output method="text" encoding="utf-8" indent="yes"/>    
<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:call-template name="ExportSection"/>
</xsl:template>

<!-- ******************************************************************** -->
<!-- Export Section                                                       -->
<!-- ******************************************************************** -->
<xsl:template name="ExportSection">
  <xsl:variable name="sectionlevel" select="1"/>  
  <xsl:apply-templates/>
</xsl:template>

<!-- ******************************************************************** -->
<!-- imagedate                                                            -->
<!-- ******************************************************************** -->
<xsl:template match="db:imagedata">
  <xsl:if test="parent::db:imageobject[@role!='fo' or not(@role)]">
  <xsl:text>{{:</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>|</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>}}
</xsl:text>
  </xsl:if>  
</xsl:template>
    
<!-- ******************************************************************** -->
<!-- imagedate                                                            -->
<!-- ******************************************************************** -->
<xsl:template match="db:imagedata" mode="NOENTER">
  <xsl:text>{{:</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>|</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>}}</xsl:text>
</xsl:template>
    
<!-- ******************************************************************** -->
<!-- graphic                                                              -->
<!-- ******************************************************************** -->
<xsl:template match="db:graphic">
  <xsl:text>{{:</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>|</xsl:text>
  <xsl:call-template name="getfilename">
    <xsl:with-param name="fileref">
      <xsl:value-of select="@fileref"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>}}</xsl:text>
</xsl:template>
    
     
<!-- ******************************************************************** -->
<!-- title pro sekci                                                      -->
<!-- ******************************************************************** -->
<xsl:template match="db:title[parent::db:section]"> 
  <xsl:variable name="level" select="count(ancestor-or-self::db:section)"/> 
  <xsl:choose>
    <xsl:when test="$level=1"><xsl:text>====== </xsl:text></xsl:when>
    <xsl:when test="$level=2"><xsl:text>===== </xsl:text></xsl:when>
    <xsl:when test="$level=3"><xsl:text>==== </xsl:text></xsl:when>
    <xsl:when test="$level=4"><xsl:text>=== </xsl:text></xsl:when>
    <xsl:when test="$level=5"><xsl:text>== </xsl:text></xsl:when>
      <xsl:otherwise>
        <xsl:text>= </xsl:text>
      </xsl:otherwise>
    </xsl:choose> 
<xsl:value-of select="."/>
  <xsl:choose>
    <xsl:when test="$level=1"><xsl:text> ======
</xsl:text></xsl:when>
    <xsl:when test="$level=2"><xsl:text> =====
</xsl:text></xsl:when>
    <xsl:when test="$level=3"><xsl:text> ====
</xsl:text></xsl:when>
    <xsl:when test="$level=4"><xsl:text> ===
</xsl:text></xsl:when>
    <xsl:when test="$level=5"><xsl:text> ==
</xsl:text></xsl:when>
      <xsl:otherwise>
        <xsl:text> =
</xsl:text>
      </xsl:otherwise>
    </xsl:choose> 
</xsl:template>


<!-- ******************************************************************** -->
<!-- programlisting                                                       -->
<!-- ******************************************************************** -->
<xsl:template match="db:programlisting"> 
  <xsl:text>&lt;code&gt;
</xsl:text><xsl:value-of select="."/><xsl:text>
&lt;/code&gt;

</xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- title pro tabulku                                                    -->
<!-- ******************************************************************** -->
<xsl:template match="db:title[parent::db:table]"> 
  <xsl:text>
Tabulka: **</xsl:text><xsl:value-of select="."/><xsl:text>**

</xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- title pro chapter                                                    -->
<!-- ******************************************************************** -->
<xsl:template match="db:title[parent::db:chapter]"> 
</xsl:template>


<!-- ******************************************************************** -->
<!-- title pro figure                                                     -->
<!-- ******************************************************************** -->
<xsl:template match="db:title[parent::db:figure]"> 
  <xsl:text>
**</xsl:text><xsl:value-of select="."/><xsl:text>**

</xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- title pro example                                                    -->
<!-- ******************************************************************** -->
<xsl:template match="db:title[parent::db:example]"> 
  <xsl:text>
**Příklad: </xsl:text><xsl:value-of select="."/><xsl:text>**

</xsl:text>
</xsl:template>

   
<!-- ******************************************************************** -->
<!-- link                                                                 -->
<!-- ******************************************************************** -->
<xsl:template match="db:link"> 
  <xsl:text>**</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
</xsl:template>
   
   
<!-- ******************************************************************** -->
<!-- listitem                                                             -->
<!-- ******************************************************************** -->
<xsl:template match="db:listitem[parent::db:itemizedlist]">
  <xsl:text>  * </xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

<!-- ******************************************************************** -->
<!-- listitem                                                             -->
<!-- ******************************************************************** -->
<xsl:template match="db:listitem[parent::db:itemizedlist[parent::db:listitem]]" priority="2">
  <xsl:text>    * </xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

<!-- ******************************************************************** -->
<!-- listitem                                                             -->
<!-- ******************************************************************** -->
<xsl:template match="db:listitem[parent::db:orderedlist]">
  <xsl:text>  - </xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

     
<!-- ******************************************************************** -->
<!-- warning                                                              -->
<!-- ******************************************************************** -->
<xsl:template match="db:warning">
<xsl:text>&lt;note warning&gt;
</xsl:text>
  <xsl:apply-templates/>    
<xsl:text>&lt;/note&gt;
</xsl:text>
</xsl:template>
     
<!-- ******************************************************************** -->
<!-- tip                                                                  -->
<!-- ******************************************************************** -->
<xsl:template match="db:tip">
  <xsl:text>== </xsl:text>Tip: <xsl:text> ==
</xsl:text>
  <xsl:apply-templates/>    
</xsl:template>
     
<!-- ******************************************************************** -->
<!-- caution                                                              -->
<!-- ******************************************************************** -->
<xsl:template match="db:caution">
  <xsl:text>== </xsl:text>Výstraha: <xsl:text> ==
</xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

<!-- ******************************************************************** -->
<!-- note                                                                 -->
<!-- ******************************************************************** -->
<xsl:template match="db:note">
  <xsl:text>== </xsl:text>Poznámka: <xsl:text> ==
</xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

<!-- ******************************************************************** -->
<!-- important                                                            -->
<!-- ******************************************************************** -->
<xsl:template match="db:important">
  <xsl:text>== </xsl:text>Důležité: <xsl:text> ==
</xsl:text>
  <xsl:apply-templates/>    
</xsl:template>

<!-- ******************************************************************** -->
<!-- varlistentry/term                                                    -->
<!-- ******************************************************************** -->
<xsl:template match="db:varlistentry/db:term">
  <xsl:text>  ;</xsl:text>
  <xsl:value-of select="."/>  
  <xsl:text> : </xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- emphasis                                                             -->
<!-- ******************************************************************** -->
<xsl:template match="db:emphasis">
  <xsl:text>**</xsl:text>
  <xsl:value-of select="."/>  
  <xsl:text>**</xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- variablelist                                                         -->
<!-- ******************************************************************** -->
<xsl:template match="db:variablelist">
  <xsl:apply-templates/>    
    <xsl:text>
</xsl:text>
</xsl:template>

<!-- ******************************************************************** -->
<!-- varlistentry/listitem                                                -->
<!-- ******************************************************************** -->
<xsl:template match="db:varlistentry/db:listitem">
  <xsl:apply-templates/>    
</xsl:template>

         
<!-- ******************************************************************** -->
<!-- tgroup/tbody/row/entry                                               -->
<!-- ******************************************************************** -->
<xsl:template match="db:tgroup/db:tbody/db:row/db:entry">
  <xsl:text>|</xsl:text>
  <xsl:choose>
    <xsl:when test="child::db:*">
      <xsl:apply-templates mode="NOENTER"/>
      <xsl:text> </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="NoSlashValue">
        <xsl:with-param name="data">
          <xsl:value-of select="translate(.,'&#013;&#010;','  ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose> 
<xsl:if test="position()=last()">
    <xsl:text>|
</xsl:text>
</xsl:if>  
</xsl:template>


<!-- ******************************************************************** -->
<!-- NoSlashValue                                                         -->
<!-- ******************************************************************** -->
<xsl:template name="NoSlashValue">
  <xsl:param name="data"/>
  <xsl:choose>  
    <xsl:when test="contains($data,'|')">
      <xsl:value-of select="substring-before($data,'|')"/><xsl:text>%%|%%</xsl:text>
      <xsl:call-template name="NoSlashValue">
        <xsl:with-param name="data">
          <xsl:value-of select="substring-after($data,'|')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$data"/>
    </xsl:otherwise>
  </xsl:choose>  
  
</xsl:template>


<!-- ******************************************************************** -->
<!-- tgroup/thead/row/entry                                               -->
<!-- ******************************************************************** -->
<xsl:template match="db:tgroup/db:thead/db:row/db:entry">
  <xsl:text>^</xsl:text>
  <xsl:choose>
    <xsl:when test="child::db:*">
      <xsl:apply-templates mode="NOENTER"/>          
      <xsl:text> </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose> 
<xsl:if test="position()=last()">
    <xsl:text>^
</xsl:text>
</xsl:if>  
</xsl:template>


<!-- ******************************************************************** -->
<!-- para                                                                 -->
<!-- ******************************************************************** -->
<xsl:template match="db:para">
  <xsl:if test="preceding-sibling::db:figure">
    <xsl:text>\\ 
</xsl:text>
</xsl:if>
  <xsl:apply-templates/>    
  <xsl:if test="not(parent::db:listitem)">
    <xsl:text>
</xsl:text>  
  </xsl:if>
  <xsl:if test="preceding-sibling::db:para|following-sibling::db:para">
    <xsl:text> 
</xsl:text>
</xsl:if>
</xsl:template>


<!-- ******************************************************************** -->
<!-- getfilename - získání jména souboru                                  -->
<!-- ******************************************************************** -->
<xsl:template name="getfilename">
  <xsl:param name="fileref"/>
  <xsl:choose>  
    <xsl:when test="contains($fileref,'\')">
      <xsl:call-template name="getfilename">
        <xsl:with-param name="fileref">
          <xsl:value-of select="substring-after($fileref,'\')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($fileref,'/')">
      <xsl:call-template name="getfilename">
        <xsl:with-param name="fileref">
          <xsl:value-of select="substring-after($fileref,'/')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fileref"/>
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>


<!-- Přepsání defaultní šablony na kopírování textových uzlů tak aby na konci byl vždy enter-->
<xsl:template match="text()|@*">
  <xsl:value-of select="translate(.,'&#013;&#010;','  ')"/>
    <xsl:text>
</xsl:text>  
</xsl:template>


</xsl:stylesheet>