// -*- Java -*-
//
// $Id$
//
// Copyright (C) 2002 Norman Walsh
//
// You are free to use, modify and distribute this software without limitation.
// This software is provided "AS IS," without a warranty of any kind.
//
// This script assumes that the Netscape 'ua.js' module has also been loaded.

function newPage(filename, overlay) {
    divs = xbGetElementsByName("DIV");

    if (divs) {
	var xdiv = divs[0];

	if (xdiv) {
	    var xid = xdiv.getAttribute("id");

	    var mytoc = window.top.frames[0];
	    if (mytoc.lastUnderlined) {
		mytoc.lastUnderlined.style.textDecoration = "none";
	    }

	    var tdiv = xbGetElementById(xid, mytoc);

	    if (tdiv) {
		var ta = tdiv.getElementsByTagName("a").item(0);
		ta.style.textDecoration = "underline";
		mytoc.lastUnderlined = ta;
	    }
	}
    }

    if (overlay != 0) {
	overlaySetup('lc');
    }
}


function navigate (evt) {
    var kc = -1;

    if (navigator.org == 'microsoft') {
	kc = window.event.keyCode;
    } else {
	kc = evt.which;
    }

    var forward = (kc==32) || (kc==13) || (kc==110) || (kc==78);
    var backward = (kc==80) || (kc==112);

    var links = xbGetElementsByName("LINK");
    var count = 0;
    var target = "";

    for (count = 0; count < links.length; count++) {
	if (forward && (links[count].getAttribute("rel") == 'next')) {
	    target = links[count].getAttribute("href");
	}
	if (backward && (links[count].getAttribute("rel") == 'previous')) {
	    target = links[count].getAttribute("href");
	}
    }

    if (target != "") {
	window.location = target;
    }
}

function toggletoc (img, width, hidegraphic, showgraphic) {
    var fsc = xbGetElementsByName('FRAMESET',top);
    if (fsc) {
	var fs = fsc[0];
	if (fs) {
	    if (fs.cols == "0,*") {
		fs.cols = width + ",*";
		img.src = hidegraphic;
	    } else {
		fs.cols = "0,*";
		img.src = showgraphic;
	    }
	}
    }
}

