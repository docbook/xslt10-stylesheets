<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or http://docbook.sf.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template name="setup.pagemasters">
  <fo:layout-master-set>
    <!-- blank pages -->
    <fo:simple-page-master master-name="blank"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-blank"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-blank"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- title pages -->
    <fo:simple-page-master master-name="titlepage-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="titlepage-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="titlepage-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- list-of-title pages -->
    <fo:simple-page-master master-name="lot-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="lot-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="lot-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- frontmatter pages -->
    <fo:simple-page-master master-name="front-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="front-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="front-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- body pages -->
    <fo:simple-page-master master-name="body-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- backmatter pages -->
    <fo:simple-page-master master-name="back-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="back-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="back-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- index pages -->
    <fo:simple-page-master master-name="index-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="index-odd"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="index-even"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- draft blank pages -->
    <fo:simple-page-master master-name="blank-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-blank"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-blank"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- draft title pages -->
    <fo:simple-page-master master-name="titlepage-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="titlepage-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="titlepage-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.titlepage}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-titlepage-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-titlepage-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- draft list-of-title pages -->
    <fo:simple-page-master master-name="lot-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="lot-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="lot-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.lot}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-lot-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-lot-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- draft frontmatter pages -->
    <fo:simple-page-master master-name="front-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-first"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="front-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-odd"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="front-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.front}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-front-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-front-even"
                       extent="{$region.after.extent}"
                        display-align="after"/>
    </fo:simple-page-master>

    <!-- draft body pages -->
    <fo:simple-page-master master-name="body-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.body}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-body-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-body-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- draft backmatter pages -->
    <fo:simple-page-master master-name="back-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="back-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="back-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.back}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-back-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-back-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- draft index pages -->
    <fo:simple-page-master master-name="index-first-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="index-odd-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="index-even-draft"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}"
                           margin-left="{$page.margin.inner}"
                           margin-right="{$page.margin.outer}">
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      column-count="{$column.count.index}">
        <xsl:if test="$draft.watermark.image != ''
                      and $fop.extensions = 0">
          <xsl:attribute name="background-image">
            <xsl:value-of select="$draft.watermark.image"/>
          </xsl:attribute>
          <xsl:attribute name="background-attachment">fixed</xsl:attribute>
          <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
          <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
          <xsl:attribute name="background-position-vertical">center</xsl:attribute>
        </xsl:if>
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-index-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-index-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
    </fo:simple-page-master>

    <!-- setup for title page(s) -->
    <fo:page-sequence-master master-name="titlepage">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="titlepage-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="titlepage-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="titlepage-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for lots -->
    <fo:page-sequence-master master-name="lot">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="lot-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="lot-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="lot-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup front matter -->
    <fo:page-sequence-master master-name="front">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="front-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="front-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="front-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for body pages -->
    <fo:page-sequence-master master-name="body">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="body-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="body-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="body-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup back matter -->
    <fo:page-sequence-master master-name="back">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="back-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="back-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="back-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup back matter -->
    <fo:page-sequence-master master-name="index">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="index-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="index-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="index-even"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for draft title page(s) -->
    <fo:page-sequence-master master-name="titlepage-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="titlepage-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="titlepage-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="titlepage-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for draft lots -->
    <fo:page-sequence-master master-name="lot-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="lot-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="lot-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="lot-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft front matter -->
    <fo:page-sequence-master master-name="front-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="front-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="front-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="front-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for draft body pages -->
    <fo:page-sequence-master master-name="body-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="body-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="body-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="body-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft back matter -->
    <fo:page-sequence-master master-name="back-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="back-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="back-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="back-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft index pages -->
    <fo:page-sequence-master master-name="index-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="index-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="index-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference master-reference="index-even-draft"
                                              odd-or-even="even"/>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <xsl:call-template name="user.pagemasters"/>

    </fo:layout-master-set>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="user.pagemasters"/> <!-- intentionally empty -->

<!-- ==================================================================== -->

