<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY para "w:p[w:pPr/w:pStyle[@w:val='para' or @w:val='Normal']]">
<!ENTITY continue "w:p[w:pPr/w:pStyle/@w:val='para-continue']">

<!ENTITY wordlist 'w:p[w:pPr/w:listPr/w:ilvl/@w:val = "0" and
		   w:pPr/w:listPr/wx:t/@wx:val = "&#183;" and
		   w:pPr/w:listPr/wx:font/@wx:val = "Symbol"]'>

<!ENTITY itemizedlist 'w:p[starts-with(w:pPr/w:pStyle/@w:val,"itemizedlist") or
		       (w:pPr/w:listPr/w:ilvl/@w:val = "0" and
		       w:pPr/w:listPr/wx:t/@wx:val = "&#183;" and
		       w:pPr/w:listPr/wx:font/@wx:val = "Symbol")]'>
<!ENTITY itemizedlist1 'w:p[w:pPr/w:pStyle/@w:val = "itemizedlist" or
			(w:pPr/w:listPr/w:ilvl/@w:val = "0" and
			w:pPr/w:listPr/wx:t/@wx:val = "&#183;" and
			w:pPr/w:listPr/wx:font/@wx:val = "Symbol")]'>
<!ENTITY orderedlist "w:p[w:pPr/w:pStyle[starts-with(@w:val,'orderedlist')]]">
<!ENTITY orderedlist1 "w:p[w:pPr/w:pStyle[@w:val = 'orderedlist']]">

<!ENTITY variablelist "w:tbl[w:tblPr/w:tblStyle[starts-with(@w:val,'variablelist')]]">

<!ENTITY verbatim "w:p[w:pPr/w:pStyle[@w:val='programlisting' or @w:val='screen' or @w:val='literallayout']]">
<!ENTITY admontitle "w:p[w:pPr/w:pStyle[@w:val='note-title' or @w:val='caution-title' or @w:val='important-title' or @w:val='tip-title' or @w:val='warning-title']]">
<!ENTITY admon "w:p[w:pPr/w:pStyle[@w:val='note' or @w:val='caution' or @w:val='important' or @w:val='tip' or @w:val='warning']]">
<!ENTITY figure "w:p[w:pPr/w:pStyle[@w:val='figure']]">
<!ENTITY figuretitle "w:p[w:pPr/w:pStyle[@w:val='figuretitle']]">
<!ENTITY figurecaption "w:p[w:pPr/w:pStyle[@w:val='figuretitle']]">
<!ENTITY tabletitle "w:p[w:pPr/w:pStyle[@w:val='tabletitle']]">
<!ENTITY exampletitle "w:p[w:pPr/w:pStyle[@w:val='exampletitle']]">
<!ENTITY listlevel "substring-after(w:pPr/w:pStyle/@w:val, 'edlist')">
<!ENTITY listlabel "w:pPr/w:listPr/wx:t/@wx:val">
<!ENTITY footnote "w:p[w:pPr/w:pStyle[@w:val='FootnoteText']]">

<!ENTITY releaseinfo "w:p[w:pPr/w:pStyle/@w:val='releaseinfo']">
<!ENTITY affiliation "w:p[w:pPr/w:pStyle/@w:val='affiliation']">
<!ENTITY author "w:p[w:pPr/w:pStyle/@w:val='author']">
<!ENTITY editor "w:p[w:pPr/w:pStyle/@w:val='editor']">
<!ENTITY othercredit "w:p[w:pPr/w:pStyle/@w:val='othercredit']">
<!ENTITY authorblurb "w:p[w:pPr/w:pStyle/@w:val='authorblurb']">
<!ENTITY surname "w:r[w:rPr/w:rStyle/@w:val='surname']">
<!ENTITY firstname "w:r[w:rPr/w:rStyle/@w:val='firstname']">
<!ENTITY honorific "w:r[w:rPr/w:rStyle/@w:val='honorific']">
<!ENTITY lineage "w:r[w:rPr/w:rStyle/@w:val='lineage']">
<!ENTITY othername "w:r[w:rPr/w:rStyle/@w:val='othername']">
<!ENTITY contrib "w:r[w:rPr/w:rStyle/@w:val='contrib']">
<!ENTITY street "w:r[w:rPr/w:rStyle/@w:val='street']">
<!ENTITY pob "w:r[w:rPr/w:rStyle/@w:val='pob']">
<!ENTITY postcode "w:r[w:rPr/w:rStyle/@w:val='postcode']">
<!ENTITY city "w:r[w:rPr/w:rStyle/@w:val='city']">
<!ENTITY state "w:r[w:rPr/w:rStyle/@w:val='state']">
<!ENTITY country "w:r[w:rPr/w:rStyle/@w:val='country']">
<!ENTITY phone "w:r[w:rPr/w:rStyle/@w:val='phone']">
<!ENTITY fax "w:r[w:rPr/w:rStyle/@w:val='fax']">
<!ENTITY otheraddr "w:r[w:rPr/w:rStyle/@w:val='otheraddr']">
<!ENTITY shortaffil "w:r[w:rPr/w:rStyle/@w:val='shortaffil']">
<!ENTITY jobtitle "w:r[w:rPr/w:rStyle/@w:val='jobtitle']">
<!ENTITY orgname "w:r[w:rPr/w:rStyle/@w:val='orgname']">
<!ENTITY orgdiv "w:r[w:rPr/w:rStyle/@w:val='orgdiv']">
]>

