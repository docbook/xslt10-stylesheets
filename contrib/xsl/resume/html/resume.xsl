<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="https://cdn.docbook.org/release/xsl/current/html/docbook.xsl"/>

<xsl:template name="resume-name">
  <xsl:apply-templates select="/article/articleinfo/address/firstname"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="/article/articleinfo/address/surname"/>
</xsl:template>

<xsl:template match="article">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="articleinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="articleinfo/title">
  <!-- suppress -->
</xsl:template>

<xsl:template match="address">
  <table border="0" width="100%" cellpadding="0" cellspacing="0"
         summary="Address header">
    <tr>
      <td width="33%" align="left" valign="top">&#160;</td>
      <td width="33%" align="center" valign="top">
        <b>
          <xsl:call-template name="resume-name"/>
        </b>
      </td>
      <td width="33%" align="left" valign="top">&#160;</td>
    </tr>
    <tr>
      <td width="33%" align="left" valign="bottom">
        <xsl:choose>
          <xsl:when test="phone and fax and phone != fax">
            <xsl:text>Phone: </xsl:text>
            <xsl:apply-templates select="phone"/>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td width="33%" rowspan="2" align="center" valign="bottom">
        <xsl:choose>
          <xsl:when test="street or city">
            <xsl:for-each select="street">
              <xsl:apply-templates select="."/>
              <br/>
            </xsl:for-each>
            <xsl:apply-templates select="city"/>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="state"/>
            <xsl:text>  </xsl:text>
            <xsl:apply-templates select="postcode"/>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td width="33%" align="left" valign="top">&#160;</td>
    </tr>
    <tr>
      <td width="33%" align="left" valign="bottom">
        <xsl:choose>
          <xsl:when test="phone and fax and phone = fax">
            <xsl:text>Phone/Fax: </xsl:text>
            <xsl:apply-templates select="phone"/>
          </xsl:when>
          <xsl:when test="fax">
            <xsl:text>Fax: </xsl:text>
            <xsl:apply-templates select="fax"/>
          </xsl:when>
          <xsl:when test="phone">
            <xsl:text>Phone: </xsl:text>
            <xsl:apply-templates select="phone"/>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
      </td>
      <!-- overhang from above -->
      <td width="33%" align="right" valign="bottom">
        <xsl:text>Email: </xsl:text>
        <xsl:apply-templates select="email"/>
      </td>
    </tr>
  </table>
  <hr/>
</xsl:template>

<xsl:template match="sect1">
  <xsl:choose>
    <xsl:when test="@role = 'experience'">
      <xsl:apply-templates select="." mode="experience"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
      <p>
        <xsl:comment> spacing hack </xsl:comment>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->
<!-- Experience -->

<xsl:template match="title|sect2info|sect3info" mode="experience">
  <!-- suppress -->
</xsl:template>

<xsl:template match="sect1" mode="experience">
  <table border="0" width="100%" summary="Pretty-printed work experience">
    <xsl:apply-templates mode="experience"/>
  </table>
</xsl:template>

<xsl:template match="sect2" mode="experience">
  <tr>
    <td align="left" valign="top" rowspan="{(count(sect3)*2)+1}">
      <xsl:apply-templates select="sect2info/pubdate" mode="experience"/>
    </td>
    <td align="left" valign="top" colspan="2">
      <xsl:apply-templates select="title" mode="experience-title"/>
    </td>
  </tr>
  <xsl:apply-templates mode="experience"/>
</xsl:template>

<xsl:template match="sect3" mode="experience">
  <tr>
    <td align="left" valign="top">
      <xsl:apply-templates select="title" mode="experience-title"/>
    </td>
    <td align="left" valign="top">
      <xsl:apply-templates select="sect3info/pubdate" mode="experience"/>
    </td>
  </tr>
  <tr>
    <td align="left" valign="top" colspan="2">
      <xsl:apply-templates mode="experience"/>
      <p>
        <xsl:comment> spacing hack </xsl:comment>
      </p>
    </td>
  </tr>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="sect2/title" mode="experience-title">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>

<xsl:template match="sect3/title" mode="experience-title">
  <i>
    <xsl:apply-templates/>
  </i>
</xsl:template>

</xsl:stylesheet>
