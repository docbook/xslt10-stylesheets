#!/bin/bash
# $Id$
# $Source #

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
# writeable CatalogManager.properties file to update.
#
# It makes backup copies of any files it touches, and also
# generates a uninstall.sh script for reverting its changes.
#
# In the same directory from it is run, it expects to find three
# files (below). And if it is unable to locate a
# CatalogManager.properties file in the user environment, it
# expects to find an "example" one in the same directory, which it
# copies over to the user's ~/.resolver directory.

thisLocatingRules=$PWD/locatingrules.xml
thisXmlCatalog=$PWD/catalog.xml
thisSgmlCatalog=$PWD/catalog

exampleCatalogManager=$PWD/.CatalogManager.properties.example 
thisCatalogManager=$HOME/.resolver/CatalogManager.properties

main() {
  removeOldFiles
  checkRoot
  updateCatalogManager
  checkForResolver
  writeDotFiles
  updateUserStartupFiles
  updateUserDotEmacs
  writeUninstallFile
  printExitMessage
}

removeOldFiles() {
  rm -f ./.profile.incl
  rm -f ./.cshrc.incl
  rm -f ./.emacs.el
}

checkRoot() {
  myUid=`id -u`
  if [ "$myUid" == "0" ]; then
    echo
    echo "WARNING: This install script is meant to be run as a"
    echo "         non-root user, but you are running it as root."
    echo
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

  #  - finds or creates a writeable CatalogManager.properties file
  #
  #  - adds the catalog.xml file for this distribution to the
  #    CatalogManager.properties file found

  if [ -z "$CLASSPATH" ]; then
    echo "NOTE: There is no CLASSPATH variable set in your environment."
    echo "      No attempt was made to find a CatalogManager.properties file."
    echo "      Using $thisCatalogManager instead."
  else
    # split CLASSPATH in a list of pathnames by replacing all colon
    # characters with spaces
    pathnames=`echo $CLASSPATH | tr ":" " "`
    for path in $pathnames; do
      # strip out trailing slash from pathname
      path=`echo $path | sed 's/\/$//'`
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
    # writeable, so use it
    myCatalogManager=$existingCatalogManager
  else
    if [ -f "$existingCatalogManager" ]; then
      # a non-writeable CatalogManager.properties exists, so emit a
      # note sayig that it won't be used
      echo "NOTE: $existingCatalogManager file found,"
      echo "      but you don't have permission to write to it."
      echo "      Will instead use $thisCatalogManager"
    else
      # CLASSPATH is set, but no CatalogManager.properties found
      if [ -n "$CLASSPATH" ]; then
        echo "NOTE: No CatalogManager.properties found from CLASSPATH."
        echo "      Will instead use $thisCatalogManager"
      fi
    fi
    # end of check for existing writeable CatalogManager.properties
    if [ -f $thisCatalogManager ]; then
      # otherwise, emit an error message saying that no
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
  # end of check finding/creating writeable CatalogManager.properties
  if [ -n "$myCatalogManager" ]; then
    etcXmlCatalog=
    catalogsLine=`grep "^catalogs=" $myCatalogManager`
    if [ -f /etc/xml/catalog ] \
      && [ "${catalogsLine#*/etc/xml/catalog*}" = "$catalogsLine" ]; then
      echo
      echo "WARNING: /etc/xml/catalog exists but was not found in the"
      echo "         $myCatalogManager file. If the"
      echo "         /etc/xml/catalog file has content, you probably should reference"
      echo "         it in your $myCatalogManager"
      echo "         file. This installer can automatitically add it for you,"
      echo "         but BE WARNED that once it has been added, the uninstaller"
      echo "         for this distribution CANNOT REMOVE IT automatically"
      echo "         during uninstall. If you no longer want it included, you"
      echo "         will need to remove it manually."
      echo
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
      echo "WARNING: ${myCatalogManager%/*} directory is not writeable."
      echo
      emitNoChangeMsg
    else
      echo
      read -s -n1 -p "Add $thisXmlCatalog to $myCatalogManager file? [Yes] "
      echo "$REPLY"
      echo
      case $REPLY in
        [nNqQ])
        emitNoChangeMsg
        ;;
        *)
        if [ "$catalogsLine" ] ; then
          if [ "${catalogsLine#*$thisXmlCatalog*}" != "$catalogsLine" ]; then
            echo "NOTE: $thisXmlCatalog already in $myCatalogManager"
          else
            mv $myCatalogManager $catalogBackup || exit 1
            sed "s#^catalogs=\(.*\)\$#catalogs=$thisXmlCatalog;\1;$etcXmlCatalog#" $catalogBackup \
            | sed 's/;\+/;/' | sed 's/;$//' > $myCatalogManager || exit 1
            echo "NOTE: $myCatalogManager file successfully updated."
            echo "      Backup written to $catalogBackup"
          fi
        else
          mv $myCatalogManager $catalogBackup || exit 1
          cp $catalogBackup $myCatalogManager
          echo "catalogs=$thisXmlCatalog;$etcXmlCatalog" \
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
  return 0
}

