<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exsl="http://exslt.org/common"
        xmlns:ng="http://docbook.org/docbook-ng" 
        xmlns:db="http://docbook.org/ns/docbook"
        version="1.0" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:import href="../../xhtml/chunk.xsl"/>


    <xsl:output
            method="html"
            encoding="utf-8"
            cdata-section-elements=""/>

    <!-- webhelp-specific params! -->
    <!-- To be added to normal params file someday -->
    <xsl:param name="webhelp.include.search.tab">true</xsl:param>
    <xsl:param name="webhelp.start.filename">index.html</xsl:param>
    <xsl:param name="webhelp.base.dir">docs</xsl:param>
    <!-- webhelp.common.dir includes the files including jquery, css files
	 which are required for general functionality of webhelp -->
    <xsl:param name="webhelp.common.dir">../common/</xsl:param>
    <!-- webhelp.tree.cookie.id preserves the TOC tree. 
	i.e. opened tree/sub-tree nodes and closed tree nodes. 
	Needed for jquery.treeview plugin -->
    <xsl:param name="webhelp.tree.cookie.id" select="concat( 'treeview-', count(//node()) )"/>
    <!-- Specify the language of your docbook document. 
	This is needed for stemming support and to filter the subtle differences in the languages 
	'en' (english) is the default. Refer the NOTE: on stemmers given below for more info. -->
    <xsl:param name="webhelp.indexer.language">en</xsl:param>
    <xsl:param name="webhelp.default.topic"/>
    <xsl:param name="webhelp.autolabel">0</xsl:param>
    <!-- webhelp-specific params! -->

    <!-- Set some reasonable defaults for webhelp output -->
    <xsl:param name="chunker.output.indent">no</xsl:param>
    <xsl:param name="navig.showtitles">0</xsl:param>
    <xsl:param name="manifest.in.base.dir" select="0"/>
    <xsl:param name="base.dir" select="concat($webhelp.base.dir,'/content/')"/>
    <xsl:param name="suppress.navigation">0</xsl:param>
    <!-- Generate the end-of-the-book index -->
    <xsl:param name="generate.index" select="1"/>
    <xsl:param name="inherit.keywords" select="'0'"/>
    <xsl:param name="local.l10n.xml" select="document('')"/>
    <xsl:param name="para.propagates.style" select="1"/>
    <xsl:param name="phrase.propagates.style" select="1"/>
    <xsl:param name="chunk.first.sections" select="1"/>
    <xsl:param name="chapter.autolabel" select="1"/>
    <xsl:param name="section.autolabel" select="0"/>
    <!--xsl:param name="generate.toc">book toc</xsl:param-->

    <!-- Localizations of webhelp specific words. Your contributions for other languages are appreciated.
	Currently, only around 10 translations needed. -->
    <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
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
	    <l:gentext key="HighlightButton" text="Toggle search result highlighting"/>
	    <l:gentext key="Your_search_returned_no_results" text="Your search returned no results."/>
        </l10n>
	<!-- The fallback mechansim doesn't seem to work for local l10n stuff -->
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="ja">
            <l:gentext key="Search" text="検索"/>
            <l:gentext key="Enter_a_term_and_click" text="用語をクリックして入力してください。"/>
            <l:gentext key="Go" text="移動"/>
            <l:gentext key="to_perform_a_search" text=" to perform a search."/>
            <l:gentext key="txt_filesfound" text="検索結果"/>
            <l:gentext key="txt_enter_at_least_1_char" text="あなたは、少なくとも1つの文字を入力する必要があります。"/>
            <l:gentext key="txt_browser_not_supported"
                       text="お使いのブラウザがサポートされていません。 Mozilla Firefoxの使用が推奨されます"/>
            <l:gentext key="txt_please_wait" text="しばらくお待ちください。検索が進行中です..."/>
            <l:gentext key="txt_results_for" text="次の検索語の結果： "/>
	    <l:gentext key="HighlightButton" text="強調表示の切り替えの検索結果"/>
        </l10n>
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="de">
            <l:gentext key="Search" text="suchen"/>
            <l:gentext key="Enter_a_term_and_click" text="Geben Sie einen Begriff ein und klicken Sie "/>
            <l:gentext key="Go" text="Go"/>
            <l:gentext key="to_perform_a_search" text=" to perform a search."/>
            <l:gentext key="txt_filesfound" text="Ergebnisse"/>
            <l:gentext key="txt_enter_at_least_1_char" text="Sie müssen mindestens ein Zeichen."/>
            <l:gentext key="txt_browser_not_supported"
                       text="Your browser is not supported. Use of Mozilla Firefox is recommended."/>
            <l:gentext key="txt_please_wait" text="Bitte warten Sie. Die Suche ist im Gange ..."/>
            <l:gentext key="txt_results_for" text="Ergebnisse für: "/>
	    <l:gentext key="HighlightButton" text="Toggle search result highlighting"/>
        </l10n>
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="fr">
            <l:gentext key="Search" text="rechercher"/>
            <l:gentext key="Enter_a_term_and_click" text="Saisissez un terme et cliquer "/>
            <l:gentext key="Go" text="Go"/>
            <l:gentext key="to_perform_a_search" text=" to perform a search."/>
            <l:gentext key="txt_filesfound" text="résultats"/>
            <l:gentext key="txt_enter_at_least_1_char" text="Vous devez entrer au moins un caractère."/>
            <l:gentext key="txt_browser_not_supported"
                       text="Your browser is not supported. Use of Mozilla Firefox is recommended."/>
            <l:gentext key="txt_please_wait" text="S'il vous plaît attendre. La recherche est en cours ..."/>
            <l:gentext key="txt_results_for" text="Résultats pour: "/>
	    <l:gentext key="HighlightButton" text="Toggle search result highlighting"/>
        </l10n>
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="zh">
            <l:gentext key="Search" text="搜索"/>
            <l:gentext key="Enter_a_term_and_click" text="输入字词，然后点击 "/>
            <l:gentext key="Go" text="去"/>
            <l:gentext key="to_perform_a_search" text=" to perform a search."/>
            <l:gentext key="txt_filesfound" text="条结果"/>
            <l:gentext key="txt_enter_at_least_1_char" text="您必须输入至少一个字符。"/>
            <l:gentext key="txt_browser_not_supported"
                       text="Your browser is not supported. Use of Mozilla Firefox is recommended."/>
            <l:gentext key="txt_please_wait" text="请稍候。搜索中..."/>
            <l:gentext key="txt_results_for" text="结果： "/>
	    <l:gentext key="HighlightButton" text="Toggle search result highlighting"/>
        </l10n>
        <l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="cs">
            <l:gentext key="Search" text="Hledání"/>
            <l:gentext key="Enter_a_term_and_click" text="Zadejte pojem a klikněte "/>
            <l:gentext key="Go" text="Přejdi"/>
            <l:gentext key="to_perform_a_search" text=" pro hledání."/>
            <l:gentext key="txt_filesfound" text="Výsledky"/>
            <l:gentext key="txt_enter_at_least_1_char" text="Musíte zadat alespoň jeden znak."/>
            <l:gentext key="txt_browser_not_supported"
                       text="Váš prohlížeč není podporován. Použití prohlížeče Mozilla Firefox je doporučeno."/>
            <l:gentext key="txt_please_wait" text="Prosím čekejte. Probíhá hledání..."/>
            <l:gentext key="txt_results_for" text="Výsledky pro: "/>
            <l:gentext key="TableofContents" text="Obsah"/>
           <l:gentext key="HighlightButton" text="Přepnout zvýrazňování výsledků hledání"/>
        </l10n>
    </i18n>

  <xsl:template name="system.head.content">
  <xsl:param name="node" select="."/>
