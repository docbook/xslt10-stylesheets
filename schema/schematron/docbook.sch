<!DOCTYPE schema PUBLIC "+//IDN sinica.edu.tw//DTD Schematron 1.5//EN"
                 "file:///share/doctypes/schematron/schematron1-5.dtd" [

<!ENTITY links.exclusion '
  <assert test="count(.//link) = 0"><name/> contains link</assert>
  <assert test="count(.//olink) = 0"><name/> contains olink</assert>
  <assert test="count(.//ulink) = 0"><name/> contains ulink</assert>
  <assert test="count(.//xref) = 0"><name/> contains xref</assert>
'>

<!ENTITY ubiq.exclusion '
  <assert test="count(.//indexterm) = 0"><name/> contains indexterm</assert>
  <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
'>

<!ENTITY formal.exclusion '
   <assert test="count(.//equation) = 0"><name/> contains equation</assert>
   <assert test="count(.//example) = 0"><name/> contains example</assert>
   <assert test="count(.//figure) = 0"><name/> contains figure</assert>
   <assert test="count(.//table) = 0"><name/> contains table</assert>
'>

<!ENTITY admon.exclusion '
   <assert test="count(.//warning) = 0"><name/> contains warning</assert>
   <assert test="count(.//tip) = 0"><name/> contains tip</assert>
   <assert test="count(.//note) = 0"><name/> contains note</assert>
   <assert test="count(.//caution) = 0"><name/> contains caution</assert>
   <assert test="count(.//important) = 0"><name/> contains important</assert>
'>

]>

<schema xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance">
  <title>Schematron 1.5 Schema for DocBook</title>

  <!-- ============================================================ -->
  <!-- Exclusions                                                   -->
  <!-- ============================================================ -->

  <pattern name="Nested Footnotes">
    <rule context="footnote">
      <assert test="count(.//footnote) = 0">Nested footnotes</assert>
      &formal.exclusion;
    </rule>
  </pattern>

  <pattern name="Nested Admonitions">
    <rule context="warning|caution|tip|note|important">
      &admon.exclusion;
    </rule>
  </pattern>

  <pattern name="Nested Formal Objects">
    <rule context="equation|example|figure|table">
      &formal.exclusion;
    </rule>
  </pattern>

  <pattern name="Formal Exclusions">
    <rule context="legalnotice">
      &formal.exclusion;
    </rule>
  </pattern>

  <pattern name="Highlights Exclusions">
    <rule context="highlights">
      &ubiq.exclusion;
      &formal.exclusion;
    </rule>
  </pattern>

  <pattern name="Acronym Exclusion">
    <rule context="acronym">
      <assert test="count(.//acronym) = 0"><name/> contains acronym</assert>
    </rule>
  </pattern>

  <pattern name="Glossterm Exclusion">
    <rule context="glossterm">
      <assert test="count(.//glossterm) = 0"><name/> contains glossterm</assert>
    </rule>
  </pattern>

  <pattern name="Ubiq Exclusion">
    <rule context="biblioentry|bibliomixed|biblioset|bibliomset|screeninfo">
      &ubiq.exclusion;
    </rule>
    <rule context="modespec|subscript|superscript|indexterm">
      &ubiq.exclusion;
    </rule>
  </pattern>

  <pattern name="Blockquote Exclusion">
    <rule context="blockquote">
      <assert test="count(.//epigraph) = 0"><name/> contains epigraph</assert>
    </rule>
  </pattern>

  <pattern name="Links Exclusion">
    <rule context="ulink|olink|link">
      &links.exclusion;
    </rule>
  </pattern>

  <pattern name="Remark Exclusion">
    <rule context="remark">
      <assert test="count(.//remark) = 0"><name/> contains remark</assert>
    </rule>
  </pattern>

  <pattern name="Beginpage Exclusion">
    <rule context="setinfo|bookinfo|appendixinfo|bibliographyinfo|setindexinfo">
      <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
    </rule>
    <rule context="chapterinfo|glossaryinfo|indexinfo|partinfo">
      <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
    </rule>
    <rule context="prefaceinfo|refentryinfo|refsynopsisdivinfo|refmeta">
      <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
    </rule>
    <rule context="refsect1info|refsect2info|refsect3info">
      <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
    </rule>
    <rule context="sect1info|sect2info|sect3info|sect4info|sect5info|sectioninfo|simplesectinfo">
      <assert test="count(.//beginpage) = 0"><name/> contains beginpage</assert>
    </rule>
  </pattern>

  <pattern name="Indexterm Exclusion">
    <rule context="index|setindex">
      <assert test="count(.//indexterm) = 0"><name/> contains indexterm</assert>
    </rule>
  </pattern>

  <!-- ============================================================ -->
  <!-- Glossary Terms                                               -->
  <!-- ============================================================ -->

  <pattern name="Glossterm Links">
    <rule context="glossterm[@linkend]">
      <report test="local-name(id(@linkend)) != 'glossentry'">
        Warning: <name/> does not point to a glossentry!
      </report>
    </rule>
  </pattern>

  <pattern name="Glossterm Missing Links">
    <rule context="glossterm">
      <report test="not(@linkend) and not(parent::glossentry)">
        Note: <name/> does not have a linkend attribute.
      </report>
    </rule>
  </pattern>

  <!-- test to make sure that every glossterm has a glossterm with
       the same content that appears in a glossdef somewhere... -->
  <!--
  <pattern name="Missing Glossary Definitions">
    <rule context="glossterm">
      <assert test="//glossdef/glossterm">
        Glossterm has no definition.
      </assert>
    </rule>
  </pattern>
  -->

</schema>
