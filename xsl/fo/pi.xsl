<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="doc"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<doc:reference xmlns="">
<referenceinfo>
<releaseinfo role="meta">
$Id$
</releaseinfo>
<authorgroup>
  <author>
    <orgname>The DocBook Project Development Team</orgname>
  </author>
</authorgroup>
<copyright>
  <year>2007</year>
  <holder>The DocBook Project</holder>
</copyright>
</referenceinfo>
<title>FO Processing Instruction Reference</title>

<partintro id="partintro">
<title>Introduction</title>

<para>This is generated reference documentation for all
  user-specifiable processing instructions (PIs) in the DocBook
  XSL stylesheets for FO output.
  <note>
    <para>You add these PIs at particular points in a document to
      cause specific “exceptions” to formatting/output behavior. To
      make global changes in formatting/output behavior across an
      entire document, it’s better to do it by setting an
      appropriate stylesheet parameter (if there is one).</para>
  </note>
</para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<doc:pi name="dbfo_background-color" xmlns="">
<refpurpose>Sets background color for an image</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo background-color</tag> PI before or
    after an image (<tag>graphic</tag>, <tag>inlinegraphic</tag>,
    <tag>imagedata</tag>, or <tag>videodata</tag> element) as a
    sibling to the element, to set a background color for the
    image.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo background-color="<replaceable>color</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>background-color="<replaceable>color</replaceable>"</term>
      <listitem>
        <para>FIXME: A color value? [In hex, as a name, or what?]</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_background-color">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'background-color'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_bgcolor" xmlns="">
<refpurpose>Sets background color on an table row or table cell</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo bgcolor</tag> PI as child of a table row
    or cell to set a background color for that table row or cell.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo bgcolor="<replaceable>color</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>bgcolor="<replaceable>color</replaceable>"</term>
      <listitem>
        <para>FIXME: A color value? [In hex, as a name, or what?]</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_bgcolor">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'bgcolor'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_float-type" xmlns="">
<refpurpose>Specifies float behavior for a sidebar</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo float-type</tag> PI to specify the float
    behavior for a <tag>sidebar</tag> (to cause the sidebar to be
  displayed as a marginal note).</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo float-type="margin.note"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>float-type="margin.note"</term>
      <listitem>
        <para>Specifies that the <tag>sidebar</tag> should be
          displayed as a marginal note.</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_float-type">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'float-type'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_glossary-presentation" xmlns="">
<refpurpose>Specifies presentation style for a glossary</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo glossary-presentation</tag> PI as a child of
    a <tag>glossary</tag> to control its presentation style.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo glossary-presentation="list"|"blocks"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>glossary-presentation="list"</term>
      <listitem>
        <para>Displayed the glossary as a list</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>glossary-presentation="blocks"</term>
      <listitem>
        <para>Displays the glossary as blocks</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_glossary-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'glossary-presentation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_glosslist-presentation" xmlns="">
<refpurpose>Specifies presentation style for a glosslist</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo glosslist-presentation</tag> PI as a child of
    a <tag>glosslist</tag> to control its presentation style.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo glosslist-presentation="list"|"blocks"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>glosslist-presentation="list"</term>
      <listitem>
        <para>Displayed the glosslist as a list</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>glosslist-presentation="blocks"</term>
      <listitem>
        <para>Displays the glosslist as blocks</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_glosslist-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'glosslist-presentation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_glossterm-width" xmlns="">
<refpurpose>Specifies the glossterm width for a glossary or
  glosslist</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo glossterm-width</tag> PI as a child of a
    <tag>glossary</tag> or <tag>glosslist</tag> to specify the
    width for output of <tag>glossterm</tag> instances in the
    output.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo glossterm-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>glossterm-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the glossterm width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_glossterm-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'glossterm-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_keep-together" xmlns="">
<refpurpose>Specifies “keep” behavior for a table, example,
  figure, or equation</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo keep-together</tag> PI as a child of a
    formal object (<tag>table</tag>, <tag>example</tag>,
    <tag>figure</tag>, or <tag>equation</tag>) or their informal
    equivalents) to specify “keep” behavior for the object (to
    allow the object to “break” across a page).</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo keep-together="auto"|"always"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>keep-together="auto"</term>
      <listitem>
        <para>Enables the object to break across a page</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>keep-together="always"</term>
      <listitem>
        <para>Prevents the object from breaking across a page (the
          default stylesheet behavior)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_keep-together">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'keep-together'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_label-width" xmlns="">
<refpurpose>Specifies the label width for an itemizedlist,
  orderedlist, or qandaset</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo label-width</tag> PI as a child of an
    <tag>itemizedlist</tag>, <tag>orderedlist</tag>, or
    <tag>qandaset</tag> to specify the width of labels.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo label-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>label-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the label width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_label-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'label-width'"/>
  </xsl:call-template>
</xsl:template> 

