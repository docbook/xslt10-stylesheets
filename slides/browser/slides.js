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
    divs = document.getElementsByTagName("div");

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
    } else if (navigator.family == 'gecko') {
	kc = evt.keyCode;
	if(!kc) {
	    kc = evt.which;
	}
    } else {
	kc = evt.which;
    }

    // These do look like odd values, what was the story?
    //var forward = (kc == 34);	/* '"' ? */
    //var backward = (kc == 33); /* '!' */
    //var home = (kc == 36); /* '$' */
    //var toc = (kc == 112) || (kc == 224);

    var forward = (kc == 110) || (kc == 78) || (kc == 32)
	          || (kc == 10) || (kc == 13); /* n, N, SPACE, ENTER, RETURN */
    var backward = (kc == 112) || (kc == 80) || (kc == 8); /* p, P, BACKSPACE */
    var up = (kc == 117) || (kc == 85);	  /* u, U */
    var home = (kc == 104) || (kc == 72); /* h, H */
    var toc = (kc == 116) || (kc == 84);  /* t, T */

    var links = document.getElementsByTagName("link");

    var count = 0;
    var target = "";

    for (count = 0; count < links.length; count++) {
	if (home && (links[count].getAttribute("rel") == 'top')) {
	    target = links[count].getAttribute("href");
	}
	if (toc && (links[count].getAttribute("rel") == 'contents')) {
	    target = links[count].getAttribute("href");
	}
	if (up && (links[count].getAttribute("rel") == 'up')) {
	    target = links[count].getAttribute("href");
	}
	if (forward && (links[count].getAttribute("rel") == 'next')) {
	    target = links[count].getAttribute("href");
	}
	if (backward && (links[count].getAttribute("rel") == 'previous')) {
	    target = links[count].getAttribute("href");
	}
    }

    if (target != "") {
	if (window.top.frames[1]) {
	    window.top.frames[1].location = target;
	} else {
	    window.location = target;
	}
    }

    return false;
}

function toggletoc (img, width, hidegraphic, showgraphic) {
    var fsc = top.GetElementsByTagName('frameset');
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

