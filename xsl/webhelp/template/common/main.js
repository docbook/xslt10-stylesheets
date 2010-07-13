/**
 * main.js
 *
 * Developed by: Kasun Gajasinghe, David Cramer
 *
 */

$(document).ready(function() {

    //Generate tabs in nav-pane with JQuery
    $(function() {
            $("#tabs").tabs({
                cookie: {
                    // store cookie for 2 days.
                    expires: 2
                }
            });
        });

    //Generate the tree
    $("#tree").treeview({
        collapsed: true,
        animated: "medium",
        control: "#sidetreecontrol",
        persist: "cookie"
    });

    //after toc fully styled, display it. Until loading, a 'loading' image will be displayed
    $("#tocLoading").attr("style","display:none;");
    $("#tree").attr("style","display:block;"); 

    //.searchButton is the css class applied to 'Go' button 
    $(function() {
		$("button", ".searchButton").button();

		$("button", ".searchButton").click(function() { return false; });
	});

    //'ui-tabs-1' is the cookie name which is used for the persistence of the tabs.(Content/Search tab)
    if ($.cookie('ui-tabs-1') === '1') { 
        if ($.cookie('textToSearch') != undefined && $.cookie('textToSearch').length > 0) {
            document.getElementById('textToSearch').value = $.cookie('textToSearch');
            Verifie('diaSearch_Form');
        }
    } 

    syncToc(); //Synchronize the toc tree with the content pane, when loading the page.
    $("#doSearch").button(); //add jquery button styling to 'Go' button
});

/**
 * Synchronize with the tableOfContents 
 */
function syncToc(){
    var a = document.getElementById("webhelp-currentid");
    if (a != undefined) {
        var b = a.getElementsByTagName("a")[0];

        if (b != undefined) {
            //Setting the background for selected node.
            var style = a.getAttribute("style");
            if (style != null && !style.match(/background-color: Background;/)) {
                a.setAttribute("style", "background-color: #6495ed;  " + style);
                b.setAttribute("style", "color: white;");
            } else if (style != null) {
                a.setAttribute("style", "background-color: #6495ed;  " + style);
                b.setAttribute("style", "color: white;");
            } else {
                a.setAttribute("style", "background-color: #6495ed;  ");
                b.setAttribute("style", "color: white;");
            }
        }

        //shows the node related to current content.
        //goes a recursive call from current node to ancestor nodes, displaying all of them.
        while (a.parentNode && a.parentNode.nodeName) {
            var parentNode = a.parentNode;
            var nodeName = parentNode.nodeName;

            if (nodeName.toLowerCase() == "ul") {
                parentNode.setAttribute("style", "display: block;");
            } else if (nodeName.toLocaleLowerCase() == "li") {
                parentNode.setAttribute("class", "collapsable");
                parentNode.firstChild.setAttribute("class", "hitarea collapsable-hitarea ");
            }
            a = parentNode;
        }
    }
}

/**
 * Code for Show/Hide TOC
 *
 */
function showHideToc() {
    var showHideButton = $("#showHideButton");
    var leftNavigation = $("#leftnavigation");
    var content = $("#content");

    if (showHideButton != undefined && showHideButton.hasClass("pointLeft")) {
        //Hide TOC
        showHideButton.removeClass('pointLeft').addClass('pointRight');
        content.css("margin", "0 0 0 0");
        leftNavigation.css("display","none");
        showHideButton.attr("title", "Hide the TOC tree");
    } else {
        //Show the TOC
        showHideButton.removeClass('pointRight').addClass('pointLeft');
        content.css("margin", "0 0 0 240px");
        leftNavigation.css("display","block");
        showHideButton.attr("title", "Show the TOC Tree");
    }
}