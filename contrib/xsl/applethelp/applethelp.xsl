<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <!-- Adjust this path as necessary -->
  <xsl:import href="htmlhelp.xsl"/>

  <!-- Five new parameters: -->
  <!-- htmlhelp.generate.frameset turns the whole thing on and off -->
  <xsl:param name="htmlhelp.generate.frameset" select="1"/>
  <!-- htmlhelp.frameset.graphics.path defines the path to the images for the tabs on the nav pane -->
  <xsl:param name="htmlhelp.frameset.graphics.path">images/</xsl:param>
  <!-- These must be different from each other and (unless
  you define base.dir), they also must be different from all
  the generated chunks. -->
  <xsl:param name="htmlhelp.frameset.start.filename">index.html</xsl:param>
  <xsl:param name="htmlhelp.frameset.toc.pane.filename">contents.pane.html</xsl:param>
  <xsl:param name="htmlhelp.frameset.index.pane.filename">index.pane.html</xsl:param>

  <!-- Hmm. Currenly you really need to set this... -->
  <xsl:param name="htmlhelp.default.topic" select="'index.html'"/>

  <!-- This defines the directory for the html files. We
  have to define this because we don't want the name of the
  frameset html files to collide with the generated
  chunks. --> 
  <xsl:param name="base.dir" select="'files/'"/>

  <!-- This is required if you want an index -->
  <!-- The non-hhk type index doesn't work with applet help -->
  <xsl:param name="htmlhelp.use.hhk" select="1"/>

  <!-- These are just some of my preferences, they don't necessarily matter -->
  <xsl:param name="chunk.section.depth" select="100"/>
  <xsl:param name="htmlhelp.hhc.show.root" select="0"/>

  <xsl:template name="generate.htmlhelp.frameset">
	<xsl:variable name="topic.pane">
	  <html>
		<xsl:call-template name="head.content">
		  <xsl:with-param name="node" select="/"/>
		</xsl:call-template>
		<!--head>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
		<title>Text for title bar</title>
	  </head-->
		<frameset cols="250,*" framespacing="0" border="0" frameborder="0">
		  <!-- This points to a page that contains the toc applet -->
		  <frame name="contents" target="main" src="contents.pane.html" scrolling="auto"/>
		  <!-- This src points to the 'default topic' html page  -->
		  <frame 
			name="main" 
			scrolling="auto" 
			noresize="noresize">
		  <xsl:if test="$htmlhelp.default.topic != ''">
			<xsl:attribute name="src"><xsl:value-of select="$base.dir"/><xsl:value-of select="$htmlhelp.default.topic"/></xsl:attribute>
		  </xsl:if>
		  </frame>
		  <noframes>
			<body>
			  <p>This page uses frames, but your browser doesn't support them.</p>
			</body>
		  </noframes>
		</frameset>
	  </html>
	</xsl:variable>
	<xsl:variable name="contents.pane">
	  <html>
		<head>
		  <meta http-equiv="Content-Type" content="text/html; charset={$chunker.output.encoding}"/>
		  <title>Contents Pane</title>
		  <base target="main"/>
		</head>
		<body topmargin="0" leftmargin="0">
		  <div align="left">
			<img border="0" src="{$htmlhelp.frameset.graphics.path}cnttab.gif" width="58" height="20"/>
			<xsl:if test="$generate.index">
			  <!-- href points to a page that contains the index applet and tabs -->
			  <a href="{$htmlhelp.frameset.index.pane.filename}" target="_self" accesskey="n" onfocus="self.location = '{$htmlhelp.frameset.index.pane.filename}'">
				<img border="0" src="{$htmlhelp.frameset.graphics.path}cntidx.gif" width="40" height="20"/>
			  </a>
			</xsl:if>
			<!-- BEGIN HTML HELP JAVA APPLET CODE -->
			<br/>
			<applet code="HHCtrl.class" width="600%" height="1200" 
			  archive="HHCtrl.zip" name="HHCtrl" style="padding-top: 0">
			  <param name="command" value="contents"/>
			  <param name="item1" value="{$htmlhelp.hhc}"/>
			  <param name="cabbase" value="HHCtrl.cab"/>
			</applet>
			<!-- END HTML HELP JAVA APPLET CODE -->
		  </div>
		</body>
	  </html>
	</xsl:variable>
	<xsl:variable name="index.pane">
	  <html>
		<head>
		  <meta http-equiv="Content-Type" content="text/html; charset={$chunker.output.encoding}"/>
		  <title>Index Pane</title>
		  <base target="main"/>
		</head>
		<body topmargin="0" leftmargin="0">
		  <div align="left">
			<a href="{$htmlhelp.frameset.toc.pane.filename}" target="_self" accesskey="C" onfocus="self.location = '{$htmlhelp.frameset.toc.pane.filename}'">
			  <img border="0" src="{$htmlhelp.frameset.graphics.path}indexcnt.gif" width="54" height="20"/>
			</a>
			<img border="0" src="{$htmlhelp.frameset.graphics.path}indextab.gif" width="46" height="20"/>
			<br/>
			<!-- BEGIN HTML HELP JAVA APPLET CODE -->
			<applet code="HHCtrl.class" width="1200%" height="1200" 
			  archive="HHCtrl.zip" name="HHCtrl" style="padding-top: 0">
			  <param name="command" value="index"/>
			  <param name="background" value="FFFFFF"/>
			  <param name="item1" value="{$htmlhelp.hhk}"/>
			  <param name="cabbase" value="HHCtrl.cab"/>
			</applet>
			<!-- END HTML HELP JAVA APPLET CODE -->
		  </div>
		</body>
	  </html>
	</xsl:variable>

	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="content" select="$topic.pane"/>
	  <xsl:with-param name="filename" select="$htmlhelp.frameset.start.filename"/>
	</xsl:call-template>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="content" select="$contents.pane"/>
	  <xsl:with-param name="filename" select="$htmlhelp.frameset.toc.pane.filename"/>
	</xsl:call-template>
	<xsl:if test="$generate.index">
	  <xsl:call-template name="write.chunk">
		<xsl:with-param name="content" select="$index.pane"/>
		<xsl:with-param name="filename" select="$htmlhelp.frameset.index.pane.filename"/>
	  </xsl:call-template>
	</xsl:if>

  </xsl:template>


  <xsl:template name="hhc-main">
	<xsl:text disable-output-escaping="yes">&lt;HTML&gt;
	  &lt;HEAD&gt;
	  &lt;/HEAD&gt;
	  &lt;BODY&gt;
	</xsl:text>
	<!-- Adding support for frameset style help -->
    <xsl:text disable-output-escaping="yes">&lt;OBJECT type="text/site properties"&gt;
	  &lt;param name="FrameName" value="main"&gt;
	  &lt;param name="Window Styles" value="0x800025"&gt;</xsl:text>
	<xsl:if test="$htmlhelp.hhc.folders.instead.books != 0">
	  <xsl:text disable-output-escaping="yes">&lt;param name="ImageType" value="Folder"&gt;</xsl:text>
	</xsl:if>
	<xsl:text disable-output-escaping="yes">&lt;/OBJECT&gt;</xsl:text>
	<xsl:if test="$htmlhelp.hhc.show.root != 0">
	  <xsl:text disable-output-escaping="yes">&lt;UL&gt;
	  </xsl:text>
	</xsl:if>

	<xsl:choose>
	  <xsl:when test="$rootid != ''">
		<xsl:apply-templates select="key('id',$rootid)" mode="hhc"/>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:apply-templates select="/" mode="hhc"/>
	  </xsl:otherwise>
	</xsl:choose>

	<xsl:if test="$htmlhelp.hhc.show.root != 0">
	  <xsl:text disable-output-escaping="yes">&lt;/UL&gt;
	  </xsl:text>
	</xsl:if>
	<xsl:text disable-output-escaping="yes">&lt;/BODY&gt;
	  &lt;/HTML&gt;</xsl:text>
  </xsl:template>


  <xsl:template name="hhk">
	<xsl:call-template name="write.text.chunk">
	  <xsl:with-param name="filename" select="$htmlhelp.hhk"/>
	  <xsl:with-param name="method" select="'text'"/>
	  <xsl:with-param name="content"><![CDATA[<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
		<HTML>
		<HEAD>
		<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
		<!-- Sitemap 1.0 -->
	  </HEAD><BODY>
		<OBJECT type="text/site properties">
		<!-- Adding for frameset -->
		<param name="FrameName" value="main">
	  </OBJECT>
		<UL>]]>
		<xsl:if test="($htmlhelp.use.hhk != 0) and $generate.index">
		  <xsl:choose>
			<xsl:when test="$rootid != ''">
			  <xsl:apply-templates select="key('id',$rootid)" mode="hhk"/>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:apply-templates select="/" mode="hhk"/>
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:if>
		<![CDATA[</UL>
	  </BODY></HTML>]]></xsl:with-param>
	  <xsl:with-param name="encoding" select="$htmlhelp.encoding"/>
	</xsl:call-template>
  </xsl:template>

  <xsl:template match="/">
	<xsl:if test="$htmlhelp.only != 1">
	  <xsl:choose>
		<xsl:when test="$rootid != ''">
		  <xsl:choose>
			<xsl:when test="count(key('id',$rootid)) = 0">
			  <xsl:message terminate="yes">
				<xsl:text>ID '</xsl:text>
				<xsl:value-of select="$rootid"/>
				<xsl:text>' not found in document.</xsl:text>
			  </xsl:message>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:message>Formatting from <xsl:value-of select="$rootid"/></xsl:message>
			  <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates select="/" mode="process.root"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:if>

	<xsl:call-template name="hhp"/>
	<xsl:call-template name="hhc"/>
	<xsl:if test="($rootid = '' and //processing-instruction('dbhh')) or
	  ($rootid != '' and key('id',$rootid)//processing-instruction('dbhh'))">
	  <xsl:call-template name="hh-map"/>
	  <xsl:call-template name="hh-alias"/>
	</xsl:if>
	<xsl:if test="$generate.index">
	  <xsl:call-template name="hhk"/>
	</xsl:if>
	<xsl:if test="$htmlhelp.generate.frameset">
	  <xsl:call-template name="generate.htmlhelp.frameset"/>
	</xsl:if>
  </xsl:template>


</xsl:stylesheet>

