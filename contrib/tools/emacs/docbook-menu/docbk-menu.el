;;; docbk-menu.el --- Easy access to DocBook docs
;; $Id$

;; Copyright (C) 2003 Michael Smith

;; Author: Michael Smith <smith@sideshowbarker.net>
;; Maintainer: Michael Smith <smith@sideshowbarker.net>
;; Created: 2003-11-04
;; Version: 0.90
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$
;; Keywords: xml docbook

;; This file is NOT part of GNU emacs.

;; This is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; -------------------------------------------------------------------
;;; Compatibility
;; -------------------------------------------------------------------
;; `docbook-menu-mode' has been tested and found to work reliably with
;; both the GNU/Linux (Debian) and Microsoft Windows versions of GNU
;; Emacs 21.3, 21.2, and 20.7, as well as Meadow version 20.7. It
;; probably will not work at all with XEmacs or with earlier versions
;; of GNU Emacs (e.g., Emacs 19.x).
;; 
;; -------------------------------------------------------------------
;;; Commentary
;;-------------------------------------------------------------------
;; This package adds a hierarchical, customizable menu for quickly
;; accessing a variety of DocBook-related documentation and for easily
;; getting to files in the DocBook XSLT stylesheets distribution.
;;
;; See the Installation and Configuration, and Customization sections
;; below for "getting started" how-to instructions.
;;
;; The menu this package provides is intended as a sort of "at your
;; fingertips" ready-reference for people who use Emacs to edit
;; DocBook XML files and/or work with the DocBook XSLT stylesheets
;; (creating customization layers to change parameters and templates).
;;
;; There are some screenshots of it at:
;;
;;   http://www.logopoeia.com/docbook/docbook-menu.html
;;
;; See the Details section below for details about the menu contents.
;;
;; -------------------------------------------------------------------
;;; Installation and Configuration
;; -------------------------------------------------------------------
;;
;; To install and use this package:
;;
;; 1. Go to the docbook-menu download site:
;;
;;      http://www.logopoeia.com/docbook/download
;;
;;    And download the latest docbook-menu-N.NN.zip file
;;    (for example, docbook-menu-1.00.zip).
;;
;; 2. Move the docbook-menu-N.NN.zip file into the folder/directory
;;    where you want to install it (e.g., your Emacs "site-lisp"
;;    directory or your "My Documents" folder or whatever) and then
;;    unzip it to create a docbook-menu-N.NN directory (for
;;    example 'docbook-menu-1.0').
;;
;; 3. Add the docbook-menu-N.NN directory to your Emacs load-path.  You
;;    can do that by adding a line similar to the following to the
;;    beginning of your .emacs file.
;;
;;      (add-to-list 'load-path "c:/my-xml-stuff/docbook-menu-1.00")
;;
;; 4. Add the following to your .emacs file exactly as shown:
;;
;;      (require 'dbk-menu)
;;
;; ==================================================================
;; Note: The *.elc files included in this distribution are
;;       byte-compiled for Emacs 21.x. So, to use this package with
;;       Emacs 20.7 or Meadow 20.7, you must remove all *.elc files
;;       from the main "docbook-menu" directory and its "submenus"
;;       subdirectory before restarting Emacs. Then re-compile them.
;; ==================================================================
;;
;; After you restart Emacs, to view the menu at any time, either:
;;
;;   - choose Show DocBook Menu from the Emacs Help menu
;;       or
;;   - type "\M-x docbook-menu-mode<return>" (on MS Windows, that's
;;     "Alt-x docbook-menu-mode" and then hit <Enter>)
;;
;; Note: To make the DocBook: The Definitive Guide (HTML Help) and
;;       DocBook XSL submenus work correctly, you must set values for
;;       some options.  See the Customization section below for details.
;;
;; Showing the menu automatically
;; ------------------------------
;; There are a couple of ways you can make the menu automatically
;; show up (rather than needing to invoke it manually)
;; 
;;   - To show the menu by default, after you open a new file, so that
;;     it shows up no matter what buffer/mode you're in, add the
;;     following to your .emacs file:
;;
;;       (add-hook 'find-file-hooks 'docbook-menu-mode)
;;
;;   - To show the menu only when you're in a certain major mode (for
;;     example, only in nxml-mode)
;;
;;       (add-hook 'nxml-mode-hook 'docbook-menu-mode)
;;
;; To be able to show/hide the menu using a shorter keyboard shortcut,
;; you need to add something like the following to your .emacs file.
;;
;;   (define-key global-map "\C-cd" 'docbook-menu-mode)
;;
;; That example will enable you to use the 'Ctrl-c d' keyboard to
;; show/hide the menu.
;;
;; -------------------------------------------------------------------
;;; Customization
;; -------------------------------------------------------------------
;;
;; To customize the menu contents and behavior, either:
;;
;;   - choose Customize DocBook Menu from the menu itself
;;       or
;;   - type \M-x customize-group<return>docbook-menu<return>
;;
;; The most useful customization options available are options to:
;;
;;   - remove/rearrange/add submenus
;;
;;   - specify local documentation files that you want to use (instead
;;     of the default online versions)
;;
;; Note: To use the DocBook: The Definitive Guide (HTML Help) and
;;       DocBook XSL menus, you MUST set values for the
;;       `docbook-menu-xsl-dir', `docbook-menu-xsl-docs-dir', and
;;       `docbook-menu-html-help-dir' options, which specify the
;;       local paths to the directory where you have the DocBook XSL
;;       Stylesheets and docs stored on your machine, and the path to
;;       the HTML Help version of DocBook: The Definitive Guide.
;;
;;       You can set the values for those via Customize DocBook Menu
;;       submenu or by adding something similar to the following to
;;       your .emacs file:
;;
;;       On Debian:
;;         (setq docbook-menu-xsl-dir
;;            "/usr/share/sgml/docbook/stylesheet/xsl/nwalsh")
;;         (setq docbook-menu-xsl-docs-dir
;;            "/usr/share/doc/docbook-xsl")
;;
;;       On Windows (example):
;;         (setq docbook-menu-xsl-dir
;;            "c:/my-xml-stuff/docbook-xsl-1.62.4")
;;         (setq docbook-menu-xsl-docs-dir
;;            "c:/my-xml-stuff/docbook-xsl-1.62.4")
;;         (setq docbook-menu-html-help-dir
;;            "c:/my-xml-stuff/docbook/tdg")
;;
;; -------------------------------------------------------------------
;;; Details
;; -------------------------------------------------------------------
;; By default, `docbook-menu-mode' provides the following submenus:
;;
;;   DocBook: The Definitive Guide
;;   DocBook: The Definitive Guide (HTML Help)
;;   DocBook: Element Reference (Alphabetical)
;;   DocBook: Element Reference (Logical)
;;   ----
;;   DocBook XSL: The Complete Guide
;;   DocBook XSL: Parameter Reference - FO
;;   DocBook XSL: Parameter Reference - HTML
;;   ----
;;   DocBook XSL: Stylesheet Distribution
;;   DocBook XSL: Stylesheet Documentation
;;   ----
;;   DocBook FAQ
;;   DocBook Wiki
;;   DocBook Mailing List Search Form
;;   ----
;;   Customize DocBook Menu
;;
;; Here are brief descriptions of each submenu:
;;
;;   DocBook: The Definitive Guide
;;     Full hierarchical TOC for TDG
;;
;;   DocBook: The Definitive Guide (HTML Help)
;;     .chm version of TDG
;;
;;   DocBook: Element Reference (Alphabetical)
;;     A-Z element list, with short descriptions for each,
;;     and links to the TDG
;;
;;   DocBook: Element Reference (Logical)
;;     Logical element list that links to TDG
;;
;;   DocBook XSL: The Complete Guide
;;     Full hierarchical TOC
;;
;;   DocBook XSL: Parameter Reference - FO
;;     List of all DocBook XSLT FO params, with
;;     short with short descriptions for each
;;
;;   DocBook XSL: Parameter Reference - HTML
;;     Like the FO menu, but for HTML params
;;
;;   DocBook XSL: Stylesheet Distribution
;;     Hierarchical access to stylesheets directory
;;
;;   DocBook XSL: Stylesheet Documentation
;;     Hierarchical access to stylesheets docs
;;
;;   DocBook FAQ
;;     Dave Pawson's FAQ
;;
;;   DocBook Wiki
;;     Selected Wiki pages
;;
;;   DocBook Mailing List Search Form
;;     Form for searching archives of the docbook-apps and
;;     docbook mailing lists
;;
;;   Customize DocBook Menu
;;     User-friendly interface for setting options and
;;     adding/removing/rearranging submenus.
;; 
;; -------------------------------------------------------------------
;;; History:
;; -------------------------------------------------------------------
;;   2003-11-nn - first public release
;;
;; -------------------------------------------------------------------
;;; Acknowledgements
;; -------------------------------------------------------------------
;;
;; All this package does is give easy access to a lot of great content
;; put together by other people; in particular:
;;
;;   Dave Pawson - DocBook FAQ and "Quick Reference" (which was part
;;                 of the basis for contents of the "DocBook Element
;;                 Reference (Logical)" menu this package provides)
;;
;;   Jirka Kosek - DocBook XSLT stylesheet contributions and docs,
;;                 .chm (HTML Help) versions of TDG
;;
;;   Bob Stayton - DocBook XSL: The Complete Guide, DocBook XSLT
;;                 stylesheet contributions and docs
;;
;;   Norm Walsh  - DocBook: The Definitive Guide (TDG), DocBook XSLT
;;                 stylesheets and docs, DocBook Wiki

;;; Code:

;; *******************************************************************
;;; Initialization
;; *******************************************************************

(require 'easymenu)
(require 'easy-mmode)

(easy-mmode-define-minor-mode docbook-menu-mode
  "Minor mode that displays menu for accessing DocBook docs."
  ;; Initial value is nil.
  nil
  ;; No indicator for the mode line.
  nil
  ;; Make empty default keymap;
  '( ("" . nil)))

(defvar docbook-menu-directory (file-name-directory load-file-name)
  "Directory where `docbook-menu-mode' files are located.
Currently used only for finding DocBook mailing list search form.")

(defvar docbook-menu-tdg-html-help
  (list "DocBook: The Definitive Guide (HTML Help)"
	["Expanded" (call-process
		     docbook-menu-chm-viewer nil 0 nil
		     (concat docbook-menu-chm-viewer-args
			     docbook-menu-tdg-chm-file-exp)) t]
	["Unexpanded" (call-process
		       docbook-menu-chm-viewer nil 0 nil
		       (concat docbook-menu-chm-viewer-args
			       docbook-menu-tdg-chm-file-unexp)) t]
	 )
  "TDG HTML Help submenu for `docbook-menu-mode'."
  )

(defvar docbook-menu-item-separator1
  ["--" t]
  "Separator between `docbook-menu-mode' menu items."
  )
(defvar docbook-menu-item-separator2
  ["---" t]
  "Separator between `docbook-menu-mode' menu items."
  )
(defvar docbook-menu-item-separator3
  ["----" t]
  "Separator between `docbook-menu-mode' menu items."
  )
(defvar docbook-menu-item-separator4
  ["-----" t]
  "Separator between `docbook-menu-mode' menu items."
  )

(defvar docbook-menu-search-form
  ["DocBook Mailing List Search Form"
   (browse-url (concat "file:///" docbook-menu-directory "/html/search.html")) t]
  "Mailing-list search form submenu for `docbook-menu-mode'."
  )

(defvar docbook-menu-xsl-tcg-uri "http://www.sagehill.net/docbookxsl")

(defvar docbook-menu-customize
  ["Customize DocBook Menu"
   (customize-group 'docbook-menu) t]
  "Customize submenu for `docbook-menu-mode'."
  )

;; load submenu contents (stored in separate files)
(load-library "submenus/dbk-el-az.el")
(load-library "submenus/dbk-el-lg.el")
(load-library "submenus/dbk-faq.el")
(load-library "submenus/dbk-tdg.el")
(load-library "submenus/dbk-wiki.el")
(load-library "submenus/dbk-xsldir.el")
(load-library "submenus/dbk-xsldoc.el")
(load-library "submenus/dbk-xslhtm.el")
(load-library "submenus/dbk-xslfo.el")
(load-library "submenus/dbk-xsltcg.el")

(defgroup docbook-menu nil
  "Customization group for `docbook-menu-mode' minor mode.")

;; *******************************************************************
;;; User customizable options
;; *******************************************************************

(defcustom docbook-menu-contents
  '(
   docbook-menu-tdg-toc
   docbook-menu-tdg-html-help
   docbook-menu-elements-alphabetical
   docbook-menu-elements-logical
   docbook-menu-item-separator1
   docbook-menu-xsl-tcg
   docbook-menu-xsl-params-fo
   docbook-menu-xsl-params-html
   docbook-menu-item-separator2
   docbook-menu-xsl-distro
   docbook-menu-xsl-docs
   docbook-menu-item-separator3
   docbook-menu-faq
   docbook-menu-wiki
   docbook-menu-search-form
   docbook-menu-item-separator4
   docbook-menu-customize
   )
  "*Contents of `docbook-menu-mode' menu.
Customize this to add/remove/rearrange submenus."
  :set (lambda (sym val)
         (setq docbook-menu-contents val)
	 (setq docbook-menu-definition
	       (cons "DocBook"
		     ;; turn quoted docbook-menu-contents value back into a real list
		     ;; thanks, sachac :)
		     (mapcar (lambda (item) (if (symbolp item) (eval item) item)) val)
		     )
	       )
	 )
  :group 'docbook-menu
  :type '(repeat variable)
  )

(defcustom docbook-menu-suppress-from-help-menu-flag nil
  "*Non-nil means suppress 'Show DocBook Menu' from Help menu.
Set to non-nil \(on\) to suppress, leave at nil \(off\) to show."
  :type 'boolean
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-tdg-base-uri "http://docbook.org/tdg/en/html"
  "*Base URI for location of TDG HTML files.
If you have TDG HTML files on your local machine, set this
to the URI for the base directory where you have the files
installed; for example, file:///foo/tdg/en/html.  Otherwise,
`docbook-menu-mode' defaults to showing the online Web versions at

  http://docbook.org/tdg/en/

Note that downloadable ZIP archives of TDG HTML pages are
available at that same address."
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-faq-base-uri "http://www.dpawson.co.uk/docbook"
  "*Base URI for DocBook FAQ HTML.
files.  If you have DocBook FAQ files on your local machine
\(maybe you grabbed them with wget or whatever\),
set this to the URI for the base directory where you have the
files installed; for example, file:///foo/docbook-faq.
Otherwise, `docbook-menu-mode' defaults to showing the online Web
versions at http://www.dpawson.co.uk/docbook"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu)

(defcustom docbook-menu-wiki-base-uri "http://www.docbook.org/wiki/moin.cgi"
  "*Base URI for DocBook Wiki.
If you have DocBook Wiki files on your local machine
\(maybe you grabbed them with wget or whatever\),
set this to the URI for the base directory where you have the
files installed; for example, file:///foo/docbook-wiki.
Otherwise, `docbook-menu-mode' defaults to showing the online Web
versions at http://www.docbook.org/wiki/moin.cgi"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-xsl-dir ""
  "*Absolute path to base DocBook XSL Stylesheets directory.
Not a URI -- instead must be just a filesystem pathname, e.g.,

  /usr/share/sgml/docbook/stylesheet/xsl/nwalsh
   or
  c:/my-xml-stuff/docbook-xsl-1.62.4"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-xsl-docs-dir ""
  "*Absolute path to base DocBook XSL Stylesheets doc directory.
Not a URI -- instead must be just a filesystem pathname, e.g.,

  /usr/share/doc/docbook-xsl/docsrc
   or
  c:/my-xml-stuff/docbook-xsl-1.62.4"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-tdg-chm-file-unexp ""
  "*Absolute local path to the TDG .chm help file \(unexpanded\).
Not a URI -- instead must be just a filesystem pathname, e.g.,

  c:/my-xml-stuff/docbook/tdg/tdg-en-2.0.7-x.chm

Note that you can download .chm (HTML Help) versions (expanded and
unexpanded) of the TDG at http://docbook.org/tdg/en/

And note that .chm files are also viewable on Unix systems via an
application called xCHM; see http://xchm.sourceforge.net/"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-tdg-chm-file-exp ""
  "*Absolute local path to the TDG .chm help file \(expanded\).
Not a URI -- instead must be just a filesystem pathname, e.g.,

  c:/my-xml-stuff/docbook/tdg/tdg-en-2.0.7.chm

Note that you can download .chm \(HTML Help\) versions (expanded and
unexpanded) of the TDG at http://docbook.org/tdg/en/

And note that .chm files are also viewable on Unix systems via an
application called xCHM; see http://xchm.sourceforge.net/"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-chm-viewer "hh"
  "*Program for viewing .chm \(HTML Help\) files.
Note that .chm files are viewable on Unix systems via an
application called xCHM; see http://xchm.sourceforge.net/"
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-chm-viewer-args ""
  "*Arguments passed to .chm viewing program.
Note: Make sure the final argument is followed by a space;
that is, if the value of this option is a non-empty string,
put a space at the end of it."
  :type 'string
  :group 'docbook-menu
  :require 'docbk-menu
  )

(defcustom docbook-menu-tdg-use-unexpanded-flag t
  "*Non-nil means show unexpanded TDG files.
DocBook: The Definitive Guide comes in two flavors: one in which the
parameter entities in content models have been 'expanded' \(that's
probably the version you're accustomed to seeing\), and one in which
the parameter entites are left unexpanded.  Toggle this option to see
the two different versions."
  :set #'(lambda (symbol on)
           (setq docbook-menu-tdg-use-unexpanded-flag on)
           (if on
	       (setq docbook-menu-tdg-additional-suffix "-x")
	     (setq docbook-menu-tdg-additional-suffix "")
	       )
	   )
  :type 'boolean
  :group 'docbook-menu
  :require 'docbk-menu
  )

;; *******************************************************************
;; end of user customizable options
;; *******************************************************************

(add-hook 'docbook-menu-mode-hook
	  ;;create the actual DocBook menu using easy-menu
	  '(lambda ()
	     (easy-menu-define
	       docbook-menu-menu
	       docbook-menu-mode-map
	       "Easy menu command/variable for `docbook-menu-mode'."
	       docbook-menu-definition)
	     )
	  )

(setq menu-bar-final-items
      ;; keep DocBook menu on the right, close to Help menu
      (cons 'docbook-menu menu-bar-final-items))

(define-key-after menu-bar-help-menu [docbook-menu-show]
  ;; add "Show DocBook Menu" item to Help menu
  '(menu-item "Show DocBook Menu" docbook-menu-mode
	      :help "Toggle display of DocBook Menu"
	      :button (:toggle . (and (boundp 'docbook-menu-mode) docbook-menu-mode))
	      ;; hide if 'suppress' flag is set
	      :visible (not docbook-menu-suppress-from-help-menu-flag)
	      )
  nil)

(provide 'docbk-menu)

;;; docbk-menu.el ends here