writeDotFiles() {
  printf "`cat <<-EOF
if [ -z "\\$XML_CATALOG_FILES" ]; then
  XML_CATALOG_FILES="$thisXmlCatalog"
else
  # $thisXmlCatalog is not in XML_CATALOG_FILES, so add it
  if [ "\\${XML_CATALOG_FILES#*$thisXmlCatalog*}" = "\\$XML_CATALOG_FILES" ]; then
    XML_CATALOG_FILES="$thisXmlCatalog \\$XML_CATALOG_FILES"
  fi
fi
# /etc/xml/catalog exists but is not in XML_CATALOG_FILES, so add it
if [ -f /etc/xml/catalog ] && \
  [ "\\${XML_CATALOG_FILES#*/etc/xml/catalog*}" = "\\$XML_CATALOG_FILES" ]; then
  XML_CATALOG_FILES="\\$XML_CATALOG_FILES /etc/xml/catalog"
fi
export XML_CATALOG_FILES

if [ -z "\\$SGML_CATALOG_FILES" ]; then
  SGML_CATALOG_FILES="$thisSgmlCatalog"
else
  # $thisSgmlCatalog is not in SGML_CATALOG_FILES, so add it
  if [ "\\${SGML_CATALOG_FILES#*$thisSgmlCatalog}" = "\\$SGML_CATALOG_FILES" ]; then
    SGML_CATALOG_FILES="$thisSgmlCatalog:\\$SGML_CATALOG_FILES"
  fi
fi
# /etc/sgml/catalog exists but is not in SGML_CATALOG_FILES, so add it
if [ -f /etc/sgml/catalog ] && \
  [ "\\${SGML_CATALOG_FILES#*/etc/sgml/catalog*}" = "\\$SGML_CATALOG_FILES" ]; then
  SGML_CATALOG_FILES="\\$SGML_CATALOG_FILES:/etc/sgml/catalog"
fi
export SGML_CATALOG_FILES
EOF
`" > .profile.incl || exit 1

  printf "`cat <<-EOF
if ( ! $\?XML_CATALOG_FILES ) then
  setenv XML_CATALOG_FILES "$thisXmlCatalog"
# $thisXmlCatalog is not in XML_CATALOG_FILES, so add it
else if ( "\\\`echo \\$XML_CATALOG_FILES | grep -v $thisXmlCatalog\\\`" != "" ) then
  setenv XML_CATALOG_FILES "$thisXmlCatalog \\$XML_CATALOG_FILES"
endif
endif
# /etc/xml/catalog exists but is not in XML_CATALOG_FILES, so add it
if ( -f /etc/xml/catalog && "\\\`echo \\$XML_CATALOG_FILES | grep -v /etc/xml/catalog\\\`" != "" ) then
  setenv XML_CATALOG_FILES "\\$XML_CATALOG_FILES /etc/xml/catalog"
endif

endif
if ( ! $\?SGML_CATALOG_FILES ) then
  setenv SGML_CATALOG_FILES "$thisSgmlCatalog"
else if ( "\\\`echo \\$SGML_CATALOG_FILES | grep -v $thisSgmlCatalog\\\`" != "" ) then
  setenv SGML_CATALOG_FILES "$thisSgmlCatalog \\$SGML_CATALOG_FILES"
endif
endif
# /etc/SGML/catalog exists but is not in SGML_CATALOG_FILES, so add it
if ( -f /etc/sgml/catalog && "\\\`echo \\$SGML_CATALOG_FILES | grep -v /etc/sgml/catalog\\\`" != "" ) then
  setenv SGML_CATALOG_FILES "\\$SGML_CATALOG_FILES /etc/sgml/catalog"
endif
EOF
`" > .cshrc.incl || exit 1

if [ -n "$myCatalogManager" ]; then
  myCatalogManagerDir=${myCatalogManager%/*}
  printf "`cat <<-EOF


if [ -z "\\$CLASSPATH" ]; then
  CLASSPATH="$myCatalogManagerDir"
else
  # $myCatalogManagerDir is not in CLASSPATH, so add it
  if [ "\\${CLASSPATH#*$myCatalogManagerDir*}" != "\\$myCatalogManagerDir" ]; then
    CLASSPATH="$myCatalogManagerDir:\\$CLASSPATH"
  fi
fi
export CLASSPATH
EOF
`" >> .profile.incl || exit 1

  printf "`cat <<-EOF


if ( ! $\?CLASSPATH ) then
  setenv CLASSPATH "$myCatalogManagerDir"
# $myCatalogManagerDir is not in CLASSPATH, so add it
else if ( "\\\`echo \\$CLASSPATH | grep -v $myCatalogManagerDir\\\`" != "" ) then
  setenv CLASSPATH "$myCatalogManagerDir:\\$CLASSPATH"
endif
endif
EOF
`" >> .cshrc.incl || exit 1
fi

printf "`cat <<-EOF
(add-hook
  'nxml-mode-hook
  (lambda ()
    (setq rng-schema-locating-files-default
          (append '("\$thisLocatingRules")
                  rng-schema-locating-files-default ))))
EOF
`" > .emacs.el || exit 1

return 0
}

updateUserStartupFiles() {
  echo
  echo "NOTE: To source your environment correctly for using the catalog files"
  echo "      in this distribution, you need to update one or more of your shell"
  echo "      startup files. This installer can automatically make the necessary"
  echo "      changes. Or, if you prefer, you can make the changes manually."
  echo

  read -s -n1 -p "Are you running a csh/tcsh shell? [No] "
  echo "$REPLY"
  case $REPLY in
    [yY])
    myStartupFiles=".cshrc .tcshrc"
    appendLine="source $PWD/.cshrc.incl"
    ;;
    *)
    myStartupFiles=".bash_profile .bash_login .profile .bashrc"
    appendLine=". $PWD/.profile.incl"
    ;;
  esac
  for file in $myStartupFiles; do
    if [ -f "$HOME/$file" ]; then
      read -s -n1 -p "Update $HOME/$file? [Yes] "
      echo "$REPLY"
      case $REPLY in
        [nNqQ])
        echo
        echo "NOTE: No change made to $HOME/$file. You either need"
        echo "      to add the following line to it, or manually source"
        echo "      the shell environment for this distribuition each"
        echo "      time you want use it."
        echo 
        echo $appendLine
        echo
        ;;
        *)
        lineExists="`grep \"$appendLine\" $HOME/$file `"
        if [ ! "$lineExists" ]; then
          dotFileBackup=$HOME/$file.$$.bak
          mv $HOME/$file $dotFileBackup     || exit 1
          cp $dotFileBackup $HOME/$file     || exit 1
          echo "$appendLine" >> $HOME/$file || exit 1
          echo
          echo "NOTE: $HOME/$file file successfully updated."
          echo "      Backup written to $dotFileBackup"
        else
          echo
          echo "NOTE: $HOME/$file already contains information for this distribution."
          echo "      $HOME/$file not updated."
          echo
        fi
        ;;
      esac
    fi
  done
  if [ -z "$dotFileBackup" ]; then
    echo
    echo "NOTE: No shell startup files updated. You can source the environment for"
    echo "      this distribution manually, each time you want to use it, by"
    echo "      typing the following."
    echo
    echo "      $appendLine"
  fi
}

