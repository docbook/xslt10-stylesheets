<?php
/* dir2xml.php --- Transform directory listing into elisp list
 * Revision: $Revision$
 * Date: $Date$
 * RCS Id: $Id$
 *
 * Use this script to transform a listing of the DocBook XSLT
 * stylesheet distro directory into a lisp list for use with the
 * 'docbook-menu' package.
 */
header ("Content-type: text/plain");
 
  function GetFileList($path, &$a)
  {
    $d=array(); 
    $f=array();
    $nd=0;  $nf=0;
    $hndl=opendir($path);
    while($file=readdir($hndl))
    {
      if ($file=='.' || $file=='..' ) continue;
      if (is_dir($path . '/' . $file))
        $d[$nd++]= $path . '/' . $file;
      else
        $f[$nf++]= $path . '/' . $file;
    }
    closedir($hndl);

    sort($d);
    sort($f);

    $n=1;
    for ($i=0;$i<count($d);$i++)
    {
      GetFileList( $d[$i], $a[$n]);
      $a[$n++][0]=$d[$i];
    }
    for ($i=0;$i<count($f);$i++)
    {
      $a[$n++]=$f[$i];
    }
  }

  function ShowFileList(&$a, $N)
  {
    global $f;
    for ($i=1;$i<=count($a); $i++)
    if (is_array($a[$i]))
    {
      $dirname = substr($a[$i][0], 1);
      $dirname = preg_replace("#^.*/([^/]+)$#", "\\1", $dirname);
      echo '(list "' . $dirname . '"' . "\n";

      ShowFileList($a[$i], $N+1);
      echo ")\n";
    } else {
      if ($a[$i]) {
      $filename = substr($a[$i], 1);
      $filename = preg_replace("#^.*/([^/]+)$#", "\\1", $filename);
        echo '["' 
        . $filename
        . '" (find-file (concat docbook-menu-xsl-dir "'
        .  substr($a[$i], 1)
        .  '")) t]' . "\n";
      }
    }
  }

  GetFileList(".",$array);
  echo "(defvar docbook-menu-xsl-distro\n";
  echo '(list "DocBook XSL: Stylesheet Distribution"'. "\n";
  ShowFileList($array, 5);
  echo ")\n";
  echo '"DocBook XSLT stylesheet distro submenu for '. "'docbook-menu'." . '"' . "\n";
  echo ")\n";
?>