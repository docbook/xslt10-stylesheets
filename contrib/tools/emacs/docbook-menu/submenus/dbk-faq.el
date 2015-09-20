;;; dbk-faq.el --- List of DocBook FAQ sections
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$


(defvar docbook-menu-faq
  (list "DocBook FAQ"
	      ["Basics and References"
	       (browse-url (concat docbook-menu-faq-base-uri "/reference.html")) t]
	      ["XSLT Stylesheets"
	       (browse-url (concat docbook-menu-faq-base-uri "/styling/styling.html")) t]
	      ["Markup"
	       (browse-url (concat docbook-menu-faq-base-uri "/markup.html")) t]
	      ["Tools"
	       (browse-url (concat docbook-menu-faq-base-uri "/tools.html")) t]
	      ["Catalogs"
	       (browse-url (concat docbook-menu-faq-base-uri "/catalogs.html")) t]
	      ["Ant"
	       (browse-url (concat docbook-menu-faq-base-uri "/ant.html")) t]
	      ["DSSSL"
	       (browse-url (concat docbook-menu-faq-base-uri "/dsssl/dsssl.html")) t]
	      ["Thanks Norm"
	       (browse-url (concat docbook-menu-faq-base-uri "/tksnorm.html")) t]
	      )
  "DocBook FAQ submenu for 'docbook-menu'."
  )