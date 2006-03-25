#!/bin/bash
# $Id$
# $Source$ #

# install.sh - Set up catalogs & locating rules for a XML/XSLT distribution

# This is as a interactive installer for updating a single-user
# environment to make use of XML catalog and schema "locating
# rules" data provided in an XML/XSLT distribution.
#
# Although this installer was created for the DocBook project, it
# is a general-purpose tool that can be used with any XML/XSLT
# distribution that provides XML/SGML catalogs and locating rules.
#
# It is mainly intended to make things easier for users who want
# to install a particular XML/XSLT distribution that has not (yet)
# been packaged for their OS distro (Debian, Fedora, whatever).
#
# It works by updating the user's shell startup files (e.g.,
# .bashrc and .cshrc) and .emacs file and by finding or creating a
# writable CatalogManager.properties file to update.
#
# It makes backup copies of any files it touches, and also
# generates a uninstall.sh script for reverting its changes.
#
# In the same directory where it is located, it expects to find
# four files (below). And if it is unable to locate a
# CatalogManager.properties file in the user environment, it
# expects to find an "example" one in the same directory, which it
# copies over to the user's ~/.resolver directory.

mydir=$(readlink -f $(dirname $0))
thisLocatingRules=$mydir/locatingrules.xml
thisXmlCatalog=$mydir/catalog.xml
thisSgmlCatalog=$mydir/catalog
# .urilist file contains a list of pairs of local pathnames and
# URIs to test for catalog resolution
thisUriList=$mydir/.urilist

exampleCatalogManager=$mydir/.CatalogManager.properties.example
thisCatalogManager=$HOME/.resolver/CatalogManager.properties

osName=$(uname -o)
classPathSeparator=":"
if [ "$osName" = "Cygwin" ]; then
  thisJavaXmlCatalog=$(cygpath -m $thisXmlCatalog)
  classPathSeparator=";"
else
  thisJavaXmlCatalog=$thisXmlCatalog
fi

main() {
  removeOldFiles
  checkRoot
  updateCatalogManager
  checkForResolver
  writeDotFiles
  updateUserStartupFiles
  updateUserDotEmacs
  writeUninstallFile
  writeTestFile
  printExitMessage
}

removeOldFiles() {
  rm -f ./.profile.incl
  rm -f ./.cshrc.incl
  rm -f ./.emacs.el
}

checkRoot() {
  if [ $(id -u)  == "0" ]; then
    cat <<EOF

WARNING: This install script is meant to be run as a non-root
         user, but you are running it as root.

EOF
    read -s -n1 -p "Are you sure you want to continue? [No] "
    echo "$REPLY"
    case $REPLY in
      [yY])
      echo
      ;;
      *) echo "OK, exiting without making changes."
      exit
      ;;
    esac
  fi
  return 0
}

