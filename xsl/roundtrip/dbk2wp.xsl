<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc='http://docbook.org/ns/docbook'
  exclude-result-prefixes='doc'>

  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ******************************************************************** -->

  <xsl:include href='../VERSION'/>

  <!-- doc:docprop.author mode is for creating document metadata -->

  <xsl:template match='author|editor' mode='doc:docprop.author'>
    <xsl:apply-templates select='firstname|personname/firstname' mode='doc:docprop.author'/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select='surname|personname/surname' mode='doc:docprop.author'/>
  </xsl:template>
  <xsl:template match='authorinitials' mode='doc:docprop.author'>
    <xsl:value-of select='.'/>
  </xsl:template>

  <!-- doc:toplevel mode is for processing whole documents -->

  <xsl:template match='*' mode='doc:toplevel'>
    <xsl:call-template name='doc:make-body'/>
  </xsl:template>

  <!-- doc:body mode is for processing components of a document -->

  <xsl:template match='book|article|chapter|section|sect1|sect2|sect3|sect4|sect5|simplesect' mode='doc:body'>
    <xsl:call-template name='doc:make-subsection'/>
  </xsl:template>

  <xsl:template match='articleinfo |
		       chapterinfo |
		       bookinfo' mode='doc:body'>
    <xsl:apply-templates select='title|subtitle|titleabbrev' mode='doc:body'/>
    <xsl:apply-templates select='author|releaseinfo' mode='doc:body'/>
    <!-- current implementation ignores all other metadata -->
    <xsl:for-each select='*[not(self::title|self::subtitle|self::titleabbrev|self::author|self::releaseinfo)]'>
      <xsl:call-template name='doc:nomatch'/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match='title|subtitle|titleabbrev' mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style'>
	<xsl:choose>
          <xsl:when test='(parent::section or
                          parent::sectioninfo/parent::section) and
                          count(ancestor::section) > 5'>
            <xsl:call-template name='doc:warning'>
	      <xsl:with-param name='message'>section nested deeper than 5 levels</xsl:with-param>
	    </xsl:call-template>
            <xsl:text>sect5-</xsl:text>
            <xsl:value-of select='name()'/>
          </xsl:when>
          <xsl:when test='parent::section or
                          parent::sectioninfo/parent::section'>
            <xsl:text>sect</xsl:text>
            <xsl:value-of select='count(ancestor::section)'/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select='name()'/>
          </xsl:when>
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
      </xsl:with-param>
      <xsl:with-param name='outline.level'
		      select='count(ancestor::*) - count(parent::*[contains(name(), "info")]) - 1'/>
      <xsl:with-param name='attributes.node'
		      select='../parent::*[contains(name(current()), "info")] |
			      parent::*[not(contains(name(current()), "info"))]'/>
      <xsl:with-param name='content'>
	<xsl:apply-templates mode='doc:body'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <doc:template name='metadata' xmlns=''>
    <title>Metadata</title>

    <para>TODO: Handle all metadata elements, apart from titles.</para>
  </doc:template>
  <xsl:template match='*[contains(name(), "info")]/*[not(self::title|self::subtitle|self::titleabbrev)]'
		priority='0'
		mode='doc:body'/>

  <xsl:template match='author|editor|othercredit' mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style'
		      select='name()'/>
      <xsl:with-param name='content'>
	<xsl:apply-templates select='personname|surname|firstname|honorific|lineage|othername|contrib'
			     mode='doc:body'/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates select='affiliation|address' mode='doc:body'/>
    <xsl:apply-templates select='authorblurb|personblurb' mode='doc:body'/>
  </xsl:template>
  <xsl:template match='affiliation' mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='"affiliation"'/>
      <xsl:with-param name='content'>
	<xsl:apply-templates mode='doc:body'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match='address[parent::author|parent::editor|parent::othercredit]'
		mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='"para-continue"'/>
      <xsl:with-param name='content'>
	<xsl:apply-templates mode='doc:body'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- do not attempt to handle recursive structures -->
  <xsl:template match='address[not(parent::author|parent::editor|parent::othercredit)]'
    mode='doc:body'>
    <xsl:apply-templates select='node()[not(self::affiliation|self::authorblurb)]'/>
  </xsl:template>
  <!-- TODO -->
  <xsl:template match='authorblurb|personblurb'
    mode='doc:body'/>

  <!-- TODO: handle inline markup (eg. emphasis) -->
  <xsl:template match='surname|firstname|honorific|lineage|othername|contrib|email|shortaffil|jobtitle|orgname|orgdiv|street|pob|postcode|city|state|country|phone|fax|citetitle'
    mode='doc:body'>
    <xsl:if test='preceding-sibling::*'>
      <xsl:call-template name='doc:make-phrase'>
	<xsl:with-param name='content'>
          <xsl:text> </xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:call-template name='doc:handle-linebreaks'>
      <xsl:with-param name='style' select='name()'/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match='email'
    mode='doc:body'>
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
    <xsl:call-template name='doc:make-hyperlink'>
      <xsl:with-param name='target' select='$address'/>
      <xsl:with-param name='content'>
	<xsl:call-template name='doc:handle-linebreaks'>
	  <xsl:with-param name='style'>Hyperlink</xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- otheraddr often contains ulink -->
  <xsl:template match='otheraddr'
    mode='doc:body'>
    <xsl:choose>
      <xsl:when test='ulink'>
        <xsl:for-each select='ulink'>
          <xsl:variable name='prev' select='preceding-sibling::ulink[1]'/>
          <xsl:choose>
            <xsl:when test='$prev'>
              <xsl:for-each
                select='preceding-sibling::node()[generate-id(following-sibling::ulink[1]) = generate-id(current())]'>
		<xsl:call-template name='doc:handle-linebreaks'>
		  <xsl:with-param name='style'>otheraddr</xsl:with-param>
		</xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test='preceding-sibling::node()'>
	      <xsl:call-template name='doc:handle-linebreaks'>
		<xsl:with-param name='style'>otheraddr</xsl:with-param>
	      </xsl:call-template>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select='.'/>
        </xsl:for-each>
        <xsl:if test='ulink[last()]/following-sibling::node()'>
	  <xsl:call-template name='doc:handle-linebreaks'>
	    <xsl:with-param name='content'
	      select='ulink[last()]/following-sibling::node()'/>
	    <xsl:with-param name='style'>otheraddr</xsl:with-param>
	  </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name='doc:handle-linebreaks'>
	  <xsl:with-param name='style'>otheraddr</xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='ulink'
    mode='doc:body'>
    <xsl:call-template name='doc:make-hyperlink'>
      <xsl:with-param name='target' select='@url'/>
      <xsl:with-param name='content'>
	<xsl:call-template name='doc:handle-linebreaks'>
	  <xsl:with-param name='style'>Hyperlink</xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Cannot round-trip this element -->
  <xsl:template match='personname'
    mode='doc:body'>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='releaseinfo'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='releaseinfo'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='para'
    mode='doc:body'>
    <xsl:param name='class'/>

    <xsl:variable name='block' select='blockquote|calloutlist|classsynopsis|funcsynopsis|figure|glosslist|graphic|informalfigure|informaltable|itemizedlist|literallayout|mediaobject|mediaobjectco|note|caution|warning|important|tip|orderedlist|programlisting|revhistory|segmentedlist|simplelist|table|variablelist'/>

    <xsl:choose>
      <xsl:when test='$block'>
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style'>
            <xsl:choose>
              <xsl:when test='$class != ""'>
                <xsl:value-of select='$class'/>
              </xsl:when>
              <xsl:otherwise>para</xsl:otherwise>
            </xsl:choose>
	  </xsl:with-param>
	  <xsl:with-param name='content'
			  select='$block[1]/preceding-sibling::node()'/>
        </xsl:call-template>

        <xsl:for-each select='$block'>
          <xsl:apply-templates select='.'/>

	  <xsl:call-template name='doc:make-paragraph'>
	    <xsl:with-param name='style'>
              <xsl:choose>
		<xsl:when test='$class != ""'>
                  <xsl:value-of select='$class'/>
		</xsl:when>
		<xsl:otherwise>Normal</xsl:otherwise>
              </xsl:choose>
	    </xsl:with-param>
	    <xsl:with-param name='content'
			    select='following-sibling::node()[generate-id(preceding-sibling::*[self::blockquote|self::calloutlist|self::figure|self::glosslist|self::graphic|self::informalfigure|self::informaltable|self::itemizedlist|self::literallayout|self::mediaobject|self::mediaobjectco|self::note|self::caution|self::warning|self::important|self::tip|self::orderedlist|self::programlisting|self::revhistory|self::segmentedlist|self::simplelist|self::table|self::variablelist][1]) = generate-id(current())]'/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style'>
            <xsl:choose>
	      <xsl:when test='$class != ""'>
                <xsl:value-of select='$class'/>
	      </xsl:when>
	      <xsl:otherwise>Normal</xsl:otherwise>
            </xsl:choose>
	  </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='simpara'
    mode='doc:body'>
    <xsl:param name='class'/>

    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style'>
        <xsl:choose>
	  <xsl:when test='$class != ""'>
            <xsl:value-of select='concat("sim-", $class)'/>
	  </xsl:when>
	  <xsl:otherwise>simpara</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='emphasis'
    mode='doc:body'>
    <xsl:call-template name='doc:make-phrase'>
      <xsl:with-param name='italic'>
	<xsl:choose>
	  <xsl:when test='not(@role)'>1</xsl:when>
	  <xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
      <xsl:with-param name='bold'>
	<xsl:choose>
	  <xsl:when test='@role = "bold" or @role = "strong"'>1</xsl:when>
	  <xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='informalfigure'
    mode='doc:body'>
    <xsl:if test='mediaobject/imageobject/imagedata'>
      <xsl:call-template name='doc:make-paragraph'>
	<xsl:with-param name='style' select='"informalfigure-imagedata"'/>
	<xsl:with-param name='content'>
	  <xsl:call-template name='doc:make-phrase'>
	    <xsl:with-param name='content'>
	      <xsl:apply-templates select='mediaobject/imageobject/imagedata/@fileref'
				   mode='textonly'/>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:for-each select='*[not(self::mediaobject)]'>
      <xsl:call-template name='doc:nomatch'/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match='mediaobject|mediaobjectco'
    mode='doc:body'>
    <xsl:apply-templates select='objectinfo/title'/>
    <xsl:apply-templates select='objectinfo/subtitle'/>
    <!-- TODO: indicate error for other children of objectinfo -->

    <xsl:apply-templates select='*[not(self::objectinfo)]'/>
  </xsl:template>
  <xsl:template match='imageobject|imageobjectco|audioobject|videoobject'
    mode='doc:body'>
    <xsl:apply-templates select='objectinfo/title'/>
    <xsl:apply-templates select='objectinfo/subtitle'/>
    <!-- TODO: indicate error for other children of objectinfo -->

    <xsl:apply-templates select='areaspec'/>

    <xsl:choose>
      <xsl:when test='imagedata|audiodata|videodata'>
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style'
			  select='concat(name(), "-", name(imagedata|audiodata|videodata))'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-phrase'>
	      <xsl:with-param name='content'>
		<xsl:apply-templates select='*/@fileref'
				     mode='textonly'/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test='self::imageobjectco/imageobject/imagedata'>
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style'
			  select='concat(name(), "-imagedata")'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-phrase'>
	      <xsl:with-param name='content'>
		<xsl:apply-templates select='*/@fileref'
				     mode='textonly'/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select='calloutlist'/>

    <xsl:for-each select='*[not(self::imageobject |
			        self::imagedata |
			        self::audiodata |
				self::videodata |
				self::areaspec  |
				self::calloutlist)]'>
      <xsl:call-template name='doc:nomatch'/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match='textobject'
    mode='doc:body'>
    <xsl:choose>
      <xsl:when test='objectinfo/title|objectinfo|subtitle'>
	<xsl:apply-templates select='objectinfo/title'/>
	<xsl:apply-templates select='objectinfo/subtitle'/>
	<!-- TODO: indicate error for other children of objectinfo -->
      </xsl:when>
      <xsl:otherwise>
	<!-- synthesize a title so that the parent textobject
	     can be recreated.
	  -->
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style' select='"textobject-title"'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-phrase'>
	      <xsl:with-param name='content'>
		<xsl:text>Text Object </xsl:text>
		<xsl:number level='any'/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select='*[not(self::objectinfo)]'/>
  </xsl:template>

  <xsl:template match='caption'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='"caption"'/>
      <xsl:with-param name='content'>
	<xsl:choose>
	  <xsl:when test='not(*)'>
	    <xsl:apply-templates/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select='para[1]/node()'/>
	    <xsl:for-each select='text()|*[not(self::para)]|para[position() != 1]'>
	      <xsl:call-template name='doc:nomatch'/>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='area|areaspec'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='name()'/>
      <xsl:with-param name='content'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='calloutlist'
    mode='doc:body'>
    <xsl:apply-templates select='callout'/>
  </xsl:template>

  <xsl:template match='callout'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='"callout"'/>
      <xsl:with-param name='content'>
	<!-- Normally a para would be the first child of a callout -->
	<xsl:apply-templates select='*[1][self::para]/node()' mode='list'/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- This is to catch the case where a listitem's first child is not a paragraph.
       - We may not be able to represent this properly.
      -->
    <xsl:apply-templates select='*[1][not(self::para)]' mode='list'/>

    <xsl:apply-templates select='*[position() != 1]' mode='list'/>
  </xsl:template>

  <xsl:template match='table|informaltable' mode='doc:body'>
    <xsl:call-template name='doc:make-table'>
      <xsl:with-param name='columns'>
        <xsl:apply-templates select='tgroup/colspec' mode='doc:column'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='colspec' mode='doc:column'>
    <xsl:call-template name='doc:make-column'>
      <xsl:with-param name='width' select='@colwidth'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='colspec' mode='doc:body'/>

  <xsl:template name='doc:repeat'>
    <xsl:param name='repeats' select='0'/>
    <xsl:param name='content'/>

    <xsl:if test='$repeats > 0'>
      <xsl:copy-of select='$content'/>
      <xsl:call-template name='doc:repeat'>
        <xsl:with-param name='repeats' select='$repeats - 1'/>
        <xsl:with-param name='content' select='$content'/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match='tgroup|tbody|thead' mode='doc:body'>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match='row' mode='doc:body'>
    <xsl:call-template name='doc:make-table-row'>
      <xsl:with-param name='is-header' select='boolean(parent::thead)'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='entry' mode='doc:body'>

    <!-- 
         Position = Sum(i,preceding-sibling[@colspan = ""]) + entry[i].@colspan)
      -->

    <xsl:variable name='position'>
      <xsl:call-template name='doc:sum-sibling'>
        <xsl:with-param name='sum' select='"1"'/>
        <xsl:with-param name='node' select='.'/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name='limit' select='$position + @colspan'/>

    <xsl:call-template name='doc:make-table-cell'>
      <xsl:with-param name='width'>
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
            <xsl:value-of select='$combinedWidth'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select='ancestor::*[self::table|self::informaltable][1]/tgroup/colspec[position() = $position]/@colwidth'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>

      <xsl:with-param name='hidden' select='@hidden'/>
      <xsl:with-param name='rowspan' select='@rowspan'/>
      <xsl:with-param name='colspan' select='@colspan'/>

      <xsl:with-param name='content'>
	<xsl:choose>
          <xsl:when test='not(para)'>
            <!-- TODO: check for any block elements -->
	    <xsl:call-template name='doc:make-paragraph'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Calculates the position by adding the 
       count of the preceding siblings where they aren't colspans
       and adding the colspans of those entries which do.
    -->

  <xsl:template name='doc:sum-sibling'>    
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
        <xsl:call-template name='doc:sum-sibling'>
          <xsl:with-param name='sum' select='$sum + $add'/>
          <xsl:with-param name='node' select='$node/preceding-sibling::entry[1]'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='$sum'/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name='doc:sum'>
    <xsl:param name='sum' select='"0"'/>
    <xsl:param name='nodes'/>

    <xsl:variable name='tmpSum' select='$sum + $nodes[1]/@colwidth'/>

    <xsl:choose>
      <xsl:when test='count($nodes) &gt; 1'>
        <xsl:call-template name='doc:sum'>
          <xsl:with-param name='nodes' select='$nodes[position() != 1]'/>
          <xsl:with-param name='sum' select='$tmpSum'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='$tmpSum'/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match='*[self::para|self::simpara]/text()[string-length(normalize-space(.)) != 0]'
    mode='doc:body'>
    <xsl:call-template name='doc:handle-linebreaks'/>
  </xsl:template>

  <xsl:template match='text()[not(parent::para|parent::simpara|parent::literallayout|parent::programlisting)][string-length(normalize-space(.)) != 0]'
    mode='doc:body'>
    <xsl:call-template name='doc:handle-linebreaks'/>
  </xsl:template>
  <xsl:template match='text()[string-length(normalize-space(.)) = 0]'
    mode='doc:body'/>
  <xsl:template match='literallayout/text()|programlisting/text()'
    mode='doc:body'>
    <xsl:call-template name='doc:handle-linebreaks'/>
  </xsl:template>
  <xsl:template name='doc:handle-linebreaks'>
    <xsl:param name='content' select='.'/>
    <xsl:param name='style'/>

    <xsl:choose>
      <xsl:when test='not($content)'/>
      <xsl:when test='contains($content, "&#xa;")'>
	<xsl:call-template name='doc:make-phrase'>
	  <xsl:with-param name='style' select='$style'/>
	  <xsl:with-param name='content'
			  select='substring-before($content, "&#xa;")'/>
        </xsl:call-template>

        <xsl:call-template name='doc:handle-linebreaks-aux'>
          <xsl:with-param name='content'
            select='substring-after($content, "&#xa;")'/>
	  <xsl:with-param name='style' select='$style'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name='doc:make-phrase'>
          <xsl:with-param name='style' select='$style'/>
	  <xsl:with-param name='content' select='$content'/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- pre-condition: leading linefeed has been stripped -->
  <xsl:template name='doc:handle-linebreaks-aux'>
    <xsl:param name='content'/>
    <xsl:param name='style'/>

    <xsl:choose>
      <xsl:when test='contains($content, "&#xa;")'>
        <xsl:call-template name='doc:make-phrase'>
	  <xsl:with-param name='style' select='$style'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-soft-break'/>
            <xsl:value-of select='substring-before($text, "&#xa;")'/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name='doc:handle-linebreaks-aux'>
          <xsl:with-param name='content'
			  select='substring-after($content, "&#xa;")'/>
	  <xsl:with-param name='style' select='$style'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='doc:make-phrase'>
	  <xsl:with-param name='style' select='$style'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-soft-break'/>
            <xsl:value-of select='$text'/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='authorblurb|formalpara|legalnotice|note|caution|warning|important|tip'
    mode='doc:body'>
    <xsl:apply-templates select='*'>
      <xsl:with-param name='class'>
        <xsl:value-of select='name()'/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='blockquote'
    mode='doc:body'>
    <xsl:apply-templates select='blockinfo|title'>
      <xsl:with-param name='class'>
        <xsl:value-of select='name()'/>
      </xsl:with-param>
    </xsl:apply-templates>
    <xsl:apply-templates select='*[not(self::blockinfo|self::title|self::attribution)]'>
      <xsl:with-param name='class' select='"blockquote"'/>
    </xsl:apply-templates>
    <xsl:if test='attribution'>
      <xsl:call-template name='doc:make-paragraph'>
	<xsl:with-param name='style' select='"blockquote-attribution"'/>
	<xsl:with-param name='content'>
          <xsl:apply-templates select='attribution/node()'/>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match='literallayout|programlisting'
    mode='doc:body'>
    <xsl:param name='class'/>

    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='name()'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='bridgehead'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style' select='"bridgehead"'/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='itemizedlist|orderedlist'
    mode='doc:body'>
    <xsl:apply-templates select='listitem'
      mode='doc:body'/>
  </xsl:template>

  <xsl:template match='listitem'
    mode='doc:body'>
    <xsl:call-template name='doc:make-paragraph'>
      <xsl:with-param name='style'
		      select='concat(name(..), 
			      count(ancestor::itemizedlist|ancestor::orderedlist))'/>
      <xsl:with-param name='is-listitem' select='true()'/>

      <xsl:with-param name='content'>
	<!-- Normally a para would be the first child of a listitem -->
	<xsl:apply-templates select='*[1][self::para]/node()' mode='list'/>
      </xsl:with-param>
    </xsl:call-template>

    <!-- This is to catch the case where a listitem's first child is not a paragraph.
       - We may not be able to represent this properly.
      -->
    <xsl:apply-templates select='*[1][not(self::para)]' mode='doc:list'/>

    <xsl:apply-templates select='*[position() != 1]' mode='doc:list'/>
  </xsl:template>  

  <xsl:template match='*' mode='doc:list'>
    <xsl:apply-templates select='.'>
      <xsl:with-param name='class' select='"para-continue"'/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='variablelist'
    mode='doc:body'>
    <xsl:apply-templates select='*[not(self::varlistentry)]'/>

    <xsl:call-template name='doc:make-table'>
      <xsl:with-param name='columns'>
	<xsl:call-template name='doc:make-column'>
	  <xsl:with-param name='width' select='"1"'/>
	  <xsl:with-param name='width' select='"3"'/>
	</xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name='rows'>
	<xsl:apply-templates select='varlistentry'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match='varlistentry'
    mode='doc:body'>
    <xsl:call-template name='doc:make-table-row'>
      <xsl:with-param name='content'>
	<xsl:call-template name='doc:make-table-cell'>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-paragraph'>
	      <xsl:with-param name='style' select='"variablelist-term"'/>
	      <xsl:with-param name='content'>
		<xsl:apply-templates select='term[1]/node()'/>
		<xsl:for-each select='term[position() != 1]'>
		  <xsl:call-template name='doc:make-phrase'>
		    <xsl:with-param name='content'>
		      <xsl:call-template name='doc:make-soft-break'/>
		    </xsl:with-param>
		  </xsl:call-template>
		  <xsl:apply-templates/>
		</xsl:for-each>
              </xsl:with-param>
	    </xsl:call-template>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name='doc:make-table-cell'>
	  <xsl:with-param name='content'>
            <xsl:apply-templates select='listitem/node()'/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- These elements are not displayed.
     - However, they may need to be added (perhaps as hidden text)
     - for round-tripping.
    -->
  <xsl:template match='anchor|areaset|audiodata|audioobject|
                       beginpage|
                       constraint|
                       indexterm|itermset|
                       keywordset|
                       msg'
    mode='doc:body'/>

  <xsl:template match='*' name='doc:nomatch'>
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
	<xsl:call-template name='doc:make-paragraph'>
	  <xsl:with-param name='style' select='"blockerror"'/>
	  <xsl:with-param name='content'>
	    <xsl:call-template name='doc:make-phrase'>
	      <xsl:with-param name='content'>
		<xsl:value-of select='name()'/>
		<xsl:text> encountered</xsl:text>
		<xsl:if test='parent::*'>
                  <xsl:text> in </xsl:text>
                  <xsl:value-of select='name(parent::*)'/>
		</xsl:if>
		<xsl:text>, but no template matches.</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
	</xsl:call-template>
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
        <xsl:call-template name='doc:make-phrase'>
          <xsl:with-param name='style' select='"inlineerror"'/>
	  <xsl:with-param name='content'>
            <xsl:value-of select='name()'/>
            <xsl:text> encountered</xsl:text>
            <xsl:if test='parent::*'>
              <xsl:text> in </xsl:text>
              <xsl:value-of select='name(parent::*)'/>
            </xsl:if>
            <xsl:text>, but no template matches.</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='*' mode='doc:copy'>
    <xsl:copy>
      <xsl:apply-templates select='@*' mode='doc:copy'/>
      <xsl:apply-templates mode='doc:copy'/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match='@*' mode='doc:copy'>
    <xsl:copy/>
  </xsl:template>

  <!-- Stubs: the importing stylesheet must override these -->

  <!-- stub template for creating a paragraph -->
  <xsl:template name='doc:make-paragraph'>
  </xsl:template>
  <!-- stub template for creating a phrase -->
  <xsl:template name='doc:make-phrase'>
  </xsl:template>

  <!-- stub template for inserting attributes -->
  <xsl:template name='doc:attributes'/>

  <!-- emit a message -->
  <xsl:template name='doc:warning'>
    <xsl:param name='message'/>

    <xsl:message>WARNING: <xsl:value-of select='$message'/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
