<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exsl="http://exslt.org/common"
        xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0"
        version="1.0" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk.xsl"/>
 
    <xsl:include href="keywords.xsl"/>

    <!--TODO check how html and xml behaves-->
    <xsl:output
            method="html"
            encoding="utf-8"
            cdata-section-elements=""/>

    <!-- Custom params! -->
    <xsl:param name="exclude.search.from.chunked.html">false</xsl:param>
    <xsl:param name="chunk.frameset.start.filename">index.html</xsl:param>
    <xsl:param name="output_file_name">readme</xsl:param>
    <xsl:param name="chunked.toc.all.open">1</xsl:param>
    <xsl:param name="frameset.base.dir">doc</xsl:param>
    <xsl:param name="generate.web.xml">0</xsl:param>
    <xsl:param name="direction.align.start">left</xsl:param>
    <xsl:param name="direction.align.end">right</xsl:param>
    <xsl:variable name="tree.cookie.id" select="concat( 'treeview-', count(//node()) )"/>
    <!-- Custom params! -->

    <xsl:param name="chunker.output.indent">no</xsl:param>
    <xsl:param name="navig.showtitles">0</xsl:param>
                                                                                    
    <xsl:param name="manifest.in.base.dir" select="0"/>
    <xsl:param name="base.dir" select="concat($frameset.base.dir,'/content/')"/>
    <xsl:param name="suppress.navigation">0</xsl:param>
    <xsl:param name="generate.index" select="1"/>
    <xsl:param name="inherit.keywords" select="'0'"/>
    <xsl:param name="local.l10n.xml" select="document('')"/>
    <xsl:param name="para.propagates.style" select="1"/>
    <xsl:param name="phrase.propagates.style" select="1"/>
    <xsl:param name="chunk.first.sections" select="1"/>
    <xsl:param name="chapter.autolabel" select="0"/>
    <xsl:param name="section.autolabel" select="0"/>
    <xsl:param name="generate.toc">book toc</xsl:param>

    <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
            <!-- These are for the search stuff in chunked/plainhelp output -->
            <l:gentext key="Search" text="Search"/>
            <l:gentext key="Enter_a_term_and_click" text="Enter a term and click "/>
            <l:gentext key="Go" text="Go"/>
            <l:gentext key="to_perform_a_search" text=" to perform a search."/>
            <l:gentext key="txt_filesfound" text="Results"/>
            <l:gentext key="txt_enter_at_least_1_char" text="You must enter at least one character."/>
            <l:gentext key="txt_browser_not_supported"
                       text="Your browser is not supported. Use of Mozilla Firefox is recommended."/>
            <l:gentext key="txt_please_wait" text="Please wait. Search in progress..."/>
            <l:gentext key="txt_results_for" text="Results for: "/>
            <l:gentext key="TableofContents" text="Contents"/>
        </l10n>
    </i18n>

    <xsl:template name="user.head.content">
        <!--xsl:message>
            tree.cookie.id = <xsl:value-of select="$tree.cookie.id"/> +++ <xsl:value-of select="count(//node())"/>
        </xsl:message-->
        <script type="text/javascript">
            //The id for tree cookie
            var treeCookieId = "<xsl:value-of select="$tree.cookie.id"/>";
            
            //Localization
            txt_filesfound = '<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'txt_filesfound'"/>
                </xsl:call-template>';
            txt_enter_at_least_1_char = "<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'txt_enter_at_least_1_char'"/>
                </xsl:call-template>";
            txt_browser_not_supported = "<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'txt_browser_not_supported'"/>
                </xsl:call-template>";
            txt_please_wait = "<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'txt_please_wait'"/>
                </xsl:call-template>";
            txt_results_for = "<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'txt_results_for'"/>
                </xsl:call-template>";
        </script>
        <style type="text/css">
            input {
                margin-bottom: 5px;
                margin-top: 2px;
            }

            .folder {
                display: block;
                height: 22px;
                padding-left: 20px;
                background: transparent url(../common/jquery/treeview/images/folder.gif) 0 0px no-repeat;
            }
        <!--[if IE]>
            input {
                margin-bottom: 5px;
                margin-top: 2px;
            }
            <![endif]-->
        </style>  
        <link rel="stylesheet" type="text/css" href="../common/css/positioning.css"/>
        <link rel="stylesheet" type="text/css" href="../common/jquery/theme-redmond/jquery-ui-1.8.2.custom.css"/>
        <link rel="stylesheet" type="text/css" href="../common/jquery/treeview/jquery.treeview.css"/>

        <script type="text/javascript" src="../common/jquery/jquery-1.4.2.min.js">
            <xsl:comment></xsl:comment>
        </script>
        <script type="text/javascript" src="../common/jquery/jquery-ui-1.8.2.custom.min.js">
            <xsl:comment></xsl:comment>
        </script>
        <script type="text/javascript" src="../common/jquery/jquery.cookie.js">
            <xsl:comment></xsl:comment>
        </script>
        <script type="text/javascript" src="../common/jquery/treeview/jquery.treeview.min.js">
            <xsl:comment></xsl:comment>
        </script>
        <!--Scripts/css stylesheets for Search-->
        <script type="text/javascript" src="search/addition.js">
            <xsl:comment></xsl:comment>
        </script>

        <script type="text/javascript" src="search/indexLoader.js">
            <xsl:comment></xsl:comment>
        </script>

        <script type="text/javascript" src="search/nwSearchFnt.js">
            <xsl:comment></xsl:comment>
        </script>
    </xsl:template>

    <xsl:template name="user.header.navigation"> 
        <xsl:call-template name="webhelpheader"/>
        <!--xsl:call-template name="webhelptoc"/-->

        <!--testing toc in the content page>
        <xsl:call-template name="webhelptoctoc"/>
        <xsl:if test="$exclude.search.from.chunked.html != 'true'">
            <xsl:call-template name="search"/>
        </xsl:if-->

    </xsl:template>

    <xsl:template name="user.footer.navigation"> 
    	<xsl:call-template name="webhelptoc">
		  <xsl:with-param name="currentid" select="generate-id(.)"/>
	     </xsl:call-template>
    </xsl:template>

    <xsl:template match="/">
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
                        <xsl:message>Formatting from
                            <xsl:value-of select="$rootid"/>
                        </xsl:message>
                        <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="/" mode="process.root"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="index.html"/>

        <xsl:if test="$generate.web.xml != '0'">
            <xsl:call-template name="web.xml"/>
        </xsl:if>
    </xsl:template>

