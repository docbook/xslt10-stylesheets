<?xml version="1.0" encoding="utf-8"?>

<!-- TODO:  Find a way to add a search...ideally i18n-ized. -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <!-- Adjust this path as necessary -->
  <xsl:import href="https://cdn.docbook.org/release/xsl/1.64.1/htmlhelp/htmlhelp.xsl"/>
  <xsl:include href="htmlhelp-common.xsl"/>

  <!-- Five new parameters: -->

  <!-- htmlhelp.generate.frameset turns the whole thing on and off -->
  <xsl:param name="htmlhelp.generate.frameset" select="1"/>

  <!-- htmlhelp.frameset.graphics.path defines the path to the images for the tabs on the nav pane -->
  <xsl:param name="htmlhelp.frameset.graphics.path">images/</xsl:param>

  <!-- These must be different from each other and (unless
  you define base.dir), they also must be different from all
  the generated chunks. -->
  <xsl:param name="htmlhelp.frameset.start.filename">index<xsl:value-of select="$html.ext"/></xsl:param>
  <xsl:param name="htmlhelp.frameset.toc.pane.filename">contents.pane<xsl:value-of select="$html.ext"/></xsl:param>
  <xsl:param name="htmlhelp.frameset.index.pane.filename">index.pane<xsl:value-of select="$html.ext"/></xsl:param>

  <!-- Other params that need setting: -->

  <!-- This tells the stylesheets not to put the various helpset config files
  and frameset files in the same directory as the html files generated from
  the chunking of document. This is preferred because it eliminates the chance
  that any of the names of the frameset html files might collide with the
  generated chunks.   -->
  <xsl:param name="manifest.in.base.dir" select="0"/>
  <xsl:param name="base.dir" select="'files/'"/>
 
  <!-- This is required if you want your index pane populated because -->
  <!-- The non-hhk type index doesn't work with applet help -->
  <xsl:param name="htmlhelp.use.hhk" select="1"/>
  
  <!-- This is on by default. Setting it to zero would obviously be a bad
  idea. If don't want an index pane, I wonder why you're bothering with
  applet-style help to begin with. -->
  <xsl:param name="generate.index" select="1"/>

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
	  <xsl:with-param name="filename">
		<xsl:if test="$manifest.in.base.dir != 0">
		  <xsl:value-of select="$base.dir"/>
		</xsl:if>
		<xsl:value-of select="$htmlhelp.frameset.start.filename"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="content" select="$contents.pane"/>
	  <xsl:with-param name="filename">
		<xsl:if test="$manifest.in.base.dir != 0">
		  <xsl:value-of select="$base.dir"/>
		</xsl:if>
		<xsl:value-of select="$htmlhelp.frameset.toc.pane.filename"/>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:if test="$generate.index">
	  <xsl:call-template name="write.chunk">
		<xsl:with-param name="content" select="$index.pane"/>
		<xsl:with-param name="filename">
		<xsl:if test="$manifest.in.base.dir != 0">
		  <xsl:value-of select="$base.dir"/>
		</xsl:if>
		  <xsl:value-of select="$htmlhelp.frameset.index.pane.filename"/>
		</xsl:with-param>
	  </xsl:call-template>
	</xsl:if>

  </xsl:template>

</xsl:stylesheet>