<xsl:text>
</xsl:text>
<!-- 
This avoids two problems in IE 8. We should someday figure out why this is happening and tweak the JavaScript so this <meta/> tag is not necessary:
1. When you perform a search and click the Toggle Highlight button, IE 8 adds a line break before the highlighted word.
2. If you click the show/hide toc button, the tab crashes.
These problems go away when you add this IE=7 mode meta tag.
 -->
	<meta http-equiv="X-UA-Compatible" content="IE=7" />
<xsl:text>
</xsl:text>
  </xsl:template>

    <!-- HTML <head> section customizations -->	
    <xsl:template name="user.head.content">
  	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <!--  <xsl:message>
            webhelp.tree.cookie.id = <xsl:value-of select="$webhelp.tree.cookie.id"/> +++ <xsl:value-of select="count(//node())"/>
            $webhelp.indexer.language = <xsl:value-of select="$webhelp.indexer.language"/> +++ <xsl:value-of select="count(//node())"/>
        </xsl:message>-->
        <script type="text/javascript">
            //The id for tree cookie
            var treeCookieId = "<xsl:value-of select="$webhelp.tree.cookie.id"/>";
            var language = "<xsl:value-of select="$webhelp.indexer.language"/>";
            var w = new Object();
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

	<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon"/>
        <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}css/positioning.css"/>
        <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}jquery/theme-redmond/jquery-ui-1.8.2.custom.css"/>
        <link rel="stylesheet" type="text/css" href="{$webhelp.common.dir}jquery/treeview/jquery.treeview.css"/>

        <style type="text/css">
