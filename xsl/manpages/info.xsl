<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                exclude-result-prefixes="exsl date"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

  <xsl:template name="get.metadata">

    <!-- * $name & <name> = "real name" of the documented item; for example, in -->
    <!-- * the case of a command, the <name> is what you would type in on the -->
    <!-- * command line to run it. -->
    <xsl:variable name="name" select="refnamediv[1]/refname[1]"/>
    <name>
      <xsl:value-of select="$name"/>
    </name>

    <!-- * $section & <section> = the man "section" that the documented item -->
    <!-- * is in; if a manvolnum is not specified in the source, and we find -->
    <!-- * that the refentry is for a function, we use the section number "3" -->
    <!-- * ["Library calls (functions within program libraries)"]; otherwise, -->
    <!-- * we default to using "1" ["Executable programs or shell commands"] -->
    <xsl:variable name="section">
      <xsl:choose>
        <xsl:when test="refmeta/manvolnum">
          <xsl:value-of select="refmeta/manvolnum"/>
        </xsl:when>
        <xsl:when test=".//funcsynopsis">3</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <section>
      <xsl:value-of select="$section"/>
    </section>
    
    <!-- * <filename> = name.section; for example: xsltproc.1 -->
    <filename>
      <xsl:call-template name="replace-string">
        <!-- replace spaces in source filename with underscores in output filename -->
        <xsl:with-param name="content"
                        select="concat(normalize-space ($name), '.', $section)"/>
        <xsl:with-param name="replace" select="' '"/>
        <xsl:with-param name="with" select="'_'"/>
      </xsl:call-template>
    </filename>

    <!-- * <title> = differs from <name> in that, if the refentry has a -->
    <!-- * refentrytitle, we use that as the <title>; otherwise, we just use the -->
    <!-- * <name>, which is the first refname in the first refnamediv in the -->
    <!-- * source; see above -->
    <title>
      <xsl:choose>
        <xsl:when test="refmeta/refentrytitle">
          <xsl:copy>
            <xsl:apply-templates select="refmeta/refentrytitle/node()"/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>

    <!-- * <date> is a date :-) If we can't find one, we add one; see below -->
    <date>
      <xsl:call-template name="replace-entities">
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="info/date">
              <xsl:copy>
                <xsl:apply-templates select="info/date/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="info/pubdate">
              <xsl:copy>
                <xsl:apply-templates select="info/pubdate/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="refentryinfo/date">
              <xsl:copy>
                <xsl:apply-templates select="refentryinfo/date/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="refentryinfo/pubdate">
              <xsl:copy>
                <xsl:apply-templates select="refentryinfo/pubdate/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="../info/date">
              <xsl:copy>
                <xsl:apply-templates select="../info/date/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="../info/pubdate">
              <xsl:copy>
                <xsl:apply-templates select="../info/pubdate/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="../referenceinfo/date">
              <xsl:copy>
                <xsl:apply-templates select="../referenceinfo/date/node()"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="../referenceinfo/pubdate">
              <xsl:copy>
                <xsl:apply-templates select="../referenceinfo/pubdate/node()"/>
              </xsl:copy>
            </xsl:when>
            <!-- * If we can't find a date, then we generate a date. -->
            <!-- * And we make it an appropriately localized date. -->
            <xsl:otherwise>
              <xsl:call-template name="datetime.format">
                <xsl:with-param name="date">
                  <xsl:choose>
                    <xsl:when test="function-available('date:date-time')">
                      <xsl:value-of select="date:date-time()"/>
                    </xsl:when>
                    <xsl:when test="function-available('date:dateTime')">
                      <!-- Xalan quirk -->
                      <xsl:value-of select="date:dateTime()"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="format">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'datetime'"/>
                    <xsl:with-param name="name" select="'format'"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </date>

    <!-- * <versionorname> = (in the best case) we just want to find some kind -->
    <!-- * of version number. If we can't find that, we try to find a product -->
    <!-- * name. If we can't find that, we try to find some other kind of info. -->
    <!-- * And if that fails, well, then we just leave it empty. -->
    <versionorname>
      <xsl:choose>
        <xsl:when test="info/productnumber">
          <xsl:apply-templates select="info/productnumber/node()"/>
        </xsl:when>
        <xsl:when test="refentryinfo/productnumber">
          <xsl:apply-templates select="refentryinfo/productnumber/node()"/>
        </xsl:when>
        <xsl:when test="refmeta/refmiscinfo[@class = 'version']">
          <xsl:apply-templates select="refmeta/refmiscinfo/node()"/>
        </xsl:when>
        <xsl:when test="../info/productnumber">
          <xsl:apply-templates select="../info/productnumber/node()"/>
        </xsl:when>
        <xsl:when test="../referenceinfo/productnumber">
          <xsl:apply-templates select="../referenceinfo/productnumber/node()"/>
        </xsl:when>
        <xsl:when test="info/productname">
          <xsl:apply-templates select="info/productname/node()"/>
        </xsl:when>
        <xsl:when test="refentryinfo/productname">
          <xsl:apply-templates select="refentryinfo/productnam/node()"/>
        </xsl:when>
        <xsl:when test="../info/productname">
          <xsl:apply-templates select="../info/productnam/node()"/>
        </xsl:when>
        <xsl:when test="../referenceinfo/productname">
          <xsl:apply-templates select="../referenceinfo/productname/node()"/>
        </xsl:when>
        <xsl:when test="refmeta/refmiscinfo">
          <xsl:apply-templates select="refmeta/refmiscinfo[1]/node()"/>
        </xsl:when>
        <xsl:when test="refnamediv/refclass">
          <xsl:apply-templates select="refnamediv[1]/refclass[1]/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- found nothing, so leave it empty -->
        </xsl:otherwise>
      </xsl:choose>
    </versionorname>

    <!-- * The <othermetadata> element holds information other than the title, -->
    <!-- * section number, date, or application/product version/name; typically, -->
    <!-- * what we want in <othermetadata> is some kind of "context description" -->
    <!-- * about the item - for example, it is often a description of the -->
    <!-- * "superset" of applications/functions, etc., that the item documented in -->
    <!-- * the man page belongs to -->
    <!-- * -->
    <!-- * Examples: -->
    <!-- * -->
    <!-- *   PROGRAM     CONTEXT INFO (in TH "extra3") -->
    <!-- *   =======   - ==================================== -->
    <!-- *   dpkg-name - "dpkg utilities" -->
    <!-- *   GET       - "User Contributed Perl Documentation" -->
    <!-- *   ld        - "GNU Development Tools" -->
    <!-- *   ddate     - "Emperor Norton Utilities" -->
    <!-- *   dh_clean  - "Debhelper" -->
    <!-- *   faked     - "Debian GNU/Linux manual" -->
    <!-- *   gimp      - "GIMP Manual Pages" -->
    <!-- *   qt2kdoc   - "KDOC Documentation System" -->
    <!-- * -->
    <!-- * We just leave it empty if we can't find anything to use -->
    <othermetadata>
      <xsl:choose>
        <xsl:when test="../info/title">
          <xsl:apply-templates select="../info/title/node()"/>
        </xsl:when>
        <xsl:when test="../referenceinfo/title">
          <xsl:apply-templates select="../referenceinfo/title/node()"/>
        </xsl:when>
        <xsl:when test="../title">
          <xsl:apply-templates select="../title/node()"/>
        </xsl:when>
        <xsl:when test="refnamediv/refclass">
          <xsl:apply-templates select="refnamediv[1]/refclass[1]/node()"/>
        </xsl:when>
        <xsl:when test="refmeta/refmiscinfo">
          <xsl:apply-templates select="refmeta/refmiscinfo[1]/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- found nothing, so leave it empty -->
        </xsl:otherwise>
      </xsl:choose>
    </othermetadata>

  </xsl:template>

  <!-- * ============================================================== -->

  <xsl:template name="author.section">
    <xsl:choose>
      <xsl:when test="info//author">
        <xsl:apply-templates select="info" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="refentryinfo//author">
        <xsl:apply-templates select="refentryinfo" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="/book/bookinfo//author">
        <xsl:apply-templates select="/book/bookinfo" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="/article/articleinfo//author">
        <xsl:apply-templates select="/article/articleinfo" mode="authorsect"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="info|articleinfo|bookinfo|refentryinfo" mode="authorsect">
    <xsl:text>.SH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Author'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>

    <xsl:for-each select=".//author">
      <xsl:if test="position() > 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text>. &#10;</xsl:text>
    <xsl:if test=".//editor">
      <xsl:text>.br&#10;</xsl:text>
      <xsl:apply-templates select=".//editor"/>
      <xsl:text>. (man page)&#10;</xsl:text>
    </xsl:if>
    <xsl:for-each select="address">
      <xsl:text>.br&#10;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="author|editor">
    <xsl:call-template name="person.name"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select=".//email"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="email">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="copyright">
    <xsl:text>Copyright \(co  </xsl:text>
    <xsl:apply-templates select="./year" />
    <xsl:text>.Sp&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