<doc:pi name="dbfo_linenumbering.everyNth" xmlns="">
<refpurpose>Specifies the interval at which lines are numbered
  output of verbatim environments</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo linenumbering.everyNth</tag> PI as a child
    of a “verbatim” element – <tag>programlisting</tag>,
    <tag>screen</tag>, <tag>synopsis</tag> — to specify
    the interval at which lines are numbered.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo linenumbering.everyNth="<replaceable>N</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>linenumbering.everyNth="<replaceable>N</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies numbering interval; a number is
          output before every <replaceable>N</replaceable>th line</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_linenumbering.everyNth">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis"
      select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'linenumbering.everyNth'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_linenumbering.separator" xmlns="">
<refpurpose>Specifies the separator text used between line numbers
  and content in output of verbatim environments</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo linenumbering.separator</tag> PI as a child
    of a “verbatim” element – <tag>programlisting</tag>,
    <tag>screen</tag>, <tag>synopsis</tag> — to specify
    the separator text output between the line numbers and content.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo linenumbering.separator="<replaceable>text</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>linenumbering.separator="<replaceable>text</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the text (zero or more characters)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_linenumbering.separator">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis"
      select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'linenumbering.separator'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_linenumbering.width" xmlns="">
<refpurpose>Specifies the width set aside for line numbers in
  output of verbatim environments</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo linenumbering.width</tag> PI as a child
    of a “verbatim” element – <tag>programlisting</tag>,
    <tag>screen</tag>, <tag>synopsis</tag> — to specify
    the width set aside for line numbers.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo linenumbering.width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>linenumbering.width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_linenumbering.width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis"
      select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'linenumbering.width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_list-width" xmlns="">
<refpurpose>Specifies the width of a horizontal simplelist</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo list-width</tag> PI as a child of a
    <tag>simplelist</tag> whose <tag class="attribute">class</tag>
    value is <literal>horizontal</literal>, to specify the width
    of the <tag>simplelist</tag>.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo list-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>list-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the <tag>simplelist</tag> width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_list-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'list-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_list-presentation" xmlns="">
<refpurpose>Specifies presentation style for a variablelist or
  segmentedlist</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo list-presentation</tag> PI as a child of
    a <tag>variablelist</tag> or <tag>segmentedlist</tag> to
    control the presentation style for the list (to cause it, for
    example, to be displayed as a table).</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo list-presentation="list"|"blocks"|"table"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>list-presentation="list"</term>
      <listitem>
        <para>Displayed the list as a list</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>list-presentation="blocks"</term>
      <listitem>
        <para>(<tag>variablelist</tag> only) Displays the list as blocks</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>list-presentation="table"</term>
      <listitem>
        <para>(<tag>segmentedlist</tag> only) Displays the list as a table</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_list-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'list-presentation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_orientation" xmlns="">
<refpurpose>Specifies the orientation for table row or cell</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo orientation</tag> PI as a child of an
    <tag>table</tag> row or cell to specify the orientation
    (rotation) for the row or cell.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo orientation="0"|"90"|"180"|"270"|"-90"|"-180"|"-270"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>orientation="0"|"90"|"180"|"270"|"-90"|"-180"|"-270"</term>
      <listitem>
        <para>Specifies the number of degrees by which the cell or
          row is rotated</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_orientation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'orientation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_pgwide" xmlns="">
  <refpurpose>Species whether an <tag>equation</tag> or
    <tag>example</tag> should rendered across the full width of a
    page</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo pgwide</tag> PI as a child of an
    <tag>equation</tag> or <tag>example</tag> to specify that the
    content should rendered across the full width of the page.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo pgwide="0"|"1"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>pgwide="0"</term>
      <listitem>
        <para>If zero, the content is rendered across the current
        text flow</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>pgwide="1"</term>
      <listitem>
        <para>If <code>1</code> (or any non-zero value), the
          content is rendered across the full width of the page</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_pgwide">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'pgwide'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_rotated-width" xmlns="">
  <refpurpose>Specifies the width for a table <tag>entry</tag> or
    <tag>row</tag></refpurpose>