<xsl:stylesheet xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:v="urn:schemas-microsoft-com:vml" 
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  xmlns:o="urn:schemas-microsoft-com:office:office" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="aml w wx o v" version="1.0">

  <!-- $Id$ -->
  <!-- Stylesheet to convert WordProcessingML to DocBook -->
  <!-- This stylesheet processes the output of wordml-sects.xsl -->

  <xsl:output indent="yes" method="xml" 
    doctype-public="-//OASIS//DTD DocBook XML V4.3//EN"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd"/>

  <!-- ================================================== -->
  <!--    Parameters                                      -->
  <!-- ================================================== -->

  <xsl:param name="nest.sections">1</xsl:param>

  <!-- ================================================== -->
  <!--    Templates                                       -->
  <!-- ================================================== -->
  <!-- Look up a w:listDef element by its StyleLink -->
  <xsl:key name="listdef-stylelink"
    match="w:listDef"
    use="w:listStyleLink/@w:val"/>

  <xsl:key name="list-ilst"
    match="w:list"
    use="w:ilst/@w:val"/>

  <xsl:strip-space elements='*'/>
  <xsl:preserve-space elements='w:t'/>

  <xsl:template match="/">
    <xsl:apply-templates select="//w:body"/>
  </xsl:template>

  <xsl:template match="w:body">
    <xsl:apply-templates mode="group"/>
  </xsl:template>

  <xsl:template match="wx:sect" mode="group">
    <xsl:apply-templates  mode="group"/>
  </xsl:template>

  <xsl:template match="wx:sub-section" mode="group">
    <xsl:variable name="first.node" select="w:p[1]"/>

    <xsl:variable name="element.name">
      <xsl:call-template name='component-name'>
        <xsl:with-param name='node' select='$first.node'/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test='$element.name != "bogus"'>
        <xsl:element name="{$element.name}">
          <xsl:call-template name="object.id"/>
          <xsl:call-template name='attributes'>
            <xsl:with-param name='node' select='$first.node'/>
          </xsl:call-template>
          <xsl:apply-templates mode="group"/>
        </xsl:element>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates mode='group'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='component-name'>
    <xsl:param name='node' select='.'/>
    <xsl:variable name="style" select="$node/w:pPr/w:pStyle/@w:val"/>

    <xsl:choose>
      <xsl:when test="$style = 'article' or
                      $style = 'article-title'">article</xsl:when>
      <xsl:when test="$style = 'appendix' or
                      $style = 'appendix-title'">appendix</xsl:when>
      <xsl:when test="($style = 'sect1' or
                      $style = 'sect1-title') and 
                      $nest.sections != 0">section</xsl:when>
      <xsl:when test="$style = 'sect1' or
                      $style = 'sect1-title'">sect1</xsl:when>
      <xsl:when test="($style = 'sect2' or
                      $style = 'sect2-title') and 
                      $nest.sections != 0">section</xsl:when>
      <xsl:when test="$style = 'sect2' or
                      $style = 'sect2-title'">sect2</xsl:when>
      <xsl:when test="($style = 'sect3' or
                      $style = 'sect3-title') and 
                      $nest.sections != 0">section</xsl:when>
      <xsl:when test="$style = 'sect3' or
                      $style = 'sect3-title'">sect3</xsl:when>
      <xsl:when test="($style = 'sect4' or
                      $style = 'sect4-title') and 
                      $nest.sections != 0">section</xsl:when>
      <xsl:when test="$style = 'sect4' or
                      $style = 'sect4-title'">sect4</xsl:when>
      <xsl:when test="($style = 'sect5' or
                      $style = 'sect5-title') and 
                      $nest.sections != 0">section</xsl:when>
      <xsl:when test="$style = 'sect5' or
                      $style = 'sect5-title'">sect5</xsl:when>
      <xsl:otherwise>bogus</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- sub-section title paragraph -->
  <xsl:template match="wx:sub-section/w:p[1]" mode="group">
    <xsl:variable name='parent'>
      <xsl:call-template name='component-name'/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test='../&releaseinfo;|../&author;|../&editor;|../&othercredit;'>
        <xsl:element name='{$parent}info'>
          <title>
            <xsl:apply-templates select="w:r|w:hlink"/>
          </title>
	  <xsl:apply-templates select='following-sibling::*[1][self::w:p][w:pPr/w:pStyle/@w:val = concat($parent, "-subtitle")]' mode='subtitle'/>
          <xsl:apply-templates select='../&releaseinfo;|../&author;|../&editor;|../&othercredit;' mode='metadata'/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <title>
          <xsl:apply-templates select="w:r|w:hlink"/>
        </title>
	<xsl:apply-templates select='following-sibling::*[1][self::w:p][w:pPr/w:pStyle/@w:val = concat($parent, "-subtitle")]' mode='subtitle'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='w:p[w:pPr/w:pStyle/@w:val = "book-subtitle" or
		       w:pPr/w:pStyle/@w:val = "article-subtitle" or
		       w:pPr/w:pStyle/@w:val = "section-subtitle" or
		       w:pPr/w:pStyle/@w:val = "sect1-subtitle" or
		       w:pPr/w:pStyle/@w:val = "sect2-subtitle" or
		       w:pPr/w:pStyle/@w:val = "sect3-subtitle" or
		       w:pPr/w:pStyle/@w:val = "sect4-subtitle" or
		       w:pPr/w:pStyle/@w:val = "sect5-subtitle" or
		       w:pPr/w:pStyle/@w:val = "appendix-subtitle" or
		       w:pPr/w:pStyle/@w:val = "bibliography-subtitle" or
		       w:pPr/w:pStyle/@w:val = "chapter-subtitle" or
		       w:pPr/w:pStyle/@w:val = "glossary-subtitle" or
		       w:pPr/w:pStyle/@w:val = "part-subtitle" or
		       w:pPr/w:pStyle/@w:val = "preface-subtitle" or
		       w:pPr/w:pStyle/@w:val = "reference-subtitle" or
		       w:pPr/w:pStyle/@w:val = "set-subtitle"]' mode='group'>

    <xsl:variable name='parent' select='substring-before(w:pPr/w:pStyle/@w:val, "-")'/>

    <xsl:if test='preceding-sibling::*[1][not(self::w:p) or
		  (self::w:p and w:pPr/w:pStyle/@w:val != concat($parent, "-title"))]'>
      <xsl:call-template name='report-error'>
	<xsl:with-param name='message'>
	  <xsl:text>paragraph style "</xsl:text>
	  <xsl:value-of select='w:pPr/w:pStyle/@w:val'/>
	  <xsl:text>" found without a preceding title</xsl:text>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match='w:p' mode='subtitle'>
    <subtitle>
      <xsl:call-template name='attributes'/>
      <xsl:apply-templates select='w:r|w:hlink'/>
    </subtitle>
  </xsl:template>
  <xsl:template match='*' mode='subtitle'>
    <xsl:call-template name='report-error'>
      <xsl:with-param name='message'>
	<xsl:text>paragraph style "</xsl:text>
	<xsl:value-of select='w:pPr/w:pStyle/@w:val'/>
	<xsl:text>" found in subtitle context</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- metadata -->
  <xsl:template match="&releaseinfo;|&author;|&editor;|&othercredit;|&affiliation;" mode='group'/>
  <xsl:template match="&releaseinfo;" mode='metadata'>
    <releaseinfo>
      <xsl:call-template name='attributes'/>
      <xsl:apply-templates select='w:r|w:hlink'/>
    </releaseinfo>
  </xsl:template>
  <xsl:template match="&author;|&editor;|&othercredit;" mode='metadata'>
    <xsl:element name='{w:pPr/w:pStyle/@w:val}'>
      <xsl:apply-templates select='w:r|w:hlink' mode='metadata'/>
      <xsl:apply-templates select='following-sibling::w:p' mode='author'/>
    </xsl:element>
  </xsl:template>
  <xsl:template match='*' mode='author'/>
  <xsl:template match='&authorblurb;' mode='author'>
    <authorblurb>
      <para>
        <xsl:call-template name='object.id'/>
        <xsl:apply-templates select="w:r|w:hlink"/>
      </para>
      <!-- TODO: continuations -->
    </authorblurb>
  </xsl:template>
  <xsl:template match='&affiliation;' mode='author'>
    <affiliation>
      <xsl:call-template name='object.id'/>
      <xsl:apply-templates select="&shortaffil;|&jobtitle;|&orgname;|&orgdiv;" mode='metadata'/>
      <xsl:if test='&honorific;|&firstname;|&surname;|&lineage;|&othername;|&contrib;|&street;|&pob;|&postcode;|&city;|&state;|&country;|&phone;|&fax;|&otheraddr;|w:hlink'>
        <address>
          <xsl:apply-templates select="&honorific;|&firstname;|&surname;|&lineage;|&othername;|&contrib;|&street;|&pob;|&postcode;|&city;|&state;|&country;|&phone;|&fax;|&otheraddr;|w:hlink" mode='metadata'/>
        </address>
      </xsl:if>
    </affiliation>
  </xsl:template>
  <xsl:template match='&continue;' mode='author'>
    <address>
      <xsl:apply-templates select='w:r|w:hlink' mode='metadata'/>
    </address>
  </xsl:template>
  <xsl:template match='w:r' mode='metadata' priority='0'/>
  <xsl:template match='&surname;|&firstname;|&honorific;|&lineage;|&othername; |
                       &contrib; |
                       &street;|&pob;|&postcode;|&city;|&state;|&country;|&phone;|&fax;' mode='metadata'>
    <xsl:element name='{w:rPr/w:rStyle/@w:val}'>
      <xsl:apply-templates select='w:t'/>
    </xsl:element>
  </xsl:template>
  <xsl:template match='&otheraddr;' mode='metadata'>
    <otheraddr>
      <xsl:apply-templates select='w:t'/>
    </otheraddr>
  </xsl:template>
  <xsl:template match='w:hlink' mode='metadata'>
    <xsl:choose>
      <xsl:when test='starts-with(@w:dest, "mailto:")'>
        <email>
          <xsl:apply-templates select='.'/>
        </email>
      </xsl:when>
      <xsl:otherwise>
        <otheraddr>
          <xsl:apply-templates select='.'/>
        </otheraddr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='wordlist'
		priority='2'
		mode='group'>
    <xsl:choose>
      <xsl:when test='preceding-sibling::*[1][self::&wordlist;]'>
	<xsl:comment> wordlist subsequent item </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
	<xsl:comment> wordlist first item </xsl:comment>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Ordinary para -->
  <xsl:template match="&para;|w:p[not(w:pPr/w:pStyle)]" mode="group">
    <para>
      <xsl:call-template name="object.id"/>
      <xsl:apply-templates select="w:r|w:hlink"/>
    </para>
  </xsl:template>

  <!-- Unmatched para style -->
  <xsl:template match="w:p" mode="group">
    <nomatch>
      <xsl:apply-templates select="w:r|w:hlink"/>
    </nomatch>
  </xsl:template>

  <!-- unused elements are bypassed -->
  <xsl:template match="*" mode="group"/>

  <!-- continued paragraphs are included by their (preceding) parent -->
  <xsl:template match="&continue;" mode='group'/>

  <!-- Match on the first one of an itemizedlist -->
  <xsl:template match="&itemizedlist1;[not(preceding-sibling::*[1]
                       [self::&itemizedlist; or self::&continue;])]" 
    priority="2"
    mode="group">

    <!-- Identify the node that follows all the listitems -->
    <xsl:variable name="stop.node"
      select="generate-id(following-sibling::*[not(self::&itemizedlist;
              or self::&continue;
              or self::&orderedlist;)][1])"/>

    <!-- Start the list and process all the level 1 listitems -->
    <itemizedlist>
      <xsl:apply-templates mode="item" 
        select=".|following-sibling::&itemizedlist;[&listlevel; = '']
                [following-sibling::*[generate-id() = $stop.node]]">
        <xsl:with-param name="depth" select="1"/>
      </xsl:apply-templates>
    </itemizedlist>

  </xsl:template>

  <xsl:template match="&itemizedlist;" mode="item">
    <xsl:param name="depth" select="1"/>

    <listitem>
      <para>
        <xsl:apply-templates/>
      </para>
      <xsl:apply-templates mode="item" 
        select="following-sibling::*[1][self::&continue;]"/>
      <!-- Now any nested list is inside this list item -->
      <xsl:apply-templates mode="subgroup"
        select="following-sibling::*[1]
                [self::&itemizedlist; or self::&orderedlist;]
                [&listlevel; &gt; $depth]">

        <xsl:with-param name="depth" select="$depth + 1"/>
      </xsl:apply-templates>
    </listitem>

  </xsl:template>

