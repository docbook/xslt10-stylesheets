<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                name="main" version='1.0' >

  <p:input port="source">
    <p:document href="../../docbook/dtd.rng"/>
  </p:input>
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result"/>
  <p:serialization port="result" method="text"/>

  <p:option name="debug" select="0"/>
  <p:option name="override" select="'override/docbook.xml'"/>

<!-- ============================================================ -->

  <p:variable name="override.xml" select="resolve-uri($override)"/>

<!-- ============================================================ -->

  <p:xslt name="rng2dtx">
    <p:input port="stylesheet">
      <p:document href="style/rng2dtx.xsl"/>
    </p:input>
  </p:xslt>

  <p:xslt name="override">
    <p:input port="stylesheet">
      <p:document href="style/override.xsl"/>
    </p:input>
    <p:with-param name="override.xml" select="$override.xml"/>
  </p:xslt>

  <cx:until-unchanged name="remove-choice">
    <p:xslt name="attr-remove-choice">
      <p:input port="stylesheet">
        <p:document href="style/attr-remove-choice.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <cx:until-unchanged name="remove-unused">
    <p:xslt name="attr-remove-unused">
      <p:input port="stylesheet">
        <p:document href="style/attr-remove-unused.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <p:xslt name="attr-optional-to-ref">
    <p:input port="stylesheet">
      <p:document href="style/attr-optional-to-ref.xsl"/>
    </p:input>
  </p:xslt>

  <cx:until-unchanged name="to-attref">
    <p:xslt name="ref-to-attref">
      <p:input port="stylesheet">
        <p:document href="style/ref-to-attref.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <cx:until-unchanged name="flatten">
    <p:xslt name="flatten-attref">
      <p:input port="stylesheet">
        <p:document href="style/flatten-attref.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <p:xslt name="attr-optional-to-decl">
    <p:input port="stylesheet">
      <p:document href="style/attr-optional-to-decl.xsl"/>
    </p:input>
  </p:xslt>

  <p:xslt name="multiple-gis">
    <p:input port="stylesheet">
      <p:document href="style/multiple-gis.xsl"/>
    </p:input>
  </p:xslt>

  <p:xslt name="remove-empty-pes">
    <p:input port="stylesheet">
      <p:document href="style/remove-empty-pes.xsl"/>
    </p:input>
  </p:xslt>

  <cx:until-unchanged name="pull-up">
    <p:xslt name="pull-up-text">
      <p:input port="stylesheet">
        <p:document href="style/pull-up-text.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <cx:until-unchanged name="unwrap">
    <p:xslt name="unwrap-zeroormore">
      <p:input port="stylesheet">
        <p:document href="style/unwrap-zeroormore.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <cx:until-unchanged name="sort">
    <p:xslt name="sort-pe">
      <p:input port="stylesheet">
        <p:document href="style/sort-pes.xsl"/>
      </p:input>
    </p:xslt>
  </cx:until-unchanged>

  <p:xslt name="dtx2dtd">
    <p:input port="stylesheet">
      <p:document href="style/dtx2dtd.xsl"/>
    </p:input>
  </p:xslt>

</p:declare-step>