<xsl:template name="chunk-element-content">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:call-template name="user.preroot"/>

  <html>
    <xsl:call-template name="html.head">
      <xsl:with-param name="prev" select="$prev"/>
      <xsl:with-param name="next" select="$next"/>
    </xsl:call-template>

    <body>
      <xsl:call-template name="body.attributes"/>

      <xsl:call-template name="user.header.navigation"/>

      <div id="content">
          <xsl:call-template name="header.navigation">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
              <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>

          <xsl:call-template name="user.header.content"/>

          <xsl:copy-of select="$content"/>

          <xsl:call-template name="user.footer.content"/>

          <xsl:call-template name="footer.navigation">
              <xsl:with-param name="prev" select="$prev"/>
              <xsl:with-param name="next" select="$next"/>
              <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
      </div>
        
		<xsl:call-template name="user.footer.navigation"/>
    </body>
  </html>
  <xsl:value-of select="$chunk.append"/>
</xsl:template>

<!-- The Header with the company logo -->
<xsl:template name="webhelpheader">

      <xsl:variable name="home" select="/*[1]"/>
      <xsl:variable name="up" select="parent::*"/>

        <div id="header">
            <img style='margin-right: 2px; height: 59px; padding-right: 25px; padding-top: 8px' align="right"
                 src='../common/images/logo.png' alt="DocBook"/>

            <!-- Display the page title and the main heading(parent) of it-->
            <h1 align="center">
                <xsl:apply-templates select="." mode="object.title.markup"/>
                <br/>
                <xsl:choose>
                    <xsl:when
                            test="count($up) &gt; 0 and generate-id($up) != generate-id($home)">
                        <xsl:apply-templates select="$up" mode="object.title.markup"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
            </h1>
        </div>
    </xsl:template>

    <xsl:template name="webhelptoc">
	    <xsl:param name="currentid"/>
        <xsl:choose>
            <xsl:when test="$rootid != ''">
                <xsl:variable name="title">
                    <xsl:if test="$eclipse.autolabel=1">
                        <xsl:variable name="label.markup">
                            <xsl:apply-templates select="key('id',$rootid)" mode="label.markup"/>
                        </xsl:variable>
                        <xsl:if test="normalize-space($label.markup)">
                            <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates select="key('id',$rootid)" mode="title.markup"/>
                </xsl:variable>
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="$manifest.in.base.dir != 0">
                            <xsl:call-template name="href.target">
                                <xsl:with-param name="object" select="key('id',$rootid)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href.target.with.base.dir">
                                <xsl:with-param name="object" select="key('id',$rootid)"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="title">
                    <xsl:if test="$eclipse.autolabel=1">
                        <xsl:variable name="label.markup">
                            <xsl:apply-templates select="/*" mode="label.markup"/>
                        </xsl:variable>
                        <xsl:if test="normalize-space($label.markup)">
                            <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates select="/*" mode="title.markup"/>
                </xsl:variable>
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="$manifest.in.base.dir != 0">
                            <xsl:call-template name="href.target">
                                <xsl:with-param name="object" select="/"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href.target.with.base.dir">
                                <xsl:with-param name="object" select="/"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <div>
                    <div id="leftnavigation" style="padding-top:3px;">
                        <div id="tabs">
                            <ul>
                                <li>
                                    <a href="#treeDiv">
                                        <em>
                                            <xsl:call-template name="gentext">
                                                <xsl:with-param name="key" select="'TableofContents'"/>
                                            </xsl:call-template>
                                        </em>
                                    </a>
                                </li>
                                <xsl:if test="$exclude.search.from.chunked.html != 'true'">
                                    <li>
                                        <a href="#searchDiv">
                                            <em>
                                                <xsl:call-template name="gentext">
                                                    <xsl:with-param name="key" select="'Search'"/>
                                                </xsl:call-template>
                                            </em>
                                        </a>
                                    </li>
                                </xsl:if>
                            </ul>
                            <div id="treeDiv">
                                <img src="../common/images/loading.gif" alt="loading table of contents..."
                                     id="tocLoading" style="display:block;"/>
                                <ul id="tree" class="filetree" style="display:none;">
                                    <xsl:apply-templates select="/*/*" mode="webhelptoc">
                                        <xsl:with-param name="currentid" select="$currentid"/>
                                    </xsl:apply-templates>
                                </ul>
                            </div>
                            <xsl:if test="$exclude.search.from.chunked.html != 'true'">
                                <div id="searchDiv">
                                    <div id="search">
                                        <form onsubmit="Verifie(ditaSearch_Form);return false"
                                              name="ditaSearch_Form"
                                              class="searchForm">
                                            <fieldset class="searchFieldSet">
                                                <legend>
                                                    <xsl:call-template name="gentext">
                                                        <xsl:with-param name="key" select="'Search'"/>
                                                    </xsl:call-template>
                                                </legend>
                                                <center>
                                                    <input id="textToSearch" name="textToSearch" type="text"
                                                           class="searchText"/>
                                                    <input onclick="Verifie(ditaSearch_Form)" type="button"
                                                           class="searchButton"
                                                           value="Go"/>
                                                </center>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <div id="searchResults">

                                    </div>
                                </div>
                            </xsl:if>

                        </div>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="book|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index"
            mode="webhelptoc">
	<xsl:param name="currentid"/>
        <xsl:variable name="title">
            <xsl:if test="$eclipse.autolabel=1">
                <xsl:variable name="label.markup">
                    <xsl:apply-templates select="." mode="label.markup"/>
                </xsl:variable>
                <xsl:if test="normalize-space($label.markup)">
                    <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="." mode="title.markup"/>
        </xsl:variable>

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$manifest.in.base.dir != 0">
                    <xsl:call-template name="href.target"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="href.target.with.base.dir"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="id" select="generate-id(.)"/>
        <!--xsl:message>
            <xsl: select="name(ancestor-or-self::*) "/>
        </xsl:message-->

        <xsl:if test="not(self::index) or (self::index and not($generate.index = 0))">
            <!--li style="white-space: pre; line-height: 0em;"-->
	  <li>
		<xsl:if test="$id = $currentid">
		  <xsl:attribute name="id">webhelp-currentid</xsl:attribute>
		</xsl:if>		
                <span class="file">
                    <a href="{substring-after($href,concat($frameset.base.dir,'/content/'))}">
                        <xsl:value-of select="$title"/>
                    </a>
                </span>
                <xsl:if test="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv">
                    <ul>
                        <xsl:apply-templates
                                select="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv"
                                mode="webhelptoc">
					<xsl:with-param name="currentid" select="$currentid"/>
			</xsl:apply-templates>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()" mode="webhelptoc"/>

    <xsl:template name="user.footer.content">
       <script type="text/javascript" src="../common/main.js">
           <xsl:comment></xsl:comment>
       </script> 
    </xsl:template>

    <xsl:template name="index.html">
        <xsl:variable name="default.topic">
          <xsl:choose>
            <xsl:when test="$htmlhelp.default.topic != ''">
              <xsl:value-of select="$htmlhelp.default.topic"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="make-relative-filename">
                <xsl:with-param name="base.dir"/>
                <xsl:with-param name="base.name">
                  <xsl:choose>
                    <xsl:when test="$rootid != ''">
                      <xsl:apply-templates select="key('id',$rootid)" mode="chunk-filename"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="*/*[self::preface|self::chapter|self::appendix|self::part][1]" mode="chunk-filename"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename">
            <!--       <xsl:if test="$manifest.in.base.dir != 0"> -->
            <!--         <xsl:value-of select="$base.dir"/> -->
            <!--       </xsl:if> -->
            <xsl:choose>
              <xsl:when test="$chunk.frameset.start.filename"><xsl:value-of select="concat($frameset.base.dir,'/',$chunk.frameset.start.filename)"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="'index.html'"/></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="method" select="'xml'"/>
          <xsl:with-param name="encoding" select="'utf-8'"/>
          <xsl:with-param name="indent" select="'yes'"/>
          <xsl:with-param name="content">
            <html>
            <head>
            <meta http-equiv="Refresh" content="0; URL=content/ch01.html"/>
            <title><xsl:value-of select="//title[1]"/>&#160;</title>
            <!-- Call template "metatags" to add copyright and date meta tags:  -->
            </head>
            </html>
          </xsl:with-param>
        </xsl:call-template>
  </xsl:template>


    <xsl:template name="web.xml">
        <xsl:call-template name="write.chunk">
            <xsl:with-param name="filename">
                <xsl:value-of select="concat($frameset.base.dir,'/web.xml')"/>
            </xsl:with-param>
            <xsl:with-param name="method" select="'xml'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="indent" select="'yes'"/>
            <xsl:with-param name="content">
                <web-app id="{$output_file_name}">

                    <display-name>
                        <xsl:value-of select="$output_file_name"/>
                    </display-name>

                    <welcome-file-list>
                        <!-- TODO: Parameterise this -->
                        <welcome-file>index.html</welcome-file>
                    </welcome-file-list>

                    <!-- 		  <security-constraint> -->

                    <!-- 			<web-resource-collection> -->
                    <!-- 			  <web-resource-name>All Pages</web-resource-name> -->
                    <!-- 			  <url-pattern>*.*</url-pattern> -->
                    <!-- 			  <http-method>POST</http-method> -->
                    <!-- 			  <http-method>GET</http-method> -->
                    <!-- 			</web-resource-collection> -->

                    <!-- 			<auth-constraint> -->
                    <!-- 			  <role-name>ReadTelemetry</role-name> -->
                    <!-- 			</auth-constraint> -->

                    <!-- 			<user-data-constraint> -->
                    <!-- 			  <transport-guarantee>NONE</transport-guarantee> -->
                    <!-- 			</user-data-constraint>	 -->

                    <!-- 		  </security-constraint> -->

                    <!-- 		  <login-config> -->
                    <!-- 			<auth-method>BASIC</auth-method> -->
                    <!-- 			<realm-name>Motive CSR Console</realm-name> -->
                    <!-- 		  </login-config> -->

                    <!-- 		  <security-role> -->
                    <!-- 			<role-name>ReadTelemetry</role-name> -->
                    <!-- 		  </security-role> -->

                </web-app>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet> 