<xsl:template match="&itemizedlist;" mode="subgroup">
  <xsl:param name="depth" select="0"/>

  <xsl:variable name="stop.node"
      select="generate-id(following-sibling::*[
                        self::&itemizedlist1; or
                        self::&orderedlist1; or
                        self::&itemizedlist;[&listlevel; &lt; $depth] or
                        self::&orderedlist;[&listlevel; &lt; $depth] or
                        not(self::&itemizedlist; or 
                            self::&orderedlist; or
                            self::&continue;)]
                        [1])"/>

  <itemizedlist>
    <xsl:apply-templates mode="item"
             select=".|following-sibling::&itemizedlist;
                       [&listlevel; = $depth]
                       [following-sibling::*[generate-id() = $stop.node]]">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </itemizedlist>
</xsl:template>

<xsl:template match="&itemizedlist;[preceding-sibling::*[1]
                     [self::&itemizedlist; or 
                      self::&orderedlist; or
                      self::&continue;]]" 
                     mode="group">
  <!-- Handle with mode = group -->
</xsl:template>





<!-- Match on the first one of an orderedlist -->
<xsl:template match="&orderedlist1;[not(preceding-sibling::*[1]
                     [self::&orderedlist; or self::&continue;])]" 
                     priority="2"
                     mode="group">

  <!-- Identify the node that follows all the listitems -->
  <xsl:variable name="stop.node"
              select="generate-id(following-sibling::*[not(self::&itemizedlist;
                      or self::&continue;
                      or self::&orderedlist;)][1])"/>
                       
  <!-- Start the list and process all the level 1 listitems -->
  <orderedlist>
    <xsl:apply-templates mode="item" 
          select=".|following-sibling::&orderedlist;[&listlevel; = '']
                  [following-sibling::*[generate-id() = $stop.node]]">
      <xsl:with-param name="depth" select="1"/>
    </xsl:apply-templates>
  </orderedlist>
  