updateCatalogManager() {

  #  - finds or creates a writable CatalogManager.properties file
  #
  #  - adds the catalog.xml file for this distribution to the
  #    CatalogManager.properties file found

  if [ -z "$CLASSPATH" ]; then
    cat <<EOF

NOTE: There is no CLASSPATH variable set in your environment.
      No attempt was made to find a CatalogManager.properties
      file.  Using $thisCatalogManager instead
EOF
  else
    # split CLASSPATH in a list of pathnames by replacing all separator
    # characters with spaces
    if [ "$osName" = "Cygwin" ]; then
      pathnames=$(echo $CLASSPATH | tr ";" " ")
    else
      pathnames=$(echo $CLASSPATH | tr ":" " ")
    fi
    for path in $pathnames; do
    if [ "$osName" = "Cygwin" ]; then
      path=$(cygpath -u $path)
    fi
      # strip out trailing slash from pathname
      path=$(echo $path | sed 's/\/$//')
      # find CatalogManager.properties file
      if [ -f $path/CatalogManager.properties ];
      then
        existingCatalogManager=$path/CatalogManager.properties
        break
      fi
    done
  fi
  # end of CLASSPATH check

  if [ -w "$existingCatalogManager" ]; then
    # existing CatalogManager.properties was found and it is
    # writable, so use it
    myCatalogManager=$existingCatalogManager
  else
    if [ -f "$existingCatalogManager" ]; then
      # a non-writable CatalogManager.properties exists, so emit a
      # note saying that it won't be used
      cat <<EOF
NOTE: $existingCatalogManager file found,
      but you don't have permission to write to it.
      Will instead use $thisCatalogManager
EOF
    else
      # CLASSPATH is set, but no CatalogManager.properties found
      if [ -n "$CLASSPATH" ]; then
        cat <<EOF
NOTE: No CatalogManager.properties found from CLASSPATH.
      Will instead use $thisCatalogManager
EOF
      fi
    fi
    # end of check for existing writable CatalogManager.properties

    if [ -f $thisCatalogManager ]; then
      myCatalogManager=$thisCatalogManager
    else
      echo
      read -s -n1 -p "Create $thisCatalogManager file? [Yes] "
      echo "$REPLY"
      echo
      case $REPLY in
        [nNqQ])
        emitNoChangeMsg
        ;;
        *)
        if [ ! -d "${thisCatalogManager%/*}" ]; then
          mkdir -p ${thisCatalogManager%/*}
        fi
        cp ./.CatalogManager.properties.example $thisCatalogManager || exit 1
        echo "NOTE: $thisCatalogManager file created"
        myCatalogManager=$thisCatalogManager
        ;;
      esac
      # end of creating "private" CatalogManager.properties
    fi
    # end of check for "private" CatalogManager.properties
  fi
  # end of check finding/creating writable CatalogManager.properties

  if [ -n "$myCatalogManager" ]; then
    etcXmlCatalog=
    catalogsLine=$(grep "^catalogs=" $myCatalogManager)
    if [ -f /etc/xml/catalog ] && [ "$osName" != "Cygwin" ] \
      && [ "${catalogsLine#*/etc/xml/catalog*}" = "$catalogsLine" ]; then
      cat <<EOF

WARNING: /etc/xml/catalog exists but was not found in the
         $myCatalogManager file. If the
         /etc/xml/catalog file has content, you probably should reference
         it in your $myCatalogManager
         file. This installer can automatically add it for you,
         but BE WARNED that once it has been added, the uninstaller
         for this distribution CANNOT REMOVE IT automatically
         during uninstall. If you no longer want it included, you
         will need to remove it manually.

EOF
      read -s -n1 -p "Add /etc/xml/catalog to $myCatalogManager? [Yes] "
      echo "$REPLY"
      case $REPLY in
        [nNqQ])
        echo
        ;;
        *)
        etcXmlCatalog=/etc/xml/catalog
        ;;
      esac
    fi

    catalogBackup="$myCatalogManager.$$.bak"
    if [ ! -w "${myCatalogManager%/*}" ]; then
      echo
      echo "WARNING: ${myCatalogManager%/*} directory is not writable."
      echo
      emitNoChangeMsg
    else
      echo
      read -s -n1 -p "Add $thisJavaXmlCatalog to $myCatalogManager file? [Yes] "
      echo "$REPLY"
      echo
      case $REPLY in
        [nNqQ])
        emitNoChangeMsg
        ;;
        *)
        if [ "$catalogsLine" ] ; then
          if [ "${catalogsLine#*$thisJavaXmlCatalog*}" != "$catalogsLine" ]; then
            echo "NOTE: $thisJavaXmlCatalog already in $myCatalogManager"
          else
            mv $myCatalogManager $catalogBackup || exit 1
            sed "s#^catalogs=\(.*\)\$#catalogs=$thisJavaXmlCatalog;\1;$etcXmlCatalog#" $catalogBackup \
            | sed 's/;\+/;/' | sed 's/;$//' > $myCatalogManager || exit 1
            echo "NOTE: $myCatalogManager file successfully updated."
            echo "      Backup written to $catalogBackup"
          fi
        else
          mv $myCatalogManager $catalogBackup || exit 1
          cp $catalogBackup $myCatalogManager
          echo "catalogs=$thisJavaXmlCatalog;$etcXmlCatalog" \
          | sed 's/;\+/;/' | sed 's/;$//' >> $myCatalogManager || exit 1
          echo "NOTE: \"catalogs=\" line added to $myCatalogManager."
          echo "      Backup written to $catalogBackup"
        fi
        ;;
      esac
      # end of backing up and updating CatalogManager.properties
    fi
  fi
  # end of CatalogManager.properties updates

  if [ "$osName" = "Cygwin" ]; then
    myCatalogManager=$(cygpath -m $myCatalogManager)
  fi
  return 0
}

