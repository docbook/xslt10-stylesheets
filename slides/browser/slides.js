// -*- Java -*-

function selectBrowser() {
    var browserName = navigator.appName;
    var browserVersion = parseFloat(navigator.appVersion);
    var userAgent = navigator.userAgent;;

    if (browserName == "Netscape" && browserVersion>=5) {
	// Netscape 6 is Mozilla 5
	return "ns6";
    }

    if (browserName == "Netscape" && browserVersion>=4) {
	return "ns4";
    }

    if (browserName == "Microsoft Internet Explorer"
	&& userAgent.indexOf("MSIE 6") > 0) {
	return "ie6";
    }

    if (browserName == "Microsoft Internet Explorer"
	&& userAgent.indexOf("MSIE 5") > 0) {
	return "ie5";
    }

    return null;
}

function newPage(filename,overlay) {
    if (selectBrowser() != "ie5"
	&& selectBrowser() != "ie6") {
	return;
    }

    if (overlay != 0) {
	overlaySetup('ll');
    }

    var parent = self.parent;

    var gparent = null;
    if (parent != null) {
	gparent = parent.parent;
    }

    var filemap = null;
    if (gparent != null) {
	filemap = gparent.filemap;
    }

    if (filename == "toc.html") {
	if (filemap == null) {
	    walk_toc();
	}
    } else {
	if (filemap != null) {
	    var id = filemap[filename];
	    if (id != null) {
		highlight_toc(id);
	    }
	}
    }
}

function navigate (bk,fw,overlay) {
    var frame = window;
    if (frame.name != "foil") {
	frame = frame.parent;
    }
    if (frame.name != "foil") {
	frame = frame.parent;
    }

    kc=event.keyCode;
    // [space] or [Enter] or [n] or [N] for next slide
    if (((kc==32)||(kc==13)||(kc==110)||(kc==78)) && (fw != "")) {
	frame.location=fw;
    }

    // [P] or [p] for previous slide
    if (((kc==80)||(kc==112)) && (bk != "")) {
	frame.location=bk;
    }
}

function walk_toc() {
    var doc = self.document;
    var filemap = new Array();
    var fileidx = new Array();
    var filermap = new Array();
    var fileridx = new Array();
    var idx = 0;
    var sectmap = new Array();
    var section = "";
    var title = "";

    var parent = self.parent;
    var gparent = null;
    if (parent != null) {
	gparent = parent.parent;
    }

    for (var i = 0; i < doc.all.length-2; i++) {
	var div_elem = doc.all.item(i);
	var img_elem = doc.all.item(i+1);
	var a_elem   = doc.all.item(i+2);

	if (img_elem.tagName == "A") {
	    a_elem = img_elem;
	}

	if (div_elem.tagName == "DIV"
	    && a_elem.tagName == "A") {
	    var id   = div_elem.getAttribute("ID");
	    var file = a_elem.getAttribute("HREF");
	    var pos  = file.lastIndexOf("/");
	    if (pos > 0) {
		file = file.substring(pos+1);
	    }

	    //	    if (div_elem.className == "toc-section") {
	    //		section = a_elem.innerText;
	    //	    }

	    if (div_elem.className == "toc-slidesinfo") {
		title = a_elem.innerText;
	    }

	    if (id != "") {
		fileidx[idx] = file;
		fileridx[file] = idx;
		idx++;
		filemap[file] = id;
		filermap[id] = file;
		sectmap[file] = section;
	    }
	}
    }

    // Squirrel this away on the top frame
    if (gparent != null) {
	gparent.prestitle = title;
	gparent.filemap = filemap;
	gparent.filermap = filermap;
	gparent.fileidx = fileidx;
	gparent.fileridx = fileridx;
	gparent.sectmap = sectmap;
    } else {
	alert("Unexpected frame context in slides.js");
    }
}

function highlight_toc(id) {
    var frame = window.parent.parent.frames("toc");
    var doc   = frame.document;
    var div   = null;

    // find the div
    for (var i = 0; i < doc.all.length; i++) {
	if (doc.all.item(i).tagName == "DIV") {
	    if (doc.all.item(i).getAttribute("ID") == id) {
		div = doc.all.item(i);
		break;
	    }
	}
    }

    var a = div.children(0);
    if (a != null && a.tagName != "A") {
	a = div.children(1);
    }

    if (a != null && a.tagName == "A") {
	if (frame.lastA != null) {
	    frame.lastA.style.textDecorationUnderline = false;
	}
	a.style.textDecorationUnderline = true;
	frame.lastA = a;
    }
}

function write_nav(id) {
    var frame = window.parent.frames("navbar");
    var doc   = frame.document;

    if (id == null) {
	id = self.parent.filemap[self.parent.fileidx[0]];
    }

    var file  = self.parent.filermap[id];
    var num   = self.parent.fileridx[file];
    var prev  = null;
    var next  = null;

    if (num > 0) {
	prev = self.parent.fileidx[num-1];
    }

    if (num < self.parent.fileidx.length) {
	next = self.parent.fileidx[num+1];
    }

    doc.open();
    doc.close();
    doc.write("<html><head>\n");
    doc.write("<link type='text/css' rel='stylesheet' href='slides.css'>\n");
    doc.write("<title>nav frame</title>\n");
    doc.write("</head><body bgcolor='#8399B1'>\n");
    doc.write("<table width='100%' border=0 cellpadding=0 cellspacing=0>\n");
    doc.write("<tr>\n");
    doc.write("<td align=left valign=center width='33%'>");
    if (prev != null) {
	doc.write("<a href='" + prev + "' target='foil'>");
	doc.write("<img src='../graphics/left.png' border='0'>");
	doc.write("</a>");
    } else {
	doc.write("&nbsp;");
    }
    doc.write("</td>\n");
    doc.write("<td align=center valign=bottom width='34%'>");
    if (num > 0) {
	doc.write("<span class='navfooter'>Slide " + num + "</span>");
    } else {
	doc.write("&nbsp;");
    }
    doc.write("</td>\n");
    doc.write("<td align=right valign=center width='33%'>");
    if (next) {
	doc.write("<a href='" + next + "' target='foil'>");
	doc.write("<img src='../graphics/right.png' border='0'>");
	doc.write("</a>");
    } else {
	doc.write("&nbsp;");
    }
    doc.write("</td>\n");
    doc.write("</tr>\n");
    doc.write("</table>\n");
    doc.close();
}

function write_header(file) {
    var frame = window.parent.frames("header");
    var doc   = frame.document;
    var title = self.parent.prestitle;
    var section  = self.parent.sectmap[file];

    var bgcolor = "#8399B1";
    var header = title + ": " + section;

    if (file == 'titlefoil.html') {
      header = "";
    }

    doc.open();
    doc.close();
    doc.write("<html><head>\n");
    doc.write("<link type='text/css' rel='stylesheet' href='slides.css'>\n");
    doc.write("<title>header frame</title>\n");
    doc.write("</head><body bgcolor='" + bgcolor + "'>\n");
    doc.write("<table width='100%' border=0 cellpadding=0 cellspacing=0>\n");
    doc.write("<tr>\n");
    doc.write("<td align=center valign=center width='100%'>");
    doc.write("<span class=navheader>" + header + "</span>");
    doc.write("</td>\n");
    doc.write("</tr>\n");
    doc.write("</table>\n");
    doc.close();
}

