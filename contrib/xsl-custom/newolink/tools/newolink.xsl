<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://sagehill.net/xsl/target/1.0"
                exclude-result-prefixes="t"
                version='1.0'>

<!-- New olink template to process olinks using an
     external cross reference database
     If an olink does not use a type="stylesheet" attribute,
     then the behavior reverts to the old olink by
     applying imports for the olink template from the
     standard stylesheet.
-->

<xsl:template match="olink">

  <!-- Open the database document passed on the command line -->
  <xsl:variable name="target.database" 
              select="document($target.database.document)"/>

  <!-- Future feature to assemble generated text using local stylesheet -->
  <xsl:variable name="olink.styled.locally" select="0"/>


<!-- You can uncomment these message to see what is going on. 
<xsl:message>
  The database name is <xsl:value-of select="$target.database.document"/>
  The targetset is <xsl:value-of select="$target.database/t:targetset"/>
</xsl:message>
-->

<xsl:choose>
  <xsl:when test="@type='stylesheet'">
    <xsl:choose>
      <xsl:when test="@targetdoc and @targetid">

	<!-- Open data file for this document -->
        <xsl:variable name="targetdatafilename" select="$target.database/t:targetset/t:document[@targetdoc=current()/@targetdoc]/@href" />
        <xsl:variable name="targetdocset" select="document($target.database/t:targetset/t:document[@targetdoc=current()/@targetdoc]/@href)"/>

	<!-- Get the cross reference href -->
        <xsl:variable name="target.href" select="$targetdocset//*[@targetid=current()/@targetid]/@href"/>

        <xsl:variable name="baseuri" select="$target.database/t:targetset/t:document[@targetdoc=current()/@targetdoc]/@baseuri"/>
        <xsl:variable name="href">
          <xsl:if test="$baseuri != ''">
            <xsl:value-of select="$baseuri"/>
            <xsl:if test="substring($target.href,1,1) != '#'">
              <xsl:text>/</xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:value-of select="$target.href"/>
        </xsl:variable>

	<!-- Uncomment to see what is going on 
        <xsl:message>
	    Opening document data file <xsl:value-of select="$targetdatafilename"/>
            targetdoc is <xsl:value-of select="current()/@targetdoc"/>
            targetid is <xsl:value-of select="current()/@targetid"/>
            baseuri is <xsl:value-of select="$baseuri"/>
            target.href is <xsl:value-of select="$target.href"/>
            href is <xsl:value-of select="$href"/></xsl:message>
	-->

	<!-- Start the HTML output -->
        <a href="{$href}">

        <xsl:choose>
	  <!-- If olink has content, use it -->
          <xsl:when test="count(child::node()) &gt; 0">
            <xsl:apply-templates/>
          </xsl:when>
	  <!-- Otherwise generate the text -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$olink.styled.locally">
		<!-- no-op until implemented
                <xsl:call-template name="olink.localstyle">
                </xsl:call-template>
		-->
              </xsl:when>
              <xsl:otherwise>
	      <!-- Use the text from the database -->
                <xsl:variable name="xref.text" select="$targetdocset//*[@targetid=current()/@targetid]/t:xreftext"/>

		<!-- Uncomment to display the text 
<xsl:message>            xref.text is <xsl:value-of select="$xref.text"/>
</xsl:message>
		-->
                <xsl:choose>
                  <xsl:when test="$xref.text">
                    <xsl:value-of select="$xref.text"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:message>
                      Olink text not available
                    </xsl:message>
                    <xsl:text>MISSING OLINK TEXT</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

	<!-- Close the anchor tag -->
        </a>

	<!-- Generate 'in document title' -->
        <xsl:variable name="doctitle" 
              select="$targetdocset/t:div[1]/t:ttl"/>
	<xsl:if test="$doctitle">
         <xsl:text> in </xsl:text>
          <xsl:value-of select="$doctitle"/>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          Olink of type of stylesheet is missing either targetdoc or targetid attribute.
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
        <!-- use the standard olink template -->
        <xsl:apply-imports/>
  </xsl:otherwise>
</xsl:choose>
  
</xsl:template>

</xsl:stylesheet>