updateUserDotEmacs() {
  echo
  echo "NOTE: This distribution includes a \"schema locating rules\" file for Emacs/nXML."
  echo "      To use it, you should update either your .emacs or .emacs.el file."
  echo "      This installer can automatically make the necessary changes. Or, if"
  echo "      you prefer, you can make the changes manually."
  echo

  emacsAppendLine="(load-file \"$PWD/.emacs.el\")"
  myEmacsFile=
  for file in .emacs .emacs.el; do
    if [ -e "$HOME/$file" ]; then
      myEmacsFile=$HOME/$file
      break
    else
      read -s -n1 -p "No .emacs or .emacs.el file. Create one? [No] "
      echo "$REPLY"
      echo
      case $REPLY in
        [yY])
        myEmacsFile=$HOME/.emacs
        ;;
        *)
        echo "NOTE: No Emacs changes made. To use this distribution with,"
        echo "      Emacs/nXML, you can create a .emacs file and manually"
        echo "      add the following line to it, or you can run it as a"
        echo "      command within Emacs."
        echo $emacsAppendLine
        ;;
      esac
    fi
  done
  if [ -n "$myEmacsFile" ]; then
    read -s -n1 -p  "Update $myEmacsFile? [Yes] "
    echo "$REPLY"
    echo
    case $REPLY in
      [nNqQ])
      echo
      echo "NOTE: No change made to $myEmacsFile. To use this distribution with Emacs/nXML,"
      echo "      you can manually add the following line to your $myEmacsFile, or"
      echo "      you can run it as a command within Emacs."
      echo 
      echo $emacsAppendLine
      echo
      ;;
      *)
      lineExists="`grep \"$emacsAppendLine\" $myEmacsFile`"
      if [ ! "$lineExists" ]; then
        dotEmacsBackup=$myEmacsFile.$$.bak
        mv $myEmacsFile $dotEmacsBackup    || exit 1
        cp $dotEmacsBackup $myEmacsFile    || exit 1
        echo "$emacsAppendLine" >> $myEmacsFile || exit 1
        echo "NOTE: $myEmacsFile file successfully updated."
        echo "      Backup written to $dotEmacsBackup"
      else
        echo
        echo "NOTE: $myEmacsFile already contains information for this distribution."
        echo "      $myEmacsFile not updated."
        echo
      fi
      ;;
    esac
  fi
}