<refdescription>
  <para>Use the <tag>dbfo rotated-width</tag> PI as a child of an
    <tag>entry</tag> or <tag>row</tag> instance to specify the
    width of that the <tag>entry</tag> or <tag>row</tag>; or
    use it higher up in table to cause the width to be inherited
    recursively down.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo rotated-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>rotated-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the width of a row or cell (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_rotated-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis"
      select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'rotated-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_sidebar-width" xmlns="">
<refpurpose>Specifies the width of a sidebar</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo sidebar-width</tag> PI as a child of a
    <tag>sidebar</tag> to specify the width of the sidebar.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo sidebar-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>sidebar-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the <tag>sidebar</tag> width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_sidebar-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'sidebar-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_table-width" xmlns="">
<refpurpose>Specifies the width for a table or for revhistory
  output</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo table-width</tag> PI as a child of a
    <tag>table</tag> or <tag>revhistory</tag> instance (which is
    rendered as a table in output) to specify the width of the
    table in output.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo table-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>table-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the table width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_table-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'table-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_term-width" xmlns="">
<refpurpose>Specifies the term width for a variablelist</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo term-width</tag> PI as a child of a
    <tag>variablelist</tag> to specify the width for
    <tag>term</tag> output.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo term-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>term-width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>FIXME: Specifies the term width (in what units?)</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_term-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'term-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbfo_toc" xmlns="">
<refpurpose>Species whether a TOC should be generated for a qandaset</refpurpose>
<refdescription>
  <para>Use the <tag>dbfo toc</tag> PI as a child of a
    <tag>jandaset</tag> to specify whether a table of contents
    (TOC) is generated for the <tag>qandaset</tag>.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo toc="0"|"1"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>toc="0"</term>
      <listitem>
        <para>If zero, no TOC is generated</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>toc="1"</term>
      <listitem>
        <para>If <code>1</code> (or any non-zero value),
          a TOC is generated</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo_toc">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbfo-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbfo')"/>
    <xsl:with-param name="attribute" select="'toc'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<doc:pi name="dbfo-need" xmlns="">
<refpurpose>Specify a need for space (a kind of soft page break)</refpurpose>
<refdescription>
  <para>A “need” is a request for space on a page.  If the
    requested space is not available, the page breaks and the
    content that follows the need request appears on the next
    page. If the requested space is available, then the request is
    ignored.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbfo-need height="<replaceable>n</replaceable>"</tag></synopsis>
    <synopsis><tag class="xmlpi">dbfo-need space-before="<replaceable>n</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>height="<replaceable>n</replaceable>"</term>
      <listitem>
        <para>FIXME: the amount of height(?) needed? In what units? pt?.</para>
      </listitem>
    </varlistentry>
    <varlistentry><term>space-before"<replaceable>n</replaceable>"</term>
      <listitem>
        <para>FIXME: the amount of space needed before the
          [something]? In what units? pt?.</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
</doc:pi>
<xsl:template name="pi.dbfo-need">
  <xsl:variable name="pi-height">
    <xsl:call-template name="dbfo-attribute">
      <xsl:with-param name="pis" select="."/>
      <xsl:with-param name="attribute" select="'height'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="$pi-height != ''">
        <xsl:value-of select="$pi-height"/>
      </xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pi-before">
    <xsl:call-template name="dbfo-attribute">
      <xsl:with-param name="pis" select="."/>
      <xsl:with-param name="attribute" select="'space-before'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="spacer">
    <fo:block-container width="100%" height="{$height}">
      <fo:block><fo:leader leader-length="0pt"/></fo:block>
    </fo:block-container>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$fop.extensions != 0">
      <!-- Doesn't work in fop -->
    </xsl:when>
    <xsl:when test="$pi-before != '' and
                    not(following-sibling::listitem) and
                    not(following-sibling::step)">
      <fo:block space-after="0pt" space-before="{$pi-before}">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::para">
      <fo:block space-after="0pt" 
                xsl:use-attribute-sets="normal.para.spacing">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::table or
                    following-sibling::figure or
                    following-sibling::example or
                    following-sibling::equation">
      <fo:block space-after="0pt" 
                xsl:use-attribute-sets="formal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::informaltable or
                    following-sibling::informalfigure or
                    following-sibling::informalexample or
                    following-sibling::informalequation">
      <fo:block space-after="0pt" 
                xsl:use-attribute-sets="informal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::itemizedlist or
                    following-sibling::orderedlist or
                    following-sibling::variablelist or
                    following-sibling::simplelist">
      <fo:block space-after="0pt" 
                xsl:use-attribute-sets="informal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::listitem or
                    following-sibling::step">
      <fo:list-item space-after="0pt" 
                xsl:use-attribute-sets="informal.object.properties">
        <fo:list-item-label/>
        <fo:list-item-body start-indent="0pt" end-indent="0pt">
          <xsl:copy-of select="$spacer"/>
        </fo:list-item-body>
      </fo:list-item>
    </xsl:when>
    <xsl:when test="following-sibling::sect1 or
                    following-sibling::sect2 or
                    following-sibling::sect3 or
                    following-sibling::sect4 or
                    following-sibling::sect5 or
                    following-sibling::section">
      <fo:block space-after="0pt" 
                xsl:use-attribute-sets="section.title.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-after="0pt" space-before="0em">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$fop.extensions != 0">
      <!-- Doesn't work in fop -->
    </xsl:when>
    <xsl:when test="following-sibling::listitem or
                    following-sibling::step">
      <fo:list-item space-before.precedence="force"
                space-before="-{$height}"
                space-after="0pt"
                space-after.precedence="force">
        <fo:list-item-label/>
        <fo:list-item-body start-indent="0pt" end-indent="0pt"/>
      </fo:list-item>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-before.precedence="force"
                space-before="-{$height}"
                space-after="0pt"
                space-after.precedence="force">
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbfo-attribute">
  <!-- * dbfo-attribute is an interal utility template for retrieving -->
  <!-- * pseudo-attributes/parameters from PIs -->
  <xsl:param name="pis" select="processing-instruction('dbfo')"/>
  <xsl:param name="attribute">filename</xsl:param>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute" select="$attribute"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template match="processing-instruction()">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbfo-need')">
  <xsl:call-template name="pi.dbfo-need"/>
</xsl:template>

</xsl:stylesheet>
