<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sfa="http://developer.apple.com/namespaces/sfa"
  xmlns:sf="http://developer.apple.com/namespaces/sf"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:sl="http://developer.apple.com/namespaces/sl"
  xmlns:w='urn:not-yet-implemented'
  xmlns:wx='urn:not-yet-implemented'
  xmlns:aml='urn:not-yet-implemented'
  xmlns:doc='http://www.oasis-open.org/docbook/xml/4.0'
  exclude-result-prefixes='doc'>

  <xsl:output method="xml" indent='no' encoding='ascii'/>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ******************************************************************** -->

  <xsl:include href='../VERSION'/>
  <xsl:include href='param.xsl'/>

  <xsl:variable name='templatedoc' select='document($pages.template)'/>

  <xsl:template match="/" name='pages.top'>
    <xsl:param name='doc' select='/'/>

    <xsl:if test='not($pages.template)'>
      <xsl:message terminate='yes'>Please specify the template document with the "pages.template" parameter</xsl:message>
    </xsl:if>
    <xsl:if test='not($templatedoc)'>
      <xsl:message terminate='yes'>Unable to open template document "<xsl:value-of select='$pages.template'/>"</xsl:message>
    </xsl:if>

    <sl:document
      sfa:ID="SLPublicationModel-0"
      sl:version="2004093000"
      sl:generator="slingshot"
      sl:app_build_date="Mar  4 2005, 11:22:49">

      <xsl:apply-templates select='$templatedoc/sl:document/*[not(self::sf:text-storage)]' mode='copy'/>

      <xsl:apply-templates select='$doc/*' mode='toplevel'/>

      <xsl:apply-templates select='$templatedoc/sl:document/sf:text-storage/following-sibling::*' mode='copy'/>
    </sl:document>
  </xsl:template>

  <xsl:template match='book|article' mode='toplevel'>
    <sf:text-storage sf:kind='body' sfa:ID='SFWPStorage-7'>
      <sf:stylesheet-ref sfa:IDREF='SFSStylesheet-1'/>
      <sf:text-body>
        <sf:page-start sf:page-index='0'/>
        <sf:container-hint sf:page-index="0" sf:cindex="0" sf:sindex="0" sf:lindex="0" sf:frame-x="56.692913055419922" sf:frame-y="56.692913055419922" sf:frame-w="481.61416625976562" sf:frame-h="714" sf:anchor-loc="0"/>
        <sf:section sf:name="Chapter 1" sf:style="section-style-0">
          <sf:layout sf:style="layout-style-20">
            <xsl:apply-templates select='*'/>
          </sf:layout>
        </sf:section>
      </sf:text-body>
    </sf:text-storage>
  </xsl:template>

  <xsl:template match='book|article|section|sect1|sect2|sect3|sect4|sect5|simplesect'>
    <xsl:apply-templates select='*'/>
  </xsl:template>

  <xsl:template match='articleinfo|bookinfo'>
    <xsl:apply-templates select='title|subtitle|titleabbrev'/>
    <xsl:apply-templates select='author|releaseinfo'/>
    <!-- current implementation ignores all other metadata -->
    <xsl:for-each select='*[not(self::title|self::subtitle|self::titleabbrev|self::author|self::releaseinfo)]'>
      <xsl:call-template name='nomatch'/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match='title|subtitle|titleabbrev'>
    <sf:p>
      <xsl:attribute name='sf:style'>
        <xsl:text>paragraph-style-</xsl:text>
        <xsl:choose>
          <xsl:when test='(parent::section or
                          parent::sectioninfo/parent::section) and
                          count(ancestor::section) > 5'>
            <xsl:message>section nested deeper than 5 levels</xsl:message>
            <xsl:text>50</xsl:text>
          </xsl:when>
          <xsl:when test='parent::section or
                          parent::sectioninfo/parent::section'>
            <xsl:text>52</xsl:text>
          </xsl:when>
          <xsl:when test='parent::book|../parent::book'>
            <xsl:text>3</xsl:text>
          </xsl:when>
          <xsl:when test='parent::article|../parent::article'>
            <xsl:text>38</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>38</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
       </xsl:attribute>

       <xsl:apply-templates/>
       <sf:br/>
    </sf:p>
  </xsl:template>

  <doc:template name='metadata' xmlns=''>
    <title>Metadata</title>

    <para>TODO: Handle all metadata elements, apart from titles.</para>
  </doc:template>
  <xsl:template match='*[contains(name(), "info")]/*[not(self::title|self::subtitle|self::titleabbrev)]' priority='0'/>

  <xsl:template match='author|editor|othercredit' mode='not-yet-implemented'>
    <w:p>
      <w:pPr>
        <w:pStyle w:val='{name()}'/>
      </w:pPr>

      <xsl:call-template name='attributes'/>

      <xsl:apply-templates select='personname|surname|firstname|honorific|lineage|othername|contrib'/>
    </w:p>
    <xsl:apply-templates select='affiliation|address'/>
    <xsl:apply-templates select='authorblurb|personblurb'/>
  </xsl:template>
  <xsl:template match='affiliation' mode='not-yet-implemented'>
    <w:p>
      <w:pPr>
        <w:pStyle w:val='affiliation'/>
      </w:pPr>

      <xsl:call-template name='attributes'/>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  <xsl:template match='address[parent::author|parent::editor|parent::othercredit]' mode='not-yet-implemented'>
    <w:p>
      <w:pPr>
        <w:pStyle w:val='para-continue'/>
      </w:pPr>

      <xsl:call-template name='attributes'/>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  <!-- do not attempt to handle recursive structures -->
  <xsl:template match='address[not(parent::author|parent::editor|parent::othercredit)]'>
    <xsl:apply-templates select='node()[not(self::affiliation|self::authorblurb)]'/>
  </xsl:template>
  <!-- TODO -->
  <xsl:template match='authorblurb|personblurb'/>

  <!-- TODO: handle inline markup (eg. emphasis) -->
  <xsl:template match='surname|firstname|honorific|lineage|othername|contrib|email|shortaffil|jobtitle|orgname|orgdiv|street|pob|postcode|city|state|country|phone|fax' mode='not-yet-implemented'>
    <xsl:if test='preceding-sibling::*'>
      <w:r>
        <w:t>
          <xsl:text> </xsl:text>
        </w:t>
      </w:r>
    </xsl:if>
    <w:r>
      <w:rPr>
        <w:rStyle w:val='{name()}'/>
      </w:rPr>

      <xsl:apply-templates mode='text-run'/>
    </w:r>
  </xsl:template>
  <xsl:template match='email' mode='not-yet-implemented'>
    <xsl:variable name='address'>
      <xsl:choose>
        <xsl:when test='starts-with(., "mailto:")'>
          <xsl:value-of select='.'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>mailto:</xsl:text>
          <xsl:value-of select='.'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <w:hlink w:dest='{$address}'>
      <w:r>
        <w:rPr>
          <w:rStyle w:val='Hyperlink'/>
        </w:rPr>
        <xsl:apply-templates mode='text-run'/>
      </w:r>
    </w:hlink>
  </xsl:template>
  <!-- otheraddr often contains ulink -->
  <xsl:template match='otheraddr' mode='not-yet-implemented'>
    <xsl:choose>
      <xsl:when test='ulink'>
        <xsl:for-each select='ulink'>
          <xsl:variable name='prev' select='preceding-sibling::ulink[1]'/>
          <xsl:choose>
            <xsl:when test='$prev'>
              <xsl:for-each
                select='preceding-sibling::node()[generate-id(following-sibling::ulink[1]) = generate-id(current())]'>
                <w:r>
                  <w:rPr>
                    <w:rStyle w:val='otheraddr'/>
                  </w:rPr>
                  <xsl:apply-templates select='.' mode='text-run'/>
                </w:r>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test='preceding-sibling::node()'>
              <w:r>
                <w:rPr>
                  <w:rStyle w:val='otheraddr'/>
                </w:rPr>
                <xsl:apply-templates mode='text-run'/>
              </w:r>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select='.'/>
        </xsl:for-each>
        <xsl:if test='ulink[last()]/following-sibling::node()'>
          <w:r>
            <w:rPr>
              <w:rStyle w:val='otheraddr'/>
            </w:rPr>
            <xsl:apply-templates select='ulink[last()]/following-sibling::node()' mode='text-run'/>
          </w:r>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <w:r>
          <w:rPr>
            <w:rStyle w:val='otheraddr'/>
          </w:rPr>
          <xsl:apply-templates mode='text-run'/>
        </w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='ulink' mode='not-yet-implemented'>
    <w:hlink w:dest='{@url}'>
      <w:r>
        <w:rPr>
          <w:rStyle w:val='Hyperlink'/>
        </w:rPr>
      </w:r>
      <xsl:apply-templates mode='text-run'/>
    </w:hlink>
  </xsl:template>

  <!-- Cannot round-trip this element -->
  <xsl:template match='personname'>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='releaseinfo' mode='not-yet-implemented'>
    <w:p>
      <w:pPr>
        <w:pStyle w:val='releaseinfo'/>
      </w:pPr>

      <xsl:call-template name='attributes'/>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <xsl:template match='para'>
    <xsl:param name='class'/>

    <xsl:variable name='block' select='blockquote|calloutlist|classsynopsis|funcsynopsis|figure|glosslist|graphic|informalfigure|informaltable|itemizedlist|literallayout|mediaobject|note|caution|warning|important|tip|orderedlist|programlisting|revhistory|segmentedlist|simplelist|table|variablelist'/>

    <xsl:choose>
      <xsl:when test='$block'>
        <sf:p sf:style='paragraph-style-32'>

          <!-- <xsl:call-template name='attributes'/> -->

          <xsl:apply-templates select='$block[1]/preceding-sibling::node()'/>
          <sf:br/>
        </sf:p>
        <xsl:for-each select='$block'>
          <xsl:apply-templates select='.'/>
          <sf:p sf:style='paragraph-style-32'>
            <xsl:apply-templates select='following-sibling::node()[generate-id(preceding-sibling::*[self::blockquote|self::calloutlist|self::figure|self::glosslist|self::graphic|self::informalfigure|self::informaltable|self::itemizedlist|self::literallayout|self::mediaobject|self::note|self::caution|self::warning|self::important|self::tip|self::orderedlist|self::programlisting|self::revhistory|self::segmentedlist|self::simplelist|self::table|self::variablelist][1]) = generate-id(current())]'/>
            <sf:br/>
          </sf:p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <sf:p sf:style='paragraph-style-32'>

          <!-- <xsl:call-template name='attributes'/> -->

          <sf:br/>
          <xsl:apply-templates/>
        </sf:p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='simpara'>
    <xsl:param name='class'/>

    <sf:p sf:style='paragraph-style-55'>

      <!-- <xsl:call-template name='attributes'/> -->

      <xsl:apply-templates/>
      <sf:br/>
    </sf:p>
  </xsl:template>

  <xsl:template match='emphasis' mode='not-yet-implemented'>
    <w:r>
      <w:rPr>
        <xsl:if test='@role = "bold" or @role = "strong"'>
          <w:b/>
        </xsl:if>
        <xsl:if test='not(@role)'>
          <w:i/>
        </xsl:if>
      </w:rPr>
    </w:r>
    <w:r>
      <w:t>
        <xsl:value-of select='.'/>
      </w:t>
    </w:r>
  </xsl:template>

  <xsl:template match='table|informaltable' mode='not-yet-implemented'>

    <w:tbl>
      <w:tblPr>
        <w:tblW w:w="0" w:type="auto"/>
        <w:tblInd w:w="108" w:type="dxa"/>
        <w:tblLayout w:type="Fixed"/>
      </w:tblPr>
      <w:tblGrid>
        <xsl:apply-templates select='tgroup/colspec' mode='column'/>
      </w:tblGrid>
      <xsl:apply-templates/>
    </w:tbl>
  </xsl:template>

  <xsl:template match='colspec' mode='column'>
    <w:gridcol w:w='{@colwidth}'/>
  </xsl:template>

  <xsl:template match='colspec'/>

  <xsl:template name='repeat'>
    <xsl:param name='repeats' select='0'/>
    <xsl:param name='content'/>

    <xsl:if test='$repeats > 0'>
      <xsl:copy-of select='$content'/>
      <xsl:call-template name='repeat'>
        <xsl:with-param name='repeats' select='$repeats - 1'/>
        <xsl:with-param name='content' select='$content'/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match='tgroup|tbody|thead'>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match='row'>
    <w:tr>
      <w:trPr>
        <xsl:if test='parent::thead'>
          <w:tblHeader/>
        </xsl:if>
      </w:trPr>
      <xsl:apply-templates/>
    </w:tr>
  </xsl:template>

  <xsl:template match='entry'>

    <!-- 
         Position = Sum(i,preceding-sibling[@colspan = ""]) + entry[i].@colspan)
      -->

    <xsl:variable name='position'>
      <xsl:call-template name='sumSibling'>
        <xsl:with-param name='sum' select='"1"'/>
        <xsl:with-param name='node' select='.'/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name='limit' select='$position + @colspan'/>
    <w:tc>
      <w:tcPr>
        <xsl:choose>
          <xsl:when test='@colspan != ""'>

            <!-- Select all the colspec nodes which correspond to the
                 column. That is all the nodes between the current 
                 column number and the column number plus the span.
              -->

            <xsl:variable name='combinedWidth'>
              <xsl:call-template name='sum'>
                <xsl:with-param name='nodes' select='ancestor::*[self::table|self::informaltable][1]/tgroup/colspec[not(position() &lt; $position) and position() &lt; $limit]'/>
                <xsl:with-param name='sum' select='"0"'/>
              </xsl:call-template>
            </xsl:variable>
            <w:tcW w:w='{$combinedWidth}' w:type='dxa'/>
          </xsl:when>
          <xsl:otherwise>
            <w:tcW w:w='{ancestor::*[self::table|self::informaltable][1]/tgroup/colspec[position() = $position]/@colwidth}' w:type='dxa'/>
          </xsl:otherwise>
        </xsl:choose>

      </w:tcPr>
      <xsl:if test='@hidden != ""'>
          <w:vmerge w:val=''/>
      </xsl:if>
      <xsl:if test='@rowspan != ""'>          
        <w:vmerge w:val='restart'/>
      </xsl:if>        
      <xsl:if test='@colspan != ""'>
        <w:gridspan w:val='{@colspan}'/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test='not(para)'>
          <!-- TODO: check for any block elements -->
          <w:p>
            <xsl:apply-templates/>
          </w:p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </w:tc>
  </xsl:template>

  <!-- Calculates the position by adding the 
       count of the preceding siblings where they aren't colspans
       and adding the colspans of those entries which do.
    -->

  <xsl:template name='sumSibling'>    
    <xsl:param name='sum'/>
    <xsl:param name='node'/>

    <xsl:variable name='add'>
      <xsl:choose>
        <xsl:when test='$node/preceding-sibling::entry/@colspan != ""'>
          <xsl:value-of select='$node/preceding-sibling::entry/@colspan'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='"1"'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test='count($node/preceding-sibling::entry) &gt; 0'>
        <xsl:call-template name='sumSibling'>
          <xsl:with-param name='sum' select='$sum + $add'/>
          <xsl:with-param name='node' select='$node/preceding-sibling::entry[1]'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='$sum'/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name='sum'>
    <xsl:param name='sum' select='"0"'/>
    <xsl:param name='nodes'/>

    <xsl:variable name='tmpSum' select='$sum + $nodes[1]/@colwidth'/>

    <xsl:choose>
      <xsl:when test='count($nodes) &gt; 1'>
        <xsl:call-template name='sum'>
          <xsl:with-param name='nodes' select='$nodes[position() != 1]'/>
          <xsl:with-param name='sum' select='$tmpSum'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='$tmpSum'/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match='*[self::para|self::simpara]/text()[string-length(normalize-space(.)) != 0]' mode='not-yet-implemented'>
    <w:r>
      <w:t>
        <xsl:value-of select='.'/>
      </w:t>
    </w:r>
  </xsl:template>

  <xsl:template match='text()[not(parent::para|parent::simpara|parent::literallayout)][string-length(normalize-space(.)) != 0]' mode='not-yet-implemented'>
    <w:r>
      <w:t>
        <xsl:value-of select='.'/>
      </w:t>
    </w:r>
  </xsl:template>
  <xsl:template match='text()[string-length(normalize-space(.)) = 0]'/>
  <xsl:template match='text()' mode='text-run'>
    <w:t>
      <xsl:value-of select='.'/>
    </w:t>
  </xsl:template>
  <xsl:template match='literallayout/text()'>
    <xsl:call-template name='handle-linebreaks'/>
  </xsl:template>
  <xsl:template name='handle-linebreaks'>
    <xsl:param name='text' select='.'/>

    <xsl:choose>
      <xsl:when test='not($text)'/>
      <xsl:when test='contains($text, "&#xa;")'>
        <w:r>
          <w:t>
            <xsl:value-of select='substring-before($text, "&#xa;")'/>
          </w:t>
        </w:r>
        <xsl:call-template name='handle-linebreaks-aux'>
          <xsl:with-param name='text'
            select='substring-after($text, "&#xa;")'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <w:r>
          <w:t>
            <xsl:value-of select='$text'/>
          </w:t>
        </w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- pre-condition: leading linefeed has been stripped -->
  <xsl:template name='handle-linebreaks-aux'>
    <xsl:param name='text'/>

    <xsl:choose>
      <xsl:when test='contains($text, "&#xa;")'>
        <w:r>
          <w:br/>
          <w:t>
            <xsl:value-of select='substring-before($text, "&#xa;")'/>
          </w:t>
        </w:r>
        <xsl:call-template name='handle-linebreaks-aux'>
          <xsl:with-param name='text' select='substring-after($text, "&#xa;")'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <w:r>
          <w:br/>
          <w:t>
            <xsl:value-of select='$text'/>
          </w:t>
        </w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='authorblurb|formalpara|legalnotice|note|caution|warning|important|tip'>
    <xsl:apply-templates select='*'>
      <xsl:with-param name='class'>
        <xsl:value-of select='name()'/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='blockquote'>
    <xsl:apply-templates select='blockinfo|title'>
      <xsl:with-param name='class'>
        <xsl:value-of select='name()'/>
      </xsl:with-param>
    </xsl:apply-templates>
    <xsl:apply-templates select='*[not(self::blockinfo|self::title|self::attribution)]'>
      <xsl:with-param name='class' select='"blockquote"'/>
    </xsl:apply-templates>
    <xsl:if test='attribution'>
      <w:p>
        <w:pPr>
          <w:pStyle w:val='blockquote-attribution'/>
        </w:pPr>

        <xsl:call-template name='attributes'/>

        <xsl:apply-templates select='attribution/node()'/>
      </w:p>
    </xsl:if>
  </xsl:template>

  <xsl:template match='literallayout'>
    <xsl:param name='class'/>

    <w:p>
      <w:pPr>
        <w:pStyle w:val='literallayout'/>
      </w:pPr>

      <xsl:call-template name='attributes'/>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <xsl:template match='itemizedlist|orderedlist'>
    <xsl:apply-templates select='listitem'/>
  </xsl:template>

  <xsl:template match='listitem'>
    <w:p>
      <w:pPr>
        <!-- variablelist listitems are not handled here -->
        <w:pStyle w:val='{name(..)}{count(ancestor::itemizedlist|ancestor::orderedlist)}'/>
        <w:listPr>
          <wx:t wx:val='&#xB7;'/>
          <wx:font wx:val='Symbol'/>
        </w:listPr>
      </w:pPr>
      <!-- Normally a para would be the first child of a listitem -->
      <xsl:apply-templates select='*[1][self::para]/node()' mode='list'/>
    </w:p>
    <!-- This is to catch the case where a listitem's first child is not a paragraph.
       - We may not be able to represent this properly.
      -->
    <xsl:apply-templates select='*[1][not(self::para)]' mode='list'/>

    <xsl:apply-templates select='*[position() != 1]' mode='list'/>
  </xsl:template>  

  <xsl:template match='*' mode='list'>
    <xsl:apply-templates select='.'>
      <xsl:with-param name='class' select='"para-continue"'/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='variablelist'>
    <xsl:apply-templates select='*[not(self::varlistentry)]'/>

    <w:tbl>
      <w:tblPr>
        <w:tblW w:w='0' w:type='auto'/>
        <w:tblInd w:w='108' w:type='dxa'/>
        <w:tblLayout w:type='Fixed'/>
      </w:tblPr>
      <w:tblGrid>
        <w:gridcol w:w='2160'/>
        <w:gridcol w:w='6480'/>
      </w:tblGrid>
      <xsl:apply-templates select='varlistentry'/>
    </w:tbl>
  </xsl:template>
  <xsl:template match='varlistentry'>
    <w:tr>
      <w:trPr>
      </w:trPr>

      <w:tc>
        <w:tcPr>
          <w:tcW w:w='2160' w:type='dxa'/>
        </w:tcPr>
        <w:p>
          <w:pPr>
            <w:pStyle w:val='variablelist-term'/>
          </w:pPr>
          <xsl:apply-templates select='term[1]/node()'/>
          <xsl:for-each select='term[position() != 1]'>
            <w:r>
              <w:br/>
            </w:r>
            <xsl:apply-templates/>
          </xsl:for-each>
        </w:p>
      </w:tc>
      <w:tc>
        <w:tcPr>
          <w:tcW w:w='6480' w:type='dxa'/>
        </w:tcPr>
        <xsl:apply-templates select='listitem/node()'/>
      </w:tc>
    </w:tr>
  </xsl:template>

  <!-- These elements are not displayed.
     - However, they may need to be added (perhaps as hidden text)
     - for round-tripping.
    -->
  <xsl:template match='anchor|area|areaset|areaspec|audiodata|audioobject|
                       beginpage|
                       callout|constraint|
                       indexterm|itermset|
                       keywordset|
                       msg'/>

  <xsl:template match='*' name='nomatch'>
    <xsl:message>
      <xsl:value-of select='name()'/>
      <xsl:text> encountered</xsl:text>
      <xsl:if test='parent::*'>
        <xsl:text> in </xsl:text>
        <xsl:value-of select='name(parent::*)'/>
      </xsl:if>
      <xsl:text>, but no template matches.</xsl:text>
    </xsl:message>

    <xsl:choose>
      <xsl:when test='self::abstract |
                      self::ackno |
                      self::address |
                      self::answer |
                      self::appendix |
                      self::artheader |
                      self::authorgroup |
                      self::bibliodiv |
                      self::biblioentry |
                      self::bibliography |
                      self::bibliomixed |
                      self::bibliomset |
                      self::biblioset |
                      self::bridgehead |
                      self::calloutlist |
                      self::caption |
                      self::chapter |
                      self::classsynopsis |
                      self::colophon |
                      self::constraintdef |
                      self::copyright |
                      self::dedication |
                      self::epigraph |
                      self::equation |
                      self::example |
                      self::figure |
                      self::funcsynopsis |
                      self::glossary |
                      self::glossdef |
                      self::glossdiv |
                      self::glossentry |
                      self::glosslist |
                      self::graphic |
                      self::highlights |
                      self::imageobject |
                      self::imageobjectco |
                      self::index |
                      self::indexdiv |
                      self::indexentry |
                      self::informalequation |
                      self::informalexample |
                      self::informalfigure |
                      self::lot |
                      self::lotentry |
                      self::mediaobject |
                      self::mediaobjectco |
                      self::member |
                      self::msgentry |
                      self::msgset |
                      self::part |
                      self::partintro |
                      self::personblurb |
                      self::preface |
                      self::printhistory |
                      self::procedure |
                      self::programlisting |
                      self::programlistingco |
                      self::publisher |
                      self::qandadiv |
                      self::qandaentry |
                      self::qandaset |
                      self::question |
                      self::refdescriptor |
                      self::refentry |
                      self::refentrytitle |
                      self::reference |
                      self::refmeta |
                      self::refname |
                      self::refnamediv |
                      self::refpurpose |
                      self::refsect1 |
                      self::refsect2 |
                      self::refsect3 |
                      self::refsection |
                      self::refsynopsisdiv |
                      self::screen |
                      self::screenco |
                      self::screenshot |
                      self::seg |
                      self::seglistitem |
                      self::segmentedlist |
                      self::segtitle |
                      self::set |
                      self::setindex |
                      self::sidebar |
                      self::simplelist |
                      self::simplemsgentry |
                      self::step |
                      self::stepalternatives |
                      self::subjectset |
                      self::substeps |
                      self::task |
                      self::textobject |
                      self::toc |
                      self::videodata |
                      self::videoobject |
                      self::*[not(starts-with(name(), "informal")) and contains(name(), "info")]'>
        <w:p>
          <w:pPr>
            <w:pStyle w:val='blockerror'/>
          </w:pPr>
          <w:r>
            <w:t>
              <xsl:value-of select='name()'/>
              <xsl:text> encountered</xsl:text>
              <xsl:if test='parent::*'>
                <xsl:text> in </xsl:text>
                <xsl:value-of select='name(parent::*)'/>
              </xsl:if>
              <xsl:text>, but no template matches.</xsl:text>
            </w:t>
          </w:r>
        </w:p>
      </xsl:when>
      <!-- Some elements are sometimes blocks, sometimes inline
      <xsl:when test='self::affiliation |
                      self::alt |
                      self::attribution |
                      self::collab |
                      self::collabname |
                      self::confdates |
                      self::confgroup |
                      self::confnum |
                      self::confsponsor |
                      self::conftitle |
                      self::contractnum |
                      self::contractsponsor |
                      self::contrib |
                      self::corpauthor |
                      self::corpcredit |
                      self::corpname |
                      self::edition |
                      self::editor |
                      self::jobtitle |
                      self::personname |
                      self::publishername |
                      self::remark'>

      </xsl:when>
      -->
      <xsl:otherwise>
        <w:r>
          <w:rPr>
            <w:rStyle w:val='inlineerror'/>
          </w:rPr>
          <w:t>
            <xsl:value-of select='name()'/>
            <xsl:text> encountered</xsl:text>
            <xsl:if test='parent::*'>
              <xsl:text> in </xsl:text>
              <xsl:value-of select='name(parent::*)'/>
            </xsl:if>
            <xsl:text>, but no template matches.</xsl:text>
          </w:t>
        </w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='attributes'>
    <xsl:param name='node' select='.'/>

    <xsl:if test='$node/@*'>
      <aml:annotation aml:id='{count(preceding::*) + 1}' w:type='Word.Comment.Start'/>
      <w:r>
        <w:rPr>
          <w:rStyle w:val='attributes'/>
        </w:rPr>
        <w:t>
          <xsl:text> </xsl:text>
        </w:t>
      </w:r>
      <aml:annotation aml:id='{count(preceding::*) + 1}' w:type='Word.Comment.End'/>
      <w:r>
        <w:rPr>
          <w:rStyle w:val='CommentReference'/>
        </w:rPr>
        <aml:annotation aml:id='{count(preceding::*) + 1}' aml:author="DocBook" aml:createdate='2004-12-23T00:01:00' w:type='Word.Comment' w:initials='DBK'>
          <aml:content>
            <w:p>
              <w:pPr>
                <w:pStyle w:val='CommentText'/>
              </w:pPr>
              <w:r>
                <w:rPr>
                  <w:rStyle w:val='CommentReference'/>
                </w:rPr>
                <w:annotationRef/>
              </w:r>
              <xsl:for-each select='$node/@*'>
                <w:r>
                  <w:rPr>
                    <w:rStyle w:val='attribute-name'/>
                  </w:rPr>
                  <w:t>
                    <xsl:value-of select='name()'/>
                  </w:t>
                </w:r>
                <w:r>
                  <w:t>=</w:t>
                </w:r>
                <w:r>
                  <w:rPr>
                    <w:rStyle w:val='attribute-value'/>
                  </w:rPr>
                  <w:t>
                    <xsl:value-of select='.'/>
                  </w:t>
                </w:r>
              </xsl:for-each>
            </w:p>
          </aml:content>
        </aml:annotation>
      </w:r>
    </xsl:if>
  </xsl:template>

  <xsl:template match='*' mode='copy'>
    <xsl:copy>
      <xsl:for-each select='@*'>
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates mode='copy'/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
