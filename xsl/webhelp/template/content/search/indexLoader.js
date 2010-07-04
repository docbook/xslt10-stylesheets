/*----------------------------------------------------------------------------
 * NexWave javascript for NSI search
 *----------------------------------------------------------------------------
  This file is part of the htmlsearch plugin for the DITA-OT
  adapted for NSI documentation.
  Copyright (c) 2007-2008 NexWave Solutions All Rights Reserved. 
   www.nexwave.biz Nadege Quaine
*/
if (true) {
    var tab = new Array("htmlFileList","htmlFileInfoList","0","1","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z");
    
    var headEl =  document.getElementsByTagName('head').item(0);
    for (el in tab) {
        script =  document.createElement('script');
    	
        var scriptTag = document.getElementById('loadScript' + tab[el]);
        if(scriptTag) headEl.removeChild(scriptTag);
        
        script.src = "search/" + tab[el]+ ".js";
        script.id = 'loadScript'+tab[el];
        script.type = 'text/javascript';
        script.defer = true;
        headEl.appendChild(script);
    } 
}