<xsl:template name="select.pagemaster">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="pageclass" select="''"/>

  <xsl:choose>
    <xsl:when test="$pageclass != ''">
      <xsl:value-of select="$pageclass"/>
    </xsl:when>
    <xsl:when test="$pageclass = 'lot'">lot</xsl:when>
    <xsl:when test="$element = 'dedication'">front</xsl:when>
    <xsl:when test="$element = 'preface'">front</xsl:when>
    <xsl:when test="$element = 'appendix'">back</xsl:when>
    <xsl:when test="$element = 'glossary'">back</xsl:when>
    <xsl:when test="$element = 'bibliography'">back</xsl:when>
    <xsl:when test="$element = 'index'">index</xsl:when>
    <xsl:when test="$element = 'colophon'">back</xsl:when>
    <xsl:otherwise>body</xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$draft.mode = 'yes'">
      <xsl:text>-draft</xsl:text>
    </xsl:when>
    <xsl:when test="$draft.mode = 'no'">
      <!-- nop -->
    </xsl:when>
    <xsl:when test="ancestor-or-self::*[@status][1]/@status = 'draft'">
      <xsl:text>-draft</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="head.sep.rule">
  <xsl:if test="$header.rule != 0">
    <xsl:attribute name="border-bottom-width">1px</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-color">black</xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="foot.sep.rule">
  <xsl:if test="$footer.rule != 0">
    <xsl:attribute name="border-top-width">1px</xsl:attribute>
    <xsl:attribute name="border-top-style">solid</xsl:attribute>
    <xsl:attribute name="border-top-color">black</xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="running.head.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <xsl:param name="gentext-key" select="'TableofContents'"/>

  <!-- remove -draft from reference -->
  <xsl:variable name="flow-name">
    <xsl:choose>
      <xsl:when test="contains($master-reference, '-draft')">
        <xsl:value-of select="substring-before($master-reference, '-draft')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$master-reference"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:message>running head for <xsl:value-of select="local-name(.)"/> with ref <xsl:value-of select="$flow-name"/></xsl:message>

  <xsl:variable name="draft">
    <xsl:choose>
      <xsl:when test="$draft.mode = 'yes'">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Draft'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$draft.mode = 'no'">
        <!-- nop -->
      </xsl:when>
      <xsl:when test="ancestor-or-self::*[@status][1]/@status = 'draft'">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Draft'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="head-blank">
    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-number="1" column-width="33%"/>
      <fo:table-column column-number="2" column-width="34%"/>
      <fo:table-column column-number="3" column-width="33%"/>
      <fo:table-body>
        <fo:table-row height="14pt">
          <fo:table-cell text-align="left"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         relative-align="baseline"
                         display-align="before">
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <xsl:variable name="head-empty">
    <fo:table table-layout="fixed" width="100%">
      <xsl:call-template name="head.sep.rule"/>
      <fo:table-column column-number="1" column-width="33%"/>
      <fo:table-column column-number="2" column-width="34%"/>
      <fo:table-column column-number="3" column-width="33%"/>
      <fo:table-body>
        <fo:table-row height="14pt">
          <fo:table-cell text-align="left"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         relative-align="baseline"
                         display-align="before">
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <xsl:variable name="head-even">
    <fo:table table-layout="fixed" width="100%">
      <xsl:call-template name="head.sep.rule"/>
      <fo:table-column column-number="1" column-width="33%"/>
      <fo:table-column column-number="2" column-width="34%"/>
      <fo:table-column column-number="3" column-width="33%"/>
      <fo:table-body>
        <fo:table-row height="14pt">
          <fo:table-cell text-align="left"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:choose>
                <xsl:when test="starts-with($master-reference, 'lot')">
                  <xsl:call-template name="gentext">
                    <xsl:with-param name="key" select="$gentext-key"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <xsl:variable name="head-odd">
    <fo:table table-layout="fixed" width="100%">
      <xsl:call-template name="head.sep.rule"/>
      <fo:table-column column-number="1" column-width="33%"/>
      <fo:table-column column-number="2" column-width="34%"/>
      <fo:table-column column-number="3" column-width="33%"/>
      <fo:table-body>
        <fo:table-row height="14pt">
          <fo:table-cell text-align="left"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:choose>
                <xsl:when test="ancestor::book and ($double.sided != 0)">
                  <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                      retrieve-position="first-including-carryover"
                                      retrieve-boundary="page"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         relative-align="baseline"
                         display-align="before">
            <fo:block>
              <xsl:value-of select="$draft"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="starts-with($master-reference, 'titlepage')">
      <fo:static-content flow-name="xsl-region-before-{$flow-name}-first">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-blank"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-odd">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-blank"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-even">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-blank"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-blank">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:if test="$headers.on.blank.pages != 0">
            <xsl:copy-of select="$head-empty"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
    </xsl:when>

    <xsl:when test="starts-with($master-reference, 'lot')">
      <fo:static-content flow-name="xsl-region-before-{$flow-name}-first">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-empty"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-odd">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-even"/> <!-- yes, even -->
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-even">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-even"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-blank">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:if test="$headers.on.blank.pages != 0">
            <xsl:copy-of select="$head-empty"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
    </xsl:when>

    <xsl:otherwise>
      <fo:static-content flow-name="xsl-region-before-{$flow-name}-first">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-empty"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-odd">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-odd"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-{$flow-name}-even">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:copy-of select="$head-even"/>
        </fo:block>
      </fo:static-content>

      <fo:static-content flow-name="xsl-region-before-blank">
        <fo:block margin-left="{$title.margin.left}">
          <xsl:if test="$headers.on.blank.pages != 0">
            <xsl:copy-of select="$head-empty"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="running.foot.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <xsl:param name="gentext-key" select="'TableofContents'"/>

  <!-- remove -draft from reference -->
  <xsl:variable name="flow-name">
    <xsl:choose>
      <xsl:when test="contains($master-reference, '-draft')">
        <xsl:value-of select="substring-before($master-reference, '-draft')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$master-reference"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- by default, the page number -->
  <xsl:variable name="foot">
    <fo:page-number/>
  </xsl:variable>

  <xsl:variable name="align-odd">
    <xsl:choose>
      <xsl:when test="$double.sided != 0">right</xsl:when>
      <xsl:otherwise>center</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="align-even">
    <xsl:choose>
      <xsl:when test="$double.sided != 0">left</xsl:when>
      <xsl:otherwise>center</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="starts-with($master-reference,'titlepage')">
      <!-- no footers; but maybe footers on a following blank page -->
      <fo:static-content flow-name="xsl-region-after-blank">
        <fo:block text-align="{$align-even}" margin-left="{$title.margin.left}">
          <xsl:if test="$footers.on.blank.pages != 0">
            <xsl:call-template name="foot.sep.rule"/>
            <xsl:copy-of select="$foot"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
    </xsl:when>
    <xsl:when test="$master-reference = 'titlepage'
                    or $master-reference = 'lot'
                    or $master-reference = 'front'
                    or $master-reference = 'body'
                    or $master-reference = 'back'
                    or $master-reference = 'index'
                    or $master-reference = 'titlepage-draft'
                    or $master-reference = 'lot-draft'
                    or $master-reference = 'front-draft'
                    or $master-reference = 'body-draft'
                    or $master-reference = 'back-draft'
                    or $master-reference = 'index-draft'">
      <fo:static-content flow-name="xsl-region-after-{$flow-name}-first">
        <fo:block text-align="{$align-odd}" margin-left="{$title.margin.left}">
          <xsl:call-template name="foot.sep.rule"/>
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-{$flow-name}-odd">
        <fo:block text-align="{$align-odd}" margin-left="{$title.margin.left}">
          <xsl:call-template name="foot.sep.rule"/>
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-{$flow-name}-even">
        <fo:block text-align="{$align-even}" margin-left="{$title.margin.left}">
          <xsl:call-template name="foot.sep.rule"/>
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-blank">
        <fo:block text-align="{$align-even}" margin-left="{$title.margin.left}">
          <xsl:if test="$footers.on.blank.pages != 0">
            <xsl:call-template name="foot.sep.rule"/>
            <xsl:copy-of select="$foot"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected master-reference (</xsl:text>
        <xsl:value-of select="$master-reference"/>
        <xsl:text>) in running.foot.mode for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>. No footer generated.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