writeDotFiles() {
  while read; do
    echo "$REPLY" >> .profile.incl
  done <<EOF
if [ -z "\$XML_CATALOG_FILES" ]; then
  XML_CATALOG_FILES="$thisXmlCatalog"
else
  # $thisXmlCatalog is not in XML_CATALOG_FILES, so add it
  if [ "\${XML_CATALOG_FILES#*$thisXmlCatalog*}" = "\$XML_CATALOG_FILES" ]; then
    XML_CATALOG_FILES="$thisXmlCatalog \$XML_CATALOG_FILES"
  fi
fi
# /etc/xml/catalog exists but is not in XML_CATALOG_FILES, so add it
if [ -f /etc/xml/catalog ] && \
  [ "\${XML_CATALOG_FILES#*/etc/xml/catalog*}" = "\$XML_CATALOG_FILES" ]; then
  XML_CATALOG_FILES="\$XML_CATALOG_FILES /etc/xml/catalog"
fi
export XML_CATALOG_FILES

if [ -z "\$SGML_CATALOG_FILES" ]; then
  SGML_CATALOG_FILES="$thisSgmlCatalog"
else
  # $thisSgmlCatalog is not in SGML_CATALOG_FILES, so add it
  if [ "\${SGML_CATALOG_FILES#*$thisSgmlCatalog}" = "\$SGML_CATALOG_FILES" ]; then
    SGML_CATALOG_FILES="$thisSgmlCatalog:\$SGML_CATALOG_FILES"
  fi
fi
# /etc/sgml/catalog exists but is not in SGML_CATALOG_FILES, so add it
if [ -f /etc/sgml/catalog ] && \
  [ "\${SGML_CATALOG_FILES#*/etc/sgml/catalog*}" = "\$SGML_CATALOG_FILES" ]; then
  SGML_CATALOG_FILES="\$SGML_CATALOG_FILES:/etc/sgml/catalog"
fi
export SGML_CATALOG_FILES
EOF

while read; do
  echo "$REPLY" >> .cshrc.incl
done <<EOF
if ( ! $\?XML_CATALOG_FILES ) then
  setenv XML_CATALOG_FILES "$thisXmlCatalog"
# $thisXmlCatalog is not in XML_CATALOG_FILES, so add it
else if ( "\\\`echo \$XML_CATALOG_FILES | grep -v $thisXmlCatalog\\\`" != "" ) then
  setenv XML_CATALOG_FILES "$thisXmlCatalog \$XML_CATALOG_FILES"
endif
endif
# /etc/xml/catalog exists but is not in XML_CATALOG_FILES, so add it
if ( -f /etc/xml/catalog && "\\\`echo \$XML_CATALOG_FILES | grep -v /etc/xml/catalog\\\`" != "" ) then
  setenv XML_CATALOG_FILES "\$XML_CATALOG_FILES /etc/xml/catalog"
endif

endif
if ( ! $\?SGML_CATALOG_FILES ) then
  setenv SGML_CATALOG_FILES "$thisSgmlCatalog"
else if ( "\\\`echo \$SGML_CATALOG_FILES | grep -v $thisSgmlCatalog\\\`" != "" ) then
  setenv SGML_CATALOG_FILES "$thisSgmlCatalog \$SGML_CATALOG_FILES"
endif
endif
# /etc/SGML/catalog exists but is not in SGML_CATALOG_FILES, so add it
if ( -f /etc/sgml/catalog && "\\\`echo \$SGML_CATALOG_FILES | grep -v /etc/sgml/catalog\\\`" != "" ) then
  setenv SGML_CATALOG_FILES "\$SGML_CATALOG_FILES /etc/sgml/catalog"
endif
EOF

if [ -n "$myCatalogManager" ]; then
  myCatalogManagerDir=${myCatalogManager%/*}
  while read; do
    echo "$REPLY" >> .profile.incl
  done <<EOF


if [ -z "\$CLASSPATH" ]; then
  CLASSPATH="$myCatalogManagerDir"
else
  # $myCatalogManagerDir is not in CLASSPATH, so add it
  if [ "\${CLASSPATH#*$myCatalogManagerDir*}" = "\$CLASSPATH" ]; then
    CLASSPATH="$myCatalogManagerDir$classPathSeparator\$CLASSPATH"
  fi
fi
export CLASSPATH
EOF

  while read; do
    echo "$REPLY" >> .cshrc.incl
  done <<EOF


if ( ! $\?CLASSPATH ) then
  setenv CLASSPATH "$myCatalogManagerDir"
# $myCatalogManagerDir is not in CLASSPATH, so add it
else if ( "\\\`echo \$CLASSPATH | grep -v $myCatalogManagerDir\\\`" != "" ) then
  setenv CLASSPATH "$myCatalogManagerDir$classPathSeparator\$CLASSPATH"
endif
endif
EOF

fi

while read; do
  echo "$REPLY" >> .emacs.el
done <<EOF
(add-hook
  'nxml-mode-hook
  (lambda ()
    (setq rng-schema-locating-files-default
          (append '("$thisLocatingRules")
                  rng-schema-locating-files-default ))))
EOF

return 0
}

updateUserStartupFiles() {
  cat <<EOF

NOTE: To source your environment correctly for using the catalog
      files in this distribution, you need to update one or more
      of your shell startup files. This installer can
      automatically make the necessary changes. Or, if you prefer,
      you can make the changes manually.

EOF

  # if user is running csh or tcsh, target .cshrc and .tcshrc
  # files for update; otherwise, target .bash_* and .profiles

  parent=$(ps $PPID | grep "/")
  if [ "${parent#*csh}" != "$parent" ] || [ "${parent#*tcsh}" != "$parent" ]; then
    myStartupFiles=".cshrc .tcshrc"
    appendLine="source $mydir/.cshrc.incl"
  else
    myStartupFiles=".bash_profile .bash_login .profile .bashrc"
    appendLine=". $mydir/.profile.incl"
  fi

  for file in $myStartupFiles; do
    if [ -f "$HOME/$file" ]; then
      dotFileBackup=$HOME/$file.$$.bak
      read -s -n1 -p "Update $HOME/$file? [Yes] "
      echo "$REPLY"
      case $REPLY in
        [nNqQ])
        cat <<EOF

NOTE: No change made to $HOME/$file. You either need
      to add the following line to it, or manually source
      the shell environment for this distribution each
      time you want use it.

$appendLine

EOF
        ;;
        *)
        lineExists="$(grep "$appendLine" $HOME/$file )"
        if [ ! "$lineExists" ]; then
          mv $HOME/$file $dotFileBackup     || exit 1
          cp $dotFileBackup $HOME/$file     || exit 1
          echo "$appendLine" >> $HOME/$file || exit 1
          cat <<EOF

NOTE: $HOME/$file file successfully updated.
      Backup written to $dotFileBackup
EOF
        else
          cat <<EOF

NOTE: $HOME/$file already contains information for this distribution.
      $HOME/$file not updated.

EOF
        fi
        ;;
      esac
    fi
  done
  if [ -z "$dotFileBackup" ]; then
    cat <<EOF

NOTE: No shell startup files updated. You can source the
      environment for this distribution manually, each time you
      want to use it, by typing the following.

$appendLine

EOF
  fi
}

updateUserDotEmacs() {
  if [ -f $thisLocatingRules ]; then
  cat <<EOF

NOTE: This distribution includes a "schema locating rules" file
      for Emacs/nXML.  To use it, you should update either your
      .emacs or .emacs.el file.  This installer can automatically
      make the necessary changes. Or, if you prefer, you can make
      the changes manually.

EOF

  emacsAppendLine="(load-file \"$mydir/.emacs.el\")"
  myEmacsFile=
  for file in .emacs .emacs.el; do
    if [ -f "$HOME/$file" ]; then
      myEmacsFile=$HOME/$file
      break
    fi
  done
  if [ ! -f "$myEmacsFile" ]; then
    read -s -n1 -p "No .emacs or .emacs.el file. Create one? [No] "
    echo "$REPLY"
    echo
    case $REPLY in
      [yY])
      myEmacsFile=$HOME/.emacs
      touch $myEmacsFile
      ;;
      *)
      cat <<EOF
NOTE: No Emacs changes made. To use this distribution with,
      Emacs/nXML, you can create a .emacs file and manually add
      the following line to it, or you can run it as a command
      within Emacs.

$emacsAppendLine

EOF
      ;;
    esac
  fi
  if [ -n "$myEmacsFile" ]; then
    read -s -n1 -p  "Update $myEmacsFile? [Yes] "
    echo "$REPLY"
    echo
    case $REPLY in
      [nNqQ])
      cat <<EOF

NOTE: No change made to $myEmacsFile. To use this distribution
      with Emacs/nXML, you can manually add the following line
      to your $myEmacsFile, or you can run it as a command
      within Emacs.

$emacsAppendLine

EOF
      ;;
      *)
      lineExists="$(grep "$emacsAppendLine" $myEmacsFile)"
      if [ ! "$lineExists" ]; then
        dotEmacsBackup=$myEmacsFile.$$.bak
        mv $myEmacsFile $dotEmacsBackup    || exit 1
        cp $dotEmacsBackup $myEmacsFile    || exit 1
        echo "$emacsAppendLine" >> $myEmacsFile || exit 1
        cat <<EOF
NOTE: $myEmacsFile file successfully updated.
      Backup written to $dotEmacsBackup
EOF
      else
        cat <<EOF

NOTE: $myEmacsFile already contains information for this distribution.
      $myEmacsFile not updated.

EOF
      fi
      ;;
    esac
  fi
fi
}

uninstall() {
  cat <<EOF

NOTE: To "uninstall" this distribution, the changes made to your
      CatalogManagers.properties, startup files, and/or .emacs
      file need to be reverted. This uninstaller can automatically
      revert them.  Or, if you prefer, you can revert them manually.

EOF

  if [ "$osName" = "Cygwin" ]; then
    thisXmlCatalog=$thisJavaXmlCatalog
  fi

  # make "escaped" version of PWD to use with sed and grep
  escapedPwd=$(echo $mydir | sed "s#/#\\\\\/#g")

  # check to see if a non-empty value for catalogManager was fed
  # to uninstaller.
  if [ -n ${1#--catalogManager=} ]; then
    myCatalogManager=${1#--catalogManager=}
    catalogBackup="$myCatalogManager.$$.bak"
    catalogsLine=$(grep "^catalogs=" $myCatalogManager)
    if [ "$catalogsLine" ] ; then
      if [ "${catalogsLine#*$thisXmlCatalog*}" != "$catalogsLine" ]; then
        read -s -n1 -p "Revert $myCatalogManager? [Yes] "
        echo "$REPLY"
        case $REPLY in
          [nNqQ]*)
          cat <<EOF

NOTE: No change made to $myCatalogManager. You need to manually
      remove the following path from the "catalog=" line.

          $thisXmlCatalog

EOF
          ;;
          *)
          mv $myCatalogManager $catalogBackup || exit 1
          sed "s#^catalogs=\(.*\)$thisXmlCatalog\(.*\)\$#catalogs=\1\2#" $catalogBackup \
          | sed 's/;\+/;/' | sed 's/;$//' | sed 's/=;/=/' > $myCatalogManager || exit 1
          cat <<EOF

NOTE: $myCatalogManager file successfully reverted.
      Backup written to $catalogBackup
EOF
          ;;
        esac
      else
        echo "NOTE: No data for this distribution found in $myCatalogManager"
        echo
      fi
    else
      cat <<EOF
NOTE: No data for this distribution found in $myCatalogManager
      So, nothing to revert in $myCatalogManager
EOF
    fi
  fi

  if [ -n "$myEmacsFile" ]; then 
    # check to see if a non-empty value for --dotEmacs file was fed
    # to uninstaller.
    if [ -n ${2#--dotEmacs=} ]; then
      myEmacsFile=${2#--dotEmacs=}
      revertLine="(load-file \"$escapedPwd\/\.emacs\.el\")"
      loadLine="$(grep "$revertLine" "$myEmacsFile")"
      if [ -n "$loadLine" ]; then
        echo
        read -s -n1 -p "Revert $myEmacsFile? [Yes] "
        echo "$REPLY"
        case $REPLY in
          [nNqQ]*)
          cat <<EOF

NOTE: No change made to $myEmacsFile. You need to manually
remove the following line.

(load-file \"$mydir/.emacs.el\")

EOF
          ;;
          *)
          dotEmacsBackup=$myEmacsFile.$$.bak
          mv $myEmacsFile $dotEmacsBackup       || exit 1
          cp $dotEmacsBackup $myEmacsFile       || exit 1
          sed -i "/$revertLine/d" $myEmacsFile  || exit 1
          cat <<EOF

NOTE: $myEmacsFile file successfully reverted.
Backup written to $dotEmacsBackup

EOF
          ;;
        esac
      else
        echo "NOTE: No data for this distribution found in $myEmacsFile"
      fi
    fi
  fi

  # check all startup files
  myStartupFiles=".bash_profile .bash_login .profile .bashrc .cshrc .tcshrc"
  for file in $myStartupFiles; do
    if [ -e "$HOME/$file" ]; then
      case $file in
        .tcshrc|.cshrc)
        revertLine="source $mydir/.cshrc.incl"
        revertLineEsc="source $escapedPwd\/\.cshrc\.incl"
        ;;
        *)
        revertLine=". $mydir/.profile.incl"
        revertLineEsc="\. $escapedPwd\/\.profile\.incl"
        ;;
      esac
      lineExists="$(grep "$revertLineEsc" $HOME/$file )"
      if [ "$lineExists" ]; then
        read -s -n1 -p "Update $HOME/$file? [Yes] "
        echo "$REPLY"
        case $REPLY in
          [nNqQ]*)
          cat <<EOF

NOTE: No change made to $HOME/$file. You need to manually remove
      the following line from it.

 $revertLine

EOF
          ;;
          *)
          dotFileBackup=$HOME/$file.$$.bak
          mv $HOME/$file $dotFileBackup           || exit 1
          cp $dotFileBackup $HOME/$file           || exit 1
          sed -i "/$revertLineEsc/d" $HOME/$file  || exit 1
          cat <<EOF

NOTE: $HOME/$file file successfully updated.
      Backup written to $dotFileBackup

EOF
          ;;
        esac
      else
        echo "NOTE: No data for this distribution found in $HOME/$file"
        echo
      fi
    fi
  done
  removeOldFiles
  echo "Done. Deleted uninstall.sh file."
  rm -f ./test.sh      || exit 1
  rm -f ./uninstall.sh || exit 1
}

writeUninstallFile() {
  uninstallFile=./uninstall.sh
  echo "#!/bin/sh"                                > $uninstallFile || exit 1
  echo "$mydir/install.sh --uninstall \\"          >> $uninstallFile || exit 1
  echo "  --catalogManager=$myCatalogManager \\" >> $uninstallFile || exit 1
  echo "  --dotEmacs=$myEmacsFile"               >> $uninstallFile || exit 1
  chmod 755 $uninstallFile || exit 1
}

writeTestFile() {
  testFile=./test.sh
  echo "#!/bin/sh"                                > $testFile || exit 1
  echo "$mydir/install.sh --test"                  >> $testFile || exit 1
  chmod 755 $testFile || exit 1
}

printExitMessage() {
  cat <<EOF

Type the following to source your shell environment for the distribution

$appendLine

EOF
}

checkForResolver() {
  resolverResponse="$(java org.apache.xml.resolver.apps.resolver uri -u foo 2>/dev/null)"
  if [ -z "$resolverResponse" ]; then
    cat <<EOF

NOTE: Your environment does not seem to contain the Apache XML Commons
      Resolver; without that, you can't use XML catalogs with Java.
      For more information, see the "How to use a catalog file" section
      in Bob Stayton's "DocBook XSL: The Complete Guide"

      http://sagehill.net/docbookxsl/UseCatalog.html

EOF
  fi
}

emitNoChangeMsg() {
  cat <<EOF

NOTE: No changes was made to CatalogManagers.properties. To
      provide your Java tools with XML catalog information for
      this distribution, you will need to make the appropriate
      changes manually.

EOF
}

testCatalogs() {
  readlinkResponse="$(readlink -f ./ 2>/dev/null)"
  if [ -z "$readlinkResponse" ]; then
    cat <<EOF

FATAL: Cannot locate the "readlink" command. Stopping.
EOF
  exit
  fi

  if [ ! -f "$thisXmlCatalog" ]; then
    cat <<EOF

FATAL: $thisXmlCatalog file needed but not found. Stopping.
EOF
  exit
  fi

  if [ -z "$XML_CATALOG_FILES" ]; then
    echo
    echo "WARNING: XML_CATALOG_FILES not set. Not testing with xmlcatalog."
  else
    xmlCatalogResponse="$(xmlcatalog 2>/dev/null)"
    if [ -z "$xmlCatalogResponse" ]; then
    cat <<EOF

WARNING: Cannot locate the "xmlcatalog" command. Make sure that
         you have libxml2 and its associated utilities installed.

         http://xmlsoft.org/

EOF
    else
      echo
      echo "Testing with xmlcatalog..."
      while read pair; do
        path=$(readlink -f "${pair%* *}")
        uri=${pair#* *}
        echo
        echo "  Tested:" $uri
        for catalog in $XML_CATALOG_FILES; do
          response="$(readlink -f "$(xmlcatalog $catalog $uri| grep -v "No entry")")"
          if [ -n "$response" ]; then
            if [ "$response" = "$path" ]; then
              echo "  Result: $path"
              break
            else
              echo "  Result: FAILED"
            fi
          fi
        done
      done < .urilist
    fi
  fi

  if [ -z "$CLASSPATH" ]; then
    echo
    echo "NOTE: CLASSPATH not set. Not testing with Apache XML Commons Resolver."
  else
    if [ "$(checkForResolver)" ]; then
      checkForResolver
    else
      echo
      echo "Testing with Apache XML Commons Resolver..."
      while read pair; do
        path=$(readlink -f ${pair%* *})
        uri=${pair#* *}
        echo
        echo "  Tested:" $uri
        if [ ${uri%.dtd} != $uri ]; then
          response="$(java org.apache.xml.resolver.apps.resolver system -s $uri | grep "Result")"
        else
          response="$(java org.apache.xml.resolver.apps.resolver uri -u $uri | grep "Result")"
        fi
        if [ "$response" ]; then
          if [ "${response#*$path}" != "$response" ]; then
            echo "  Result: $path"
          else
            echo "  Result: FAILED"
          fi
        fi
      done < .urilist
    fi
  fi
}

# get opts and execute appropriate function
case $1 in
  *-uninstall)
  uninstall $2 $3 $4
  ;;
  *-test)
  testCatalogs
  ;;
  *)
  main
  ;;
esac

# Copyright
# ---------
# Copyright 2005 Michael Smith <smith@sideshowbarker.net>
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# vim: number