uninstall() {
  echo
  echo "NOTE: To \"uninstall\" this distribution, the changes made to your"
  echo "      CatalogManagers.properties, startup files, and/or .emacs file need to"
  echo "      be reverted. This uninstaller can automatically revert them".
  echo "      Or, if you prefer, you can revert them manually."
  echo

  # make "escaped" version of PWD to use with sed and grep
  escapedPwd=`echo $PWD | sed "s#/#\\\\\/#g"`

  # check to see if a non-empty value for catalogManager was fed
  # to uninstaller.
  if [ -n ${1#--catalogManager=} ]; then
    myCatalogManager=${1#--catalogManager=}
    catalogBackup="$myCatalogManager.$$.bak"
    catalogsLine=`grep "^catalogs=" $myCatalogManager`
    if [ "$catalogsLine" ] ; then
      if [ "${catalogsLine#*$thisXmlCatalog*}" != "$catalogsLine" ]; then
        read -s -n1 -p "Revert $myCatalogManager? [Yes] "
        echo "$REPLY"
        case $REPLY in
          [nNqQ]*)
          echo
          echo "NOTE: No change made to $myCatalogManager. You need to manually"
          echo "      remove the following path from the \"catalog=\" line."
          echo 
          echo          $thisXmlCatalog
          echo
          ;;
          *)
          mv $myCatalogManager $catalogBackup || exit 1
          sed "s#^catalogs=\(.*\)$thisXmlCatalog\(.*\)\$#catalogs=\1\2#" $catalogBackup \
          | sed 's/;\+/;/' | sed 's/;$//' | sed 's/=;/=/' > $myCatalogManager || exit 1
          echo
          echo "NOTE: $myCatalogManager file successfully reverted."
          echo "      Backup written to $catalogBackup"
          ;;
        esac
      else
        echo "NOTE: No data for this distribution found in $myCatalogManager"
      fi
    else
      echo "NOTE: No data for this distribution found in $myCatalogManager"
      echo "      So, nothing to revert in $myCatalogManager"
    fi
  fi

  # check to see if a non-empty value for --dotEmacs file was fed
  # to uninstaller.
  if [ -n ${2#--dotEmacs=} ]; then
    myEmacsFile=${2#--dotEmacs=}
    revertLine="(load-file \"$escapedPwd\/\.emacs\.el\")"
    loadLine="`grep \"$revertLine\" $myEmacsFile`"
    if [ -n "$loadLine" ]; then
      echo
      read -s -n1 -p "Revert $myEmacsFile? [Yes] "
      echo "$REPLY"
      case $REPLY in
        [nNqQ]*)
        echo
        echo "NOTE: No change made to $myEmacsFile. You need to manually"
        echo "      remove the following line."
        echo 
        echo "      (load-file \"$PWD/.emacs.el\")"
        echo
        ;;
        *)
        dotEmacsBackup=$myEmacsFile.$$.bak
        mv $myEmacsFile $dotEmacsBackup       || exit 1
        cp $dotEmacsBackup $myEmacsFile       || exit 1
        sed -i "/$revertLine/d" $myEmacsFile  || exit 1
        echo
        echo "NOTE: $myEmacsFile file successfully reverted."
        echo "      Backup written to $dotEmacsBackup"
        echo
        ;;
      esac
    else
      echo "NOTE: No data for this distribution found in $myEmacsFile"
    fi
  fi

  # check all startup files
  myStartupFiles=".bash_profile .bash_login .profile .bashrc .cshrc .tcshrc"
  for file in $myStartupFiles; do
    if [ -e "$HOME/$file" ]; then
      case $file in
        .tcshrc|.cshrc)
        revertLine="source $PWD/.cshrc.incl"
        revertLineEsc="source $escapedPwd\/\.cshrc\.incl"
        ;;
        *)
        revertLine=". $PWD/.profile.incl"
        revertLineEsc="\. $escapedPwd\/\.profile\.incl"
        ;;
      esac
      lineExists="`grep \"$revertLineEsc\" $HOME/$file `"
      if [ "$lineExists" ]; then
        read -s -n1 -p "Update $HOME/$file? [Yes] "
        echo "$REPLY"
        case $REPLY in
          [nNqQ]*)
          echo
          echo "NOTE: No change made to $HOME/$file. You need to manually remove"
          echo "      the following line from it."
          echo 
          echo $revertLine
          echo
          ;;
          *)
          dotFileBackup=$HOME/$file.$$.bak
          mv $HOME/$file $dotFileBackup         || exit 1
          cp $dotFileBackup $HOME/$file         || exit 1
          sed -i "/$revertLineEsc/d" $HOME/$file  || exit 1
          echo
          echo "NOTE: $HOME/$file file successfully updated."
          echo "      Backup written to $dotFileBackup"
          echo
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
  rm -f ./uninstall.sh || exit 1
}