</xsl:template>

<xsl:template match="&orderedlist;" mode="item">
  <xsl:param name="depth" select="1"/>

  <listitem>
    <para>
      <xsl:apply-templates/>
    </para>
    <xsl:apply-templates mode="item" 
                select="following-sibling::*[1][self::&continue;]"/>
    <!-- Now any nested list is inside this list item -->
    <xsl:apply-templates mode="subgroup"
            select="following-sibling::*[1]
                    [self::&itemizedlist; or self::&orderedlist;]
                    [&listlevel; &gt; $depth]">

      <xsl:with-param name="depth" select="$depth + 1"/>
    </xsl:apply-templates>
  </listitem>

</xsl:template>

<xsl:template match="&orderedlist;" mode="subgroup">
  <xsl:param name="depth" select="0"/>

  <xsl:variable name="stop.node"
      select="generate-id(following-sibling::*[
                        self::&itemizedlist1; or
                        self::&orderedlist1; or
                        self::&itemizedlist;[&listlevel; &lt; $depth] or
                        self::&orderedlist;[&listlevel; &lt; $depth] or
                        not(self::&itemizedlist; or 
                            self::&orderedlist; or
                            self::&continue;)]
                        [1])"/>

  <orderedlist>
    <xsl:apply-templates mode="item"
             select=".|following-sibling::&orderedlist;
                       [&listlevel; = $depth]
                       [following-sibling::*[generate-id() = $stop.node]]">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </orderedlist>
