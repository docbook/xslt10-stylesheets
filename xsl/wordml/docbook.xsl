<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w='http://schemas.microsoft.com/office/word/2003/wordml'
  xmlns:v='urn:schemas-microsoft-com:vml'
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:wx='http://schemas.microsoft.com/office/word/2003/auxHint'
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
  xmlns:sl='http://schemas.microsoft.com/schemaLibrary/2003/core'
  xmlns:doc='http://www.oasis-open.org/docbook/xml/4.0'
  exclude-result-prefixes='doc'>

  <xsl:output method="xml" indent='yes' standalone='yes' encoding='UTF-8'/>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ******************************************************************** -->

  <xsl:include href='../VERSION'/>
  <xsl:include href='param.xsl'/>

  <xsl:variable name='templatedoc' select='document($wordml.template)'/>

  <xsl:template match="/">

    <xsl:if test='not($wordml.template)'>
      <xsl:message terminate='yes'>Please specify the template document with the "wordml.template" parameter</xsl:message>
    </xsl:if>
    <xsl:if test='not($templatedoc)'>
      <xsl:message terminate='yes'>Unable to open template document "<xsl:value-of select='$wordml.template'/>"</xsl:message>
    </xsl:if>

    <xsl:processing-instruction name='mso-application'>
      <xsl:text>progid="Word.Document"</xsl:text>
    </xsl:processing-instruction>
    <xsl:text>