writeUninstallFile() {
  uninstallFile=./uninstall.sh
  echo "#!/bin/sh"                                > $uninstallFile || exit 1
  echo "./install.sh --uninstall \\"             >> $uninstallFile || exit 1
  echo "  --catalogManager=$myCatalogManager \\" >> $uninstallFile || exit 1
  echo "  --dotEmacs=$myEmacsFile \\"            >> $uninstallFile || exit 1
  chmod 755 $uninstallFile || exit 1
}
printExitMessage() {
  echo
  echo "Type the following to source your shell environment for the distriibution"
  echo
  echo $appendLine
}

checkForResolver() {
  resolverResponse="`java org.apache.xml.resolver.apps.resolver uri -u foo 2>/dev/null`"
  if [ -z "$resolverResponse" ]; then
    echo
    echo "NOTE: Your environment does not seem to contain the Apache XML Commons"
    echo "      Resolver; without that, you can't use XML catalogs with Java."
    echo "      For more information, see the \"How to use a catalog file\" section"
    echo "      Bob Stayton's \"DocBook XSL: The Complete Guide\""
    echo
    echo "         http://sagehill.net/docbookxsl/UseCatalog.html"
    echo
  fi
}

emitNoChangeMsg() {
  echo
  echo "NOTE: No changes was made to CatalogManagers.properties."
  echo "      To provide your Java tools with XML catalog information for this"
  echo "      distribution, you will need to make the appropriate changes manually."
}

if [ "$1" = "--uninstall" ]; then
  uninstall $2 $3 $4
else
  main
fi

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