</xsl:template>

<xsl:template match="&orderedlist;[preceding-sibling::*[1]
                     [self::&itemizedlist; or 
                      self::&orderedlist; or
                      self::&continue;]]" 
                     mode="group">
  <!-- Handle with mode = group -->
</xsl:template>

<xsl:template match="&continue;" mode="item">
  <para>
    <xsl:call-template name="object.id"/>
    <xsl:apply-templates select="w:r|w:hlink"/>
  </para>
  <!-- Continue to process any immediate following -->
  <xsl:apply-templates mode="item" 
                select="following-sibling::*[1][self::&continue;]"/>
</xsl:template>

<xsl:template match="&continue;" mode="group">
  <!-- Handled in item mode -->
</xsl:template>

<xsl:template match="*" mode="item">
  <xsl:apply-templates/>
</xsl:template>


<!-- =========================================================== -->
<!--   Inline elements                                           -->
<!-- =========================================================== -->
<xsl:template match="w:hlink[w:r/w:rPr/w:rStyle[@w:val='link']]">
  <link>
    <xsl:attribute name="linkend"><xsl:value-of
            select="@w:bookmark"/></xsl:attribute>
    <xsl:apply-templates select="w:r"/>
  </link>
</xsl:template>

<xsl:template match="w:hlink[w:r/w:rPr/w:rStyle[@w:val='ulink' or @w:val='Hyperlink']]">
  <ulink url='{@w:dest}'>
    <xsl:apply-templates select="w:r"/>
  </ulink>
</xsl:template>

<xsl:template match="w:hlink[w:r/w:rPr/w:rStyle[@w:val='olink']]">
  <olink>
    <xsl:attribute name="targetdoc"><xsl:value-of
            select="@w:dest"/></xsl:attribute>
    <xsl:attribute name="targetptr"><xsl:value-of
            select="@w:bookmark"/></xsl:attribute>
    <xsl:apply-templates select="w:r"/>
  </olink>
</xsl:template>

<xsl:template match="w:hlink[w:r/w:rPr/w:rStyle[@w:val='xref']]">
  <xref>
    <xsl:attribute name="linkend"><xsl:value-of
            select="@w:bookmark"/></xsl:attribute>
  </xref>
</xsl:template>

<xsl:template match="w:r[w:rPr/w:rStyle/@w:val = 'emphasis' or
		     w:rPr/w:i]">
  <emphasis>
    <xsl:apply-templates select="w:t"/>
  </emphasis>
</xsl:template>

<xsl:template match="w:r[w:rPr/w:rStyle[@w:val = 'FootnoteReference']]">
  <footnote>
    <xsl:apply-templates/>
  </footnote>
</xsl:template>

<!-- Ignore the footnote number with the footnote text -->
<xsl:template match="w:r[w:rPr/w:rStyle[@w:val = 'FootnoteReference']]
                        [child::w:footnoteRef]">
</xsl:template>

<xsl:template match="w:footnote">
  <xsl:apply-templates/>
</xsl:template>

<!-- The footnote text -->
<xsl:template match="&footnote;">
  <para>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="w:r">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="w:t">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="object.id">
  <xsl:variable name="id">
    <xsl:apply-templates select="." mode="object.id"/>
  </xsl:variable>
  <xsl:if test="$id != ''">
    <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="w:p" mode="object.id">

  <xsl:variable name="bookmark.inside">
    <xsl:value-of select="aml:annotation
                 [@w:type = 'Word.Bookmark.Start'][1]/@w:name"/>
  </xsl:variable>

  <xsl:variable name="bookmark.preceding">
    <xsl:value-of select="preceding-sibling::*[2]
                          [self::aml:annotation
                          [@w:type = 'Word.Bookmark.Start']
                          [following-sibling::aml:annotation
                          [@w:type = 'Word.Bookmark.End']]]
                          /@w:name"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$bookmark.inside != ''">
      <xsl:value-of select="$bookmark.inside"/>
    </xsl:when>
    <xsl:when test="$bookmark.preceding != ''">
      <xsl:value-of select="$bookmark.preceding"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template match="wx:sub-section" mode="object.id">
  <!-- First para has the bookmark -->
  <xsl:value-of select="w:p[1]/aml:annotation
                 [@w:type = 'Word.Bookmark.Start'][1]/@w:name"/>
</xsl:template>

<!-- Index entry -->
<xsl:template match="w:r/w:instrText">
  <xsl:variable name="text" select="normalize-space(.)"/>

  <xsl:choose>
    <xsl:when test="starts-with($text, 'XE')">

      <xsl:variable name="primary">
        <xsl:choose>
          <xsl:when test="contains($text, ':')">
            <xsl:value-of select="substring-before(
                                  substring-after($text, 'XE &quot;'), ':')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before(
                                  substring-after($text, 'XE &quot;'), '&quot;')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <xsl:variable name="secondary">
        <xsl:choose>
          <xsl:when test="contains($text, ':')">
            <xsl:value-of select="substring-before(
                                  substring-after($text, ':'), '&quot;')"/>
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <indexterm>
        <primary><xsl:value-of select="$primary"/></primary>
        <xsl:if test="$secondary != ''">
          <secondary><xsl:value-of select="$secondary"/></secondary>
        </xsl:if>
      </indexterm>
    </xsl:when>
  </xsl:choose>
        
