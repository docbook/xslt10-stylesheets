;;; dbk-wiki.el --- List of DocBook Wiki pages
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-wiki
    (list "DocBook Wiki"
	      ["DocBook"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBook")) t]
	      ["Documentation"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookDocumentation")) t]
	      ["Help"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookHelp")) t]
	      ["Tutorials"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookTutorials")) t]
	      ["Websites"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookWebsites")) t]
	      ["Discussion"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookDiscussion")) t]
	      ["--" t]
	      ["Authoring Tools"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookAuthoringTools")) t]
	      ["Publishing Tools"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookPublishingTools")) t]
	      ["Conversion Tools"
	       (browse-url (concat docbook-menu-wiki-base-uri "/ConvertOtherFormatsToDocBook")) t]
	      ["Convenience Tools"
	       (browse-url (concat docbook-menu-wiki-base-uri "/ConvenienceTools")) t]
	      ["Packages"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookPackages")) t]
	      ["---" t]
	      ["What?"
	       (browse-url (concat docbook-menu-wiki-base-uri "/WhatIsDocBookUsedFor")) t]
	      ["Who?"
	       (browse-url (concat docbook-menu-wiki-base-uri "/WhoUsesDocBook")) t]
	      ["Why?"
	       (browse-url (concat docbook-menu-wiki-base-uri "/WhyDocBook")) t]
	      ["History"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookHistory")) t]
	      ["Future"
	       (browse-url (concat docbook-menu-wiki-base-uri "/DocBookFuture")) t]
	      ["Shortcomings"
	       (browse-url (concat docbook-menu-wiki-base-uri "/WhatIsWrongWithDocBook")) t]
	      )
    "DocBook Wiki submenu for 'docbook-menu'."
  )