</xsl:text>

    <xsl:variable name='info' select='book/bookinfo|article/articleinfo'/>
    <xsl:variable name='authors' select='$info/author|$info/authorinitials|$info/authorgroup/author|$info/authorgroup/editor'/>

    <w:wordDocument
      w:macrosPresent="no" w:embeddedObjPresent="no" w:ocxPresent="no">
      <xsl:attribute name='xml:space'>preserve</xsl:attribute>

      <o:DocumentProperties>
        <o:Author>
          <xsl:choose>
            <xsl:when test='$authors'>
              <xsl:apply-templates select='$authors[1]' mode='docprop.author'/>
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </o:Author>
        <o:LastAuthor>
          <xsl:choose>
            <xsl:when test='$info/revhistory/revision[1]/*[self::author|self::authorinitials]'>
              <xsl:apply-templates select='$info/revhistory/revision[1]/*[self::author|self::authorinitials]' mode='docprop.author'/>
            </xsl:when>
            <xsl:when test='$authors'>
              <xsl:apply-templates select='$authors[1]' mode='docprop.author'/>
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </o:LastAuthor>
        <o:Revision>1</o:Revision>
        <o:TotalTime></o:TotalTime>

        <!-- dummy values -->
        <o:Created>2004-01-01T07:07:00Z</o:Created>
        <o:LastSaved>2004-01-01T08:08:00Z</o:LastSaved>

        <o:Pages>1</o:Pages>
        <o:Words>1</o:Words>
        <o:Characters>1</o:Characters>

        <!-- could derive this from author -->
        <o:Company>DocBook</o:Company>

        <o:Lines>1</o:Lines>
        <o:Paragraphs>1</o:Paragraphs>
        <o:CharactersWithSpaces>1</o:CharactersWithSpaces>
        <o:Version>11.6113</o:Version>
      </o:DocumentProperties>

      <xsl:apply-templates select='$templatedoc/w:wordDocument/o:CustomDocumentProperties|$templatedoc/w:wordDocument/w:fonts|$templatedoc/w:wordDocument/w:lists|$templatedoc/w:wordDocument/w:styles' mode='copy'/>

      <w:docPr>
        <w:view w:val="print"/>
        <w:zoom w:percent="100"/>
        <w:doNotEmbedSystemFonts/>
        <w:attachedTemplate w:val=""/>
        <w:defaultTabStop w:val="720"/>
        <w:autoHyphenation/>
        <w:hyphenationZone w:val="357"/>
        <w:doNotHyphenateCaps/>
        <w:evenAndOddHeaders/>
        <w:characterSpacingControl w:val="DontCompress"/>
        <w:optimizeForBrowser/>
        <w:validateAgainstSchema/>
        <w:saveInvalidXML w:val="off"/>
        <w:ignoreMixedContent w:val="off"/>
        <w:alwaysShowPlaceholderText w:val="off"/>
        <w:footnotePr>
          <w:footnote w:type="separator">
            <w:p>
              <w:r>
                <w:separator/>
              </w:r>
            </w:p>
          </w:footnote>
          <w:footnote w:type="continuation-separator">
            <w:p>
              <w:r>
                <w:continuationSeparator/>
              </w:r>
            </w:p>
          </w:footnote>
        </w:footnotePr>
        <w:endnotePr>
          <w:endnote w:type="separator">
            <w:p>
              <w:r>
                <w:separator/>
              </w:r>
            </w:p>
          </w:endnote>
          <w:endnote w:type="continuation-separator">
            <w:p>
              <w:r>
                <w:continuationSeparator/>
              </w:r>
            </w:p>
          </w:endnote>
        </w:endnotePr>
        <w:compat>
          <w:breakWrappedTables/>
          <w:snapToGridInCell/>
          <w:wrapTextWithPunct/>
          <w:useAsianBreakRules/>
          <w:useWord2002TableStyleRules/>
        </w:compat>
        <w:docVars>
        </w:docVars>
      </w:docPr>

      <xsl:apply-templates select='*' mode='toplevel'/>

    </w:wordDocument>
  </xsl:template>

  <xsl:template match='author|editor' mode='docprop.author'>
    <xsl:apply-templates select='firstname|personname/firstname' mode='docprop.author'/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select='surname|personname/surname' mode='docprop.author'/>
  </xsl:template>
  <xsl:template match='authorinitials' mode='docprop.author'>
    <xsl:value-of select='.'/>
  </xsl:template>

  <xsl:template match='book|article' mode='toplevel'>
    <w:body>
      <xsl:apply-templates select='*'/>
    </w:body>
  </xsl:template>
  <xsl:template match='*' mode='toplevel'>
    <w:body>
      <wx:sect>
        <xsl:apply-templates select='*'/>
      </wx:sect>
    </w:body>
  </xsl:template>

  <xsl:template match='book|article|section|sect1|sect2|sect3|sect4|sect5|simplesect'>
    <wx:sect>
      <xsl:apply-templates select='*'/>
    </wx:sect>
  </xsl:template>

  <xsl:template match='title|subtitle|titleabbrev'>
    <w:p>
      <w:pPr>
        <w:pStyle>
          <xsl:attribute name='w:val'>
            <xsl:choose>
              <xsl:when test='contains(name(..), "info")'>
                <xsl:value-of select='name(../..)'/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select='name()'/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='name(..)'/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select='name()'/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </w:pStyle>
      </w:pPr>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <doc:template name='metadata' xmlns=''>
    <title>Metadata</title>

    <para>TODO: Handle all metadata elements, apart from titles.</para>
  </doc:template>
  <xsl:template match='*[contains(name(), "info")]/*[not(self::title|self::subtitle|self::titleabbrev)]'/>

  <xsl:template match='para'>
    <xsl:param name='class'/>

    <xsl:variable name='block' select='blockquote|calloutlist|classsynopsis|funcsynopsis|figure|glosslist|graphic|informalfigure|informaltable|itemizedlist|literallayout|mediaobject|note|orderedlist|programlisting|revhistory|segmentedlist|simplelist|table|variablelist'/>

    <xsl:choose>
      <xsl:when test='$block'>
        <w:p>
          <w:pPr>
            <w:pStyle>
              <xsl:attribute name='w:val'>
                <xsl:choose>
                  <xsl:when test='$class != ""'>
                    <xsl:value-of select='$class'/>
                  </xsl:when>
                  <xsl:otherwise>Normal</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </w:pStyle>
          </w:pPr>
          <xsl:apply-templates select='$block[1]/preceding-sibling::node()'/>
        </w:p>
        <xsl:for-each select='$block'>
          <xsl:apply-templates select='.'/>
          <w:p>
            <w:pPr>
              <w:pStyle>
                <xsl:attribute name='w:val'>
                  <xsl:choose>
                    <xsl:when test='$class != ""'>
                      <xsl:value-of select='$class'/>
                    </xsl:when>
                    <xsl:otherwise>Normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </w:pStyle>
            </w:pPr>
            <xsl:apply-templates select='following-sibling::node()[generate-id(preceding-sibling::*[self::blockquote|self::calloutlist|self::figure|self::glosslist|self::graphic|self::informalfigure|self::informaltable|self::itemizedlist|self::literallayout|self::mediaobject|self::note|self::orderedlist|self::programlisting|self::revhistory|self::segmentedlist|self::simplelist|self::table|self::variablelist][1]) = generate-id(current())]'/>
          </w:p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <w:p>
          <w:pPr>
            <w:pStyle>
              <xsl:attribute name='w:val'>
                <xsl:choose>
                  <xsl:when test='$class != ""'>
                    <xsl:value-of select='$class'/>
                  </xsl:when>
                  <xsl:otherwise>Normal</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </w:pStyle>
          </w:pPr>
          <xsl:apply-templates/>
        </w:p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='simpara'>
    <xsl:param name='class'/>

    <w:p>
      <w:pPr>
        <w:pStyle>
          <xsl:attribute name='w:val'>
            <xsl:choose>
              <xsl:when test='$class != ""'>
                <xsl:value-of select='concat("sim-", $class)'/>
              </xsl:when>
              <xsl:otherwise>simpara</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </w:pStyle>
      </w:pPr>

      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <xsl:template match='emphasis'>
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

  <xsl:template match='table|informaltable'>

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

  <xsl:template match='*[self::para|self::simpara]/text()[string-length(normalize-space(.)) != 0]'>
    <w:r>
      <w:t>
        <xsl:value-of select='.'/>
      </w:t>
    </w:r>
  </xsl:template>

  <xsl:template match='text()[not(parent::para|parent::simpara)][string-length(normalize-space(.)) != 0]'>
    <w:r>
      <w:t>
        <xsl:value-of select='.'/>
      </w:t>
    </w:r>
  </xsl:template>
  <xsl:template match='text()[string-length(normalize-space(.)) = 0]'/>

  <xsl:template match='authorblurb|formalpara|legalnotice|note'>
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
        <xsl:apply-templates select='attribution/node()'/>
      </w:p>
    </xsl:if>
  </xsl:template>

  <xsl:template match='itemizedlist|orderedlist'>
    <xsl:apply-templates select='listitem'/>
  </xsl:template>

  <xsl:template match='listitem'>
    <w:p>
      <w:pPr>
        <w:listPr>
          <wx:t wx:val='&#xB7;'/>
          <wx:font wx:val='Symbol'/>
        </w:listPr>
      </w:pPr>
      <xsl:apply-templates select='para' mode='list'/>
    </w:p>
    
  </xsl:template>  

  <xsl:template match='*' mode='list'>
    <xsl:apply-templates/>
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

  <xsl:template match='*'>
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
                      self::caution |
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
                      self::important |
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
                      self::releaseinfo |
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
                      self::tip |
                      self::toc |
                      self::variablelist |
                      self::varlistentry |
                      self::videodata |
                      self::videoobject |
                      self::warning |
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

  <xsl:template match='*' mode='copy'>
    <xsl:copy>
      <xsl:for-each select='@*'>
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates mode='copy'/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