</xsl:template>

  <xsl:template match='w:p[w:pPr/w:pStyle/@w:val = "informalfigure-imagedata"]' mode='group'>
    <!-- Simple form of figure with no captions, titles, etc -->
    <!-- TODO: allow setting of width and height -->
    <informalfigure>
      <xsl:call-template name="object.id"/>
      <mediaobject>
        <imageobject>
          <imagedata>
            <xsl:attribute name='fileref'>
              <xsl:apply-templates select='w:r|w:hlink' mode='textonly'/>
            </xsl:attribute>
          </imagedata>
        </imageobject>
      </mediaobject>
    </informalfigure>
  </xsl:template>
<xsl:template match="&figure;" mode="group">

  <!-- Get title and caption from siblings -->
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="following-sibling::*[1][self::&figuretitle;]">
        <xsl:apply-templates 
                 mode="figuretitle"
                 select="following-sibling::*[1][self::&figuretitle;]"/>
      </xsl:when>
      <xsl:when test="preceding-sibling::*[1][self::&figuretitle;]">
        <xsl:apply-templates 
                 mode="figuretitle"
                 select="preceding-sibling::*[1][self::&figuretitle;]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- FIXME -->
  <xsl:variable name="caption"/>

  <xsl:variable name="shape" select="w:r/w:pict/v:shape"/>
  <xsl:variable name="style" select="$shape/@style"/>

  <xsl:variable name="src" select="$shape/v:imagedata/@src"/>
  <xsl:variable name="width"
                select="substring-before(
                        substring-after($style, 'width:'), ';')"/>
  <xsl:variable name="height">
    <xsl:variable name="candidate" 
                  select="substring-before(
                          substring-after($style, 'height:'), ';') != ''"/>
    <xsl:choose>
      <xsl:when test="$candidate != ''">
        <xsl:value-of select="$candidate"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after($style, 'height:')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="element">
    <xsl:choose>
      <xsl:when test="$title != ''">figure</xsl:when>
      <xsl:otherwise>informalfigure</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$element}">
    <xsl:call-template name="object.id"/>
    <xsl:if test="$title != ''">
      <title>
        <xsl:copy-of select="$title"/>
      </title>
    </xsl:if>
    <mediaobject>
      <imageobject>
        <imagedata>
          <xsl:attribute name="fileref">
            <xsl:value-of select="$src"/>
          </xsl:attribute>
          <xsl:if test="$width != ''">
            <xsl:attribute name="contentwidth">
              <xsl:value-of select="$width"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$height != ''">
            <xsl:attribute name="contentdepth">
              <xsl:value-of select="$height"/>
            </xsl:attribute>
          </xsl:if>
        </imagedata>
      </imageobject>
    </mediaobject>
  </xsl:element>

</xsl:template>

<xsl:template match="&figuretitle;" mode="group"/>

<xsl:template match="&figuretitle;" mode="figuretitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="&exampletitle;" mode="group">
  <example>
    <title>
      <xsl:apply-templates/>
    </title>
    <xsl:apply-templates mode="example"
             select="following-sibling::*[1][self::w:p or self::w:tbl]" />
  </example>
</xsl:template>


<!-- Process tables -->
<xsl:template match="w:tbl" mode="group">

  <!-- Get title and caption from siblings -->
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="following-sibling::*[1][self::&tabletitle;]">
        <xsl:apply-templates 
                 mode="tabletitle"
                 select="following-sibling::*[1][self::&tabletitle;]"/>
      </xsl:when>
      <xsl:when test="preceding-sibling::*[1][self::&tabletitle;]">
        <xsl:apply-templates 
                 mode="tabletitle"
                 select="preceding-sibling::*[1][self::&tabletitle;]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- FIXME -->
  <xsl:variable name="caption"/>

  <xsl:variable name="element">
    <xsl:choose>
      <xsl:when test="$title != ''">table</xsl:when>
      <xsl:otherwise>informaltable</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$element}">
    <xsl:call-template name="object.id"/>
    <xsl:if test="$title != ''">
      <title>
        <xsl:copy-of select="$title"/>
      </title>
    </xsl:if>

    <tgroup>
      <xsl:attribute name="cols">
        <xsl:value-of select="count(w:tblGrid/w:gridCol)"/>
      </xsl:attribute>
      <xsl:apply-templates select="w:tblGrid" mode="colspec"/>
      <xsl:if test="w:tr[descendant::w:pStyle[@w:val = 'tableheader']]">
        <thead>
          <xsl:apply-templates mode="tableheader"
                  select="w:tr[descendant::w:pStyle[@w:val = 'tableheader']]"/>
        </thead>
      </xsl:if>
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </tgroup>

  </xsl:element>

</xsl:template>

<xsl:template match="&tabletitle;" mode="group"/>

<xsl:template match="&tabletitle;" mode="tabletitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="w:tblGrid" mode="colspec">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="w:tblGrid">
</xsl:template>

