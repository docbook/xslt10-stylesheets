/* Overlay.js, adapted from Floating image II on dynamicdrive.com */
/* Usage:
<html>
<head>
<script LANGUAGE="JavaScript1.2" src="overlay.js"></script>
...rest of head...
</head>
<body onload="overlaySetup(corner)">
<div id="overlayDiv" STYLE="position:absolute;visibility:visible;">
...body of overlay...
</div>
...rest of page...
*/

var overlayLx = 0;
var overlayLy = 0;

var overlayNS4 = document.layers ? 1 : 0;
var overlayIE  = document.all ? 1 : 0;
var overlayNS6 = document.getElementById && !document.all ? 1 : 0;

var overlayX = 0;
var overlayY = 0;
var overlayW = 0;
var overlayH = 0;
var overlayPadX = 15;
var overlayPadY = 5;

var overlayDelay=60;

var overlayCorner = 'ur'; // ul, ll, ur, lr, uc, lc, cl, cr

function overlayRefresh() {
    if (overlayIE) {
	overlayLx = document.body.clientWidth;
	overlayLy = document.body.clientHeight;
	overlayH  = overlayDiv.offsetHeight;
	overlayW  = overlayDiv.offsetWidth;
    } else if (overlayNS4) {
	overlayLy = window.innerHeight;
	overlayLx = window.innerWidth;
	overlayH  = document.overlayDiv.clip.height;
	overlayW  = document.overlayDiv.clip.width;
    } else if (overlayNS6) {
	overlayLy = window.innerHeight;
	overlayLx = window.innerWidth;
	overlayH  = document.getElementById('overlayDiv').offsetHeight;
	overlayW  = document.getElementById('overlayDiv').offsetWidth;
    }

    if (overlayCorner == 'ul') {
	overlayX = overlayPadX;
	overlayY = overlayPadY;
    } else if (overlayCorner == 'cl') {
	overlayX = overlayPadX;
	overlayY = (overlayLy - overlayH) / 2;
    } else if (overlayCorner == 'll') {
	overlayX = overlayPadX;
	overlayY = (overlayLy - overlayH) - overlayPadY;
    } else if (overlayCorner == 'ur') {
	overlayX = (overlayLx - overlayW) - overlayPadX;
	overlayY = overlayPadY;
    } else if (overlayCorner == 'cr') {
	overlayX = (overlayLx - overlayW) - overlayPadX;
	overlayY = (overlayLy - overlayH) / 2;
    } else if (overlayCorner == 'lr') {
	overlayX = (overlayLx - overlayW) - overlayPadX;
	overlayY = (overlayLy - overlayH) - overlayPadY;
    } else if (overlayCorner == 'uc') {
	overlayX = (overlayLx - overlayW) / 2;
	overlayY = overlayPadY;
    } else { // overlayCorner == 'lc'
	overlayX = (overlayLx - overlayW) / 2;
	overlayY = (overlayLy - overlayH) - overlayPadY;
    }

    if (overlayIE) {
	overlayDiv.style.left=overlayX;
	overlayDiv.style.top=overlayY+document.body.scrollTop;
    } else if (overlayNS4) {
	document.overlayDiv.pageX=overlayX;
	document.overlayDiv.pageY=overlayY+window.pageYOffset;
	document.overlayDiv.visibility="visible";
    } else if (overlayNS6) {
	var div = document.getElementById("overlayDiv");
	div.style.left=overlayX;
	div.style.top=overlayY+window.pageYOffset;
    }
}

function onad() {
    loopfunc();
}

function loopfunc() {
    overlayRefresh();
    setTimeout('loopfunc()',overlayDelay);
}

function overlaySetup(corner) {
    overlayCorner = corner;

    if (overlayIE || overlayNS4 || overlayNS6) {
	onad();
    }
}