input {
    margin-bottom: 5px;
    margin-top: 2px;
}
.folder {
    display: block;
    height: 22px;
    padding-left: 20px;
    background: transparent url(<xsl:value-of select="$webhelp.common.dir"/>jquery/treeview/images/folder.gif) 0 0px no-repeat;
}
span.contentsTab {
    padding-left: 20px;
    background: url(<xsl:value-of select="$webhelp.common.dir"/>images/toc-icon.png) no-repeat 0 center;
}
span.searchTab {
    padding-left: 20px;
    background: url(<xsl:value-of select="$webhelp.common.dir"/>images/search-icon.png) no-repeat 0 center;
}

/* Overide jquery treeview's defaults for ul. */
.treeview ul {
    background-color: transparent;
    margin-top: 4px;
}		
#webhelp-currentid {
    background-color: #D8D8D8 !important;
}
.treeview .hover { color: black; }
.filetree li span a { text-decoration: none; font-size: 12px; color: #517291; }

/* Override jquery-ui's default css customizations. These are supposed to take precedence over those.*/
.ui-widget-content {
    border: 0px; 
    background: none; 
    color: none;     
}
.ui-widget-header {
    color: #e9e8e9;
    border-left: 1px solid #e5e5e5;
    border-right: 1px solid #e5e5e5;
    border-bottom: 1px solid #bbc4c5;
    border-top: 4px solid #e5e5e5;
    background: #F4F4F4; /* old browsers */
    background: -moz-linear-gradient(top, #F4F4F4 0%, #E6E4E5 100%); /* firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#F4F4F4), color-stop(100%,#E6E4E5)); /* webkit */    
    font-weight: none;
}
.ui-widget-header a { color: none; }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { 
border: none; background: none; font-weight: none; color: none; }
.ui-state-default a, .ui-state-default a:link, .ui-state-default a:visited { color: black; text-decoration: none; }
.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus { border: none; background: none; font-weight: none; color: none; }

.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active { border: none; background: none; font-weight: none; color: none; }
.ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited { 
    color: black; text-decoration: none; 	
    background: #C6C6C6; /* old browsers */
    background: -moz-linear-gradient(top, #C6C6C6 0%, #D8D8D8 100%); /* firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#C6C6C6), color-stop(100%,#D8D8D8)); /* webkit */
    -webkit-border-radius:15px; -moz-border-radius:10px;
    border: 1px solid #f1f1f1;
}    
.ui-corner-all { border-radius: 0 0 0 0; }

.ui-tabs { padding: .2em;}
.ui-tabs .ui-tabs-nav li { top: 0px; margin: -2px 0 1px; text-transform: uppercase; font-size: 10.5px;}
.ui-tabs .ui-tabs-nav li a { padding: .25em 2em .25em 1em; margin: .5em; text-shadow: 0 1px 0 rgba(255,255,255,.5); }
        </style>

	<!-- 
	     browserDetect is an Oxygen addition to warn the user if they're using chrome from the file system.
	     This breaks the Oxygen search highlighting.
	-->
	<script type="text/javascript" src="{$webhelp.common.dir}browserDetect.js">
            <xsl:comment> </xsl:comment>
	</script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery-1.4.2.min.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery-ui-1.8.2.custom.min.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery.cookie.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/treeview/jquery.treeview.min.js">
            <xsl:comment> </xsl:comment>
        </script>

	<xsl:if test="$webhelp.include.search.tab = 'true'">
	  <!--Scripts/css stylesheets for Search-->
	  <!-- TODO: Why THREE files? There's absolutely no need for having separate files. 
		These should have been identified at the optimization phase! --> 
	  <script type="text/javascript" src="search/l10n.js">
	    <xsl:comment></xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/htmlFileList.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/htmlFileInfoList.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/nwSearchFnt.js">
	      <xsl:comment> </xsl:comment>
	  </script>

	  <!--
	     NOTE: Stemmer javascript files should be in format <language>_stemmer.js.
	     For example, for English(en), source should be: "search/stemmers/en_stemmer.js"
	     For country codes, see: http://www.uspto.gov/patft/help/helpctry.htm
	  -->
	  <!--<xsl:message><xsl:value-of select="concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')"/></xsl:message>-->
	  <script type="text/javascript" src="{concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')}">
	      <xsl:comment>//make this scalable to other languages as well.</xsl:comment>
	  </script>

	  <!--Index Files:
	      Index is broken in to three equal sized(number of index items) files. This is to help parallel downloading
	      of files to make it faster.
		TODO: Generate webhelp index for largest docbook document that can be find, and analyze the file sizes.
		IF the file size is still around ~50KB for a given file, we should consider merging these files together. again.     	
	  -->
	  <script type="text/javascript" src="search/index-1.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/index-2.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/index-3.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <!--End of index files -->
	</xsl:if>
	<xsl:call-template name="user.webhelp.head.content"/>
    </xsl:template>

    <!-- This is for the USERS. Users who want to customize webhelp may over-ride this template to add content to <head>. -->
    <xsl:template name="user.webhelp.head.content"/>

    <xsl:template name="user.header.navigation">
        <xsl:param name="prev"/>
        <xsl:param name="next"/>
        <xsl:param name="nav.context"/>
        <xsl:call-template name="webhelpheader">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
            <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>
        <!--xsl:call-template name="webhelptoc"/-->

        <!--testing toc in the content page>
        <xsl:call-template name="webhelptoctoc"/>
        <xsl:if test="$webhelp.include.search.tab != 'false'">
            <xsl:call-template name="search"/>
        </xsl:if-->
    </xsl:template>

    <xsl:template name="user.header.content">
        <xsl:comment> <!-- KEEP this code. --> </xsl:comment>
    </xsl:template>

    <xsl:template name="user.footer.navigation">
    	<xsl:call-template name="webhelptoc">
		  <xsl:with-param name="currentid" select="generate-id(.)"/>
	     </xsl:call-template>
    </xsl:template>

  <xsl:template match="/">
	<xsl:message>language: <xsl:value-of select="$webhelp.indexer.language"/> </xsl:message>
	<!-- * Get a title for current doc so that we let the user -->
	<!-- * know what document we are processing at this point. -->
	<xsl:variable name="doc.title">
	  <xsl:call-template name="get.doc.title"/>
	</xsl:variable>
	<xsl:choose>
	  <!-- Hack! If someone hands us a DocBook V5.x or DocBook NG document,
	  toss the namespace and continue.  Use the docbook5 namespaced
	  stylesheets for DocBook5 if you don't want to use this feature.-->
	  <!-- include extra test for Xalan quirk -->
	  <xsl:when test="$exsl.node.set.available != 0                     and (*/self::ng:* or */self::db:*)">
		<xsl:call-template name="log.message">
		  <xsl:with-param name="level">Note</xsl:with-param>
		  <xsl:with-param name="source" select="$doc.title"/>
		  <xsl:with-param name="context-desc">
			<xsl:text>namesp. cut</xsl:text>
		  </xsl:with-param>
		  <xsl:with-param name="message">
			<xsl:text>stripped namespace before processing</xsl:text>
		  </xsl:with-param>
		</xsl:call-template>
		<xsl:variable name="nons">
        <xsl:apply-templates mode="stripNS"/>
      </xsl:variable>
		<!--
		<xsl:message>Saving stripped document.</xsl:message>
		<xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="'/tmp/stripped.xml'"/>
        <xsl:with-param name="method" select="'xml'"/>
        <xsl:with-param name="content">
		<xsl:copy-of select="exsl:node-set($nons)"/>
	  </xsl:with-param>
      </xsl:call-template>
		-->
		<xsl:call-template name="log.message">
		  <xsl:with-param name="level">Note</xsl:with-param>
		  <xsl:with-param name="source" select="$doc.title"/>
		  <xsl:with-param name="context-desc">
			<xsl:text>namesp. cut</xsl:text>
		  </xsl:with-param>
		  <xsl:with-param name="message">
			<xsl:text>processing stripped document</xsl:text>
		  </xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="exsl:node-set($nons)"/>
	  </xsl:when>
	  <!-- Can't process unless namespace removed -->
	  <xsl:when test="*/self::ng:* or */self::db:*">
		<xsl:message terminate="yes">
		  <xsl:text>Unable to strip the namespace from DB5 document,</xsl:text>
		  <xsl:text> cannot proceed.</xsl:text>
		</xsl:message>
	  </xsl:when>
	  <xsl:otherwise>
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
				<xsl:if test="$collect.xref.targets = 'yes' or                             $collect.xref.targets = 'only'">
				  <xsl:apply-templates select="key('id', $rootid)" mode="collect.targets"/>
				</xsl:if>
				<xsl:if test="$collect.xref.targets != 'only'">
				  <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
				  <xsl:if test="$tex.math.in.alt != ''">
					<xsl:apply-templates select="key('id',$rootid)" mode="collect.tex.math"/>
                                  </xsl:if>
				</xsl:if>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:if test="$collect.xref.targets = 'yes' or                         $collect.xref.targets = 'only'">
			  <xsl:apply-templates select="/" mode="collect.targets"/>
			</xsl:if>
			<xsl:if test="$collect.xref.targets != 'only'">
			  <xsl:apply-templates select="/" mode="process.root"/>
			  <xsl:if test="$tex.math.in.alt != ''">
              <xsl:apply-templates select="/" mode="collect.tex.math"/>
            </xsl:if>
          </xsl:if>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
	
	<xsl:call-template name="index.html"/>

	<xsl:call-template name="l10n.js"/>
    </xsl:template>


    <!-- The WebHelp output structure. similar to main() method.
	basic format:
	<html>
		<head> calls-appropriate-template </head>
		<body> 
   		       some-generic-content
		       <div id="content"> 
		       		All your docbook document content goes here
				....
		       </div>
		       some-other-generic-content-at-footer		
		</body>
	</html>
    -->	
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

                <xsl:call-template name="user.header.navigation">
                    <xsl:with-param name="prev" select="$prev"/>
                    <xsl:with-param name="next" select="$next"/>
                    <xsl:with-param name="nav.context" select="$nav.context"/>
                </xsl:call-template>

                <div id="content">

                    <xsl:call-template name="user.header.content"/>

                    <xsl:copy-of select="$content"/>

                    <xsl:call-template name="user.footer.content"/>

					<hr/>
					<div class="legal"><a href="index.html">Legal notices</a></div>

					<!-- Redundant since the upper navigation bar always visible -->
                    <!--xsl:call-template name="footer.navigation">
                        <xsl:with-param name="prev" select="$prev"/>
                        <xsl:with-param name="next" select="$next"/>
                        <xsl:with-param name="nav.context" select="$nav.context"/>
                    </xsl:call-template-->

		    <xsl:call-template name="user.webhelp.content.footer"/>
                </div>

                <xsl:call-template name="user.footer.navigation"/>
            </body>
        </html>
        <xsl:value-of select="$chunk.append"/>
    </xsl:template>

    <!-- This is for the USERS. Users who want to customize webhelp may over-ride this template to add content to the footer of the content DIV. 
  	 i.e. within <div id="content"> ... </div> -->
    <xsl:template name="user.webhelp.content.footer"/>

    <!-- The Header with the company logo -->
    <xsl:template name="webhelpheader">
        <xsl:param name="prev"/>
        <xsl:param name="next"/>
        <xsl:param name="nav.context"/>

        <xsl:variable name="home" select="/*[1]"/>
        <xsl:variable name="up" select="parent::*"/>

        <div id="header">
	    <!--xsl:call-template name="webhelpheader.logo"/-->
		<img style='margin-right: 2px; height: 59px; padding-right: 25px; padding-top: 8px' align="right"
		   src='{$webhelp.common.dir}images/logo.png' alt="Company Logo"/>
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

            <!-- Prev and Next links generation-->
            <div id="navheader" align="right">
                <xsl:comment>
                    <!-- KEEP this code. In case of neither prev nor next links are available, this will help to
                        keep the integrity of the DOM tree-->
                </xsl:comment>
                <!--xsl:with-param name="prev" select="$prev"/>
                <xsl:with-param name="next" select="$next"/>
                <xsl:with-param name="nav.context" select="$nav.context"/-->
                <table class="navLinks">
                    <tr>
                        <td>
                            <a id="showHideButton" onclick="showHideToc();"
                                class="pointLeft" title="Hide TOC tree">Sidebar
                            </a>
                        </td>
                        <td>
			  <!--xsl:if test="$webhelp.include.search.tab = 'true'">
                            <img src="{$webhelp.common.dir}images/highlight-blue.gif" alt="H" height="25px"
                                 onclick="toggleHighlight()" id="showHideHighlight" style="cursor:pointer">
				<xsl:attribute name="title">
				  <xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'HighlightButton'"/>
				  </xsl:call-template>				  
				</xsl:attribute>
			    </img>
			  </xsl:if-->
                        </td>
                        <xsl:if test="count($prev) &gt; 0
                            or (count($up) &gt; 0
                            and generate-id($up) != generate-id($home)
                            and $navig.showtitles != 0)
                            or count($next) &gt; 0">
                            <td>
                                <xsl:if test="count($prev)>0">
                                    <a accesskey="p" class="navLinkPrevious" tabindex="5">
                                        <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object" select="$prev"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:call-template name="navig.content">
                                            <xsl:with-param name="direction" select="'prev'"/>
                                        </xsl:call-template>
                                    </a>
                                </xsl:if>

                                <!-- "Up" link-->
                                <xsl:choose>
                                    <xsl:when test="count($up)&gt;0
                                              and generate-id($up) != generate-id($home)">
                                        |
                                        <a accesskey="u" class="navLinkUp" tabindex="5">
                                            <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object" select="$up"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:call-template name="navig.content">
                                                <xsl:with-param name="direction" select="'up'"/>
                                            </xsl:call-template>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>&#160;</xsl:otherwise>
                                </xsl:choose>
                                
                                <xsl:if test="count($next)>0">
                                    |
                                    <a accesskey="n" class="navLinkNext" tabindex="5">
                                        <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object" select="$next"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:call-template name="navig.content">
                                            <xsl:with-param name="direction" select="'next'"/>
                                        </xsl:call-template>
                                    </a>
                                </xsl:if>
                            </td>
                        </xsl:if>
                    </tr>
                </table>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="webhelpheader.logo">
      <img style='margin-right: 2px; height: 59px; padding-right: 25px; padding-top: 8px' align="right"
	   src='{$webhelp.common.dir}images/logo.png' alt="Company Logo"/>
    </xsl:template>

    <xsl:template name="webhelptoc">
        <xsl:param name="currentid"/>
        <xsl:choose>
            <xsl:when test="$rootid != ''">
                <xsl:variable name="title">
                    <xsl:if test="$webhelp.autolabel=1">
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
                    <xsl:if test="$webhelp.autolabel=1">
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
                    <div id="leftnavigation" style="padding-top:3px; background-color:white;">
                        <div id="tabs">
                            <ul>
                                <li>
                                    <a href="#treeDiv" tabindex="1">
                                        <span class="contentsTab">
                                            <xsl:call-template name="gentext">
                                                <xsl:with-param name="key" select="'TableofContents'"/>
                                            </xsl:call-template>
                                        </span>
                                    </a>
                                </li>
                                <xsl:if test="$webhelp.include.search.tab != 'false'">
                                    <li>
                                        <a href="#searchDiv" tabindex="1">
                                            <span class="searchTab">
                                                <xsl:call-template name="gentext">
                                                    <xsl:with-param name="key" select="'Search'"/>
                                                </xsl:call-template>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:if>
				<xsl:call-template name="user.webhelp.tabs.title"/>
                            </ul>
                            <div id="treeDiv">
                                <img src="{$webhelp.common.dir}images/loading.gif" alt="loading table of contents..."
                                     id="tocLoading" style="display:block;"/>
                                <div id="ulTreeDiv" style="display:none">
                                    <ul id="tree" class="filetree">
                                        <xsl:apply-templates select="/*/*" mode="webhelptoc">
                                            <xsl:with-param name="currentid" select="$currentid"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </div>

                            </div>
                            <xsl:if test="$webhelp.include.search.tab != 'false'">
                                <div id="searchDiv">
                                    <div id="search">
                                        <form onsubmit="Verifie(searchForm);return false"
                                              name="searchForm"
                                              class="searchForm">
                                            <fieldset class="searchFieldSet">
                                                <legend>
                                                    <xsl:call-template name="gentext">
                                                        <xsl:with-param name="key" select="'Search'"/>
                                                    </xsl:call-template>
                                                </legend>
                                                <center>
                                                    <input id="textToSearch" name="textToSearch" type="text"
                                                           class="searchText" tabindex="1"/>
                                                    <xsl:text disable-output-escaping="yes"> <![CDATA[&nbsp;]]> </xsl:text>
                                                    <input onclick="Verifie(searchForm)" type="button"
                                                           class="searchButton"
                                                           value="Go" id="doSearch" tabindex="1"/>
                                                </center>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <div id="searchResults">
                                           <center> </center>
                                    </div>
                                    <p class="searchHighlight"><a href="#" onclick="toggleHighlight()">Search Highlighter (On/Off)</a></p>
                                </div>
                            </xsl:if>
			    <xsl:call-template name="user.webhelp.tabs.content"/>
                        </div>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Hooks for adding customs tabs -->
    <xsl:template name="user.webhelp.tabs.title"/>
    <xsl:template name="user.webhelp.tabs.content"/>

    <!-- Generates the webhelp table-of-contents (TOC). -->
    <xsl:template
            match="book|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index"
            mode="webhelptoc">
        <xsl:param name="currentid"/>
        <xsl:variable name="title">
            <xsl:if test="$webhelp.autolabel=1">
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

        <xsl:if test="not(self::index) or (self::index and not($generate.index = 0))">
            <!--li style="white-space: pre; line-height: 0em;"-->
            <li>
                <xsl:if test="$id = $currentid">
                    <xsl:attribute name="id">webhelp-currentid</xsl:attribute>
                </xsl:if>
                <span class="file">
                    <a href="{substring-after($href, $base.dir)}"  tabindex="1">
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
        <script type="text/javascript" src="{$webhelp.common.dir}main.js">
            <xsl:comment></xsl:comment>
        </script>
    </xsl:template>
 
    <!-- Generates index.html file at docs/. This is simply a redirection to content/$default.topic -->	
    <xsl:template name="index.html">
        <xsl:variable name="default.topic">
            <xsl:choose>
                <xsl:when test="$webhelp.default.topic != ''">
                    <xsl:value-of select="$webhelp.default.topic"/>
                </xsl:when>
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
                                    <xsl:apply-templates
                                            select="*/*[self::preface|self::chapter|self::appendix|self::part][1]"
                                            mode="chunk-filename"/>
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
                    <xsl:when test="$webhelp.start.filename">
                        <xsl:value-of select="concat($webhelp.base.dir,'/',$webhelp.start.filename)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'index.html'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="method" select="'xml'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="indent" select="'yes'"/>
            <xsl:with-param name="content">
                <html>
                    <head>
		      <link rel="shortcut icon" href="favicon.ico"/>
		      <meta http-equiv="Refresh" content="1; URL=content/{$default.topic}"/>
		      <title><xsl:value-of select="//title[1]"/>&#160;
		      </title>
                    </head>
                    <body>
		      If not automatically redirected, click <a href="content/{$default.topic}">content/<xsl:value-of select="$default.topic"/></a>
                    </body>
                </html>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="l10n.js">
        <xsl:call-template name="write.chunk">
            <xsl:with-param name="filename">
	      <xsl:value-of select="concat($base.dir,'search/l10n.js')"/>
            </xsl:with-param>
            <xsl:with-param name="method" select="'text'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="indent" select="'no'"/>
            <xsl:with-param name="content">
	      //Resource strings for localization
	      var localeresource = new Object;
	      localeresource["search_no_results"]="<xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'Your_search_returned_no_results'"/>
                </xsl:call-template>";
            </xsl:with-param>
        </xsl:call-template>    
    </xsl:template>

</xsl:stylesheet> 