<xsl:template match="w:tblGrid/w:gridCol">
  <colspec>
    <xsl:attribute name="colnum">
      <xsl:value-of select="position()"/>
    </xsl:attribute>
    <xsl:attribute name="colname">
      <xsl:value-of select="concat('col', position())"/>
    </xsl:attribute>
    <xsl:if test="@w:w != ''">
      <xsl:variable name="calcwidth">
        <xsl:value-of select="@w:w div 20"/>
      </xsl:variable>
      <xsl:attribute name="colwidth">
        <xsl:value-of select="concat($calcwidth, 'pt')"/>
      </xsl:attribute>
    </xsl:if>
  </colspec>
</xsl:template>
  
<!-- Table header row -->
<xsl:template mode="tableheader"
              match="w:tr[descendant::w:pStyle[@w:val = 'tableheader']]">
  <row>
    <xsl:apply-templates/>
  </row>
</xsl:template>

<xsl:template match="w:tr[descendant::w:pStyle[@w:val = 'tableheader']]">
  <!-- Already handled in tableheader mode -->
</xsl:template>

<xsl:template match="w:tr">
  <row>
    <xsl:apply-templates/>
  </row>
</xsl:template>

<xsl:template match="w:tc">
  <entry>
    <!-- Process any spans -->
    <xsl:call-template name="cell.span"/>
    <!-- Process as paras if more than one w:p in the cell -->
    <xsl:choose>
      <xsl:when test="count(w:p) = 1">
            <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="group"/>
      </xsl:otherwise>
    </xsl:choose>
  </entry>
</xsl:template>

<xsl:template name="cell.span">
  <xsl:variable name="span" select="0 + w:tcPr/w:gridSpan/@w:val"/>
  <xsl:if test="$span &gt; 0">
    <!-- Get the current cell number -->
    <xsl:variable name="colstart">
      <xsl:call-template name="colcount">
        <xsl:with-param name="count" select="1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:attribute name="namest"><xsl:value-of 
                 select="concat('col', $colstart)"/></xsl:attribute>
    <xsl:attribute name="nameend"><xsl:value-of
                 select="concat('col', $colstart + $span - 1)"/></xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- recursively count preceding columns, including spans -->
<xsl:template name="colcount">
  <xsl:param name="count" select="0"/>
  <xsl:param name="cell" select="."/>
  <xsl:choose>
    <xsl:when test="$cell/preceding-sibling::w:tc">
      <xsl:variable name="span" 
          select="0 + $cell/preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val"/>
      <xsl:choose>
        <xsl:when test="$span &gt; 0">
          <xsl:call-template name="colcount">
            <xsl:with-param name="count" select="$count + $span"/>
            <xsl:with-param name="cell" select="$cell/preceding-sibling::w:tc"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="colcount">
            <xsl:with-param name="count" select="$count + 1"/>
            <xsl:with-param name="cell" select="$cell/preceding-sibling::w:tc"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
<xsl:template match="w:p[w:pPr/w:pStyle[@w:val = 'tableheader']]">
  <para>
    <xsl:call-template name="object.id"/>
    <xsl:apply-templates select="w:r|w:hlink"/>
  </para>
</xsl:template>
-->

<!-- variablelist is a two-column table with table style='variablelist' -->
<xsl:template match="&variablelist;" mode="group">
  <variablelist>
    <xsl:call-template name="object.id"/>
    <xsl:apply-templates select="w:tr" mode="variablelist"/>
  </variablelist>
</xsl:template>

<xsl:template match="w:tr" mode="variablelist">
  <varlistentry>
    <term>
      <xsl:apply-templates select="w:tc[1]/*" mode="variablelist.term"/>
    </term>
    <listitem>
      <xsl:apply-templates select="w:tc[2]/*" mode="group"/> 
    </listitem>
  </varlistentry>
</xsl:template>

<!-- No para tags inside variablelist term -->
<xsl:template match="w:p" mode="variablelist.term">
  <xsl:apply-templates select="w:r|w:hlink"/>
</xsl:template>

<xsl:template match='&admontitle;' mode='group'>
  <xsl:variable name='element.name'
    select='substring-before(w:pPr/w:pStyle/@w:val, "-title")'/>

  <xsl:element name='{$element.name}'>
    <xsl:call-template name='object.id'/>
    <title>
      <xsl:apply-templates select='w:r|w:hlink'/>
    </title>

    <!-- Identify the node that follows all admonitions of the same type -->
    <xsl:variable name='stop.node'
      select='generate-id(following-sibling::w:p[w:p/w:pStyle/@w:val != $element.name][1])'/>

    <xsl:choose>
      <xsl:when test='$stop.node'>
        <xsl:apply-templates
          select='following-sibling::w:p[w:p/w:pStyle/@w:val = $element.name]
                  [generate-id(following-sibling::w:p[w:p/w:pStyle/@w:val != $element.name][1]) = $stop.node]' mode='continue'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select='following-sibling::*' mode='continue'>
          <xsl:with-param name='styles' select='concat(" ", $element.name, " para-continue ")'/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<!-- Handle admonitions without a title -->
<xsl:template match="&admon;" mode="group">
  <xsl:variable name="element.name" select="w:pPr/w:pStyle/@w:val"/>

  <xsl:variable name='title.node'
    select='preceding-sibling::w:p[w:pPr/w:pStyle/@w:val = concat($element.name, "-title")][1]'/>
  <xsl:variable name='stop.node'
    select='preceding-sibling::w:p[w:pPr/w:pStyle/@w:val != concat($element.name, "-title")][1]'/>

  <xsl:choose>
    <xsl:when test='preceding-sibling::*[1]/self::w:p[w:pPr/w:pStyle/@w:val = $element.name or w:pPr/w:pStyle/@w:val = "para-continue"]'/>
    <xsl:when test='$title.node and $stop.node and
                    count($title.node|$stop.node/preceding-sibling::*) = count($stop.node/preceding-sibling::*)'>
      <!-- The previous title is not related to this node -->
      <xsl:call-template name='make-admonition'>
        <xsl:with-param name='element.name' select='$element.name'/>
      </xsl:call-template>
    </xsl:when>

    <!-- The title node has included this node -->
    <xsl:when test='$title.node'/>

    <xsl:otherwise>
      <xsl:call-template name='make-admonition'>
        <xsl:with-param name='element.name' select='$element.name'/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template name='make-admonition'>
  <xsl:param name='element.name'/>

  <xsl:element name="{$element.name}">
    <xsl:call-template name="object.id"/>
    <para>
      <xsl:apply-templates select="w:r|w:hlink"/>
    </para>
    <xsl:apply-templates mode="continue" 
      select="following-sibling::*[1]">
      <xsl:with-param name='styles' select='concat(" ", $element.name, " para-continue ")'/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="w:p" mode="continue">
  <xsl:param name='styles' select='" para-continue "'/>

  <xsl:if test='contains($styles, concat(" ", w:pPr/w:pStyle/@w:val, " "))'>
    <para>
      <xsl:call-template name="object.id"/>
      <xsl:apply-templates select="w:r|w:hlink"/>
    </para>
    <!-- Continue to process any immediate following -->
    <xsl:apply-templates mode="continue"
                select="following-sibling::*[1]">
      <xsl:with-param name='styles' select='$styles'/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="&verbatim;[not(preceding-sibling::*[1]
                     [self::&verbatim;])]" 
                     mode="group">

  <xsl:variable name="element.name" select="w:pPr/w:pStyle/@w:val"/>
  <!-- Start the listing and process all subsequent ones too -->
  <xsl:element name="{$element.name}">
    <xsl:call-template name="object.id"/>
    <xsl:apply-templates select="." mode="item"/>
  </xsl:element>

</xsl:template>

<xsl:template match="&verbatim;[not(preceding-sibling::*[1]
                     [self::&verbatim;])]" 
                     mode="example">

  <xsl:variable name="element.name" select="w:pPr/w:pStyle/@w:val"/>
  <!-- Start the listing and process all subsequent ones too -->
  <xsl:element name="{$element.name}">
    <xsl:call-template name="object.id"/>
    <xsl:apply-templates select="." mode="item"/>
  </xsl:element>

</xsl:template>


<xsl:template match="&verbatim;[preceding-sibling::*[1]
                     [self::&verbatim;]]" 
                     mode="group">
  <!-- Non-first verbatims are handled in item mode -->
</xsl:template>

<xsl:template match="&verbatim;" mode="item">
  
  <xsl:apply-templates select="w:r|w:hlink" />
  <xsl:text>&#x0A;</xsl:text>
  <xsl:apply-templates select="following-sibling::*[1][self::&verbatim;]"
                       mode="item"/>
</xsl:template>

<xsl:template match="w:br[ancestor::&verbatim;]">
  <xsl:text>&#x0A;</xsl:text>
</xsl:template>
  
<xsl:template match="&verbatim;[preceding-sibling::*[1]
                     [self::&exampletitle;]]" 
              priority="2"
              mode="group"/>

<xsl:template match="w:tbl[preceding-sibling::*[1][self::&exampletitle;]]" 
              priority="2"
              mode="group"/>

  <xsl:template name='attributes'>
    <xsl:param name='node' select='.'/>

    <xsl:variable name='attr'
      select='$node/w:r[1][w:rPr/w:rStyle/@w:val = "attributes"]'/>
    <xsl:variable name='annotation' select='$attr/preceding-sibling::aml:annotation[1]'/>

    <xsl:if test='$attr and $annotation'>
      <xsl:variable name='comment' select='$node/w:r[w:rPr/w:rStyle/@w:val = "CommentReference"]/aml:annotation[@w:type = "Word.Comment" and @aml:id = $annotation/@aml:id]/aml:content'/>
      <xsl:for-each select='$comment/w:p/w:r[w:rPr/w:rStyle/@w:val = "attribute-name"]'>
        <xsl:attribute name='{w:t}'>
          <xsl:value-of select='following-sibling::w:r[w:rPr/w:rStyle/@w:val = "attribute-value"][1]/w:t'/>
        </xsl:attribute>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match='aml:annotation' mode='group'/>
  <xsl:template match='aml:annotation'/>
  <xsl:template match='w:r[w:rPr/w:rStyle/@w:val = "attributes"]'/>
  <xsl:template match='w:r[w:rPr/w:rStyle/@w:val = "CommentReference"]'/>

  <!-- utilities -->

  <!-- This template is invoked whenever an error condition is detected in the conversion of a WordML document.
    -->
  <xsl:template name='report-error'>
    <xsl:param name='node' select='.'/>
    <xsl:param name='message'/>

    <xsl:message><xsl:value-of select='$message'/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
