;;; dbk-tdg.el --- List of TDG chapters
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-tdg-toc
    (list "DocBook: The Definitive Guide"
	  ["Buy the Book"
	   (browse-url "http://www.oreilly.com/catalog/docbook/") t]
	  ["--" t]
	  ["Preface"
	   (browse-url (concat docbook-menu-tdg-base-uri "/ch00" docbook-menu-tdg-additional-suffix ".html")) t]
    (list "I. Introduction"
	  ["1. Getting Started with SGML/XML"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ch01" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["2. Creating DocBook Documents"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ch02" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["3. Parsing DocBook Documents"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ch03" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["4. Publishing DocBook Documents"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ch04" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["5. Customizing DocBook"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ch05" docbook-menu-tdg-additional-suffix ".html")) t]
	  )
    (list "II. Reference"
	  ["I. DocBook Element Reference"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ref-elements" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["II. DocBook Parameter Entity Reference"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ref-paraments" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["III. DocBook Character Entity Reference"
	  (browse-url (concat docbook-menu-tdg-base-uri "/ref-charents" docbook-menu-tdg-additional-suffix ".html")) t]
	  )
    (list "III. Appendixes"
	  ["A. Installation"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appa" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["B. DocBook and XML"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appb" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["C. DocBook Versions"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appc" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["D. Resources"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appd" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["E. What's on the CD-ROM?"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appe" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["F. Interchanging DocBook Documents"
	  (browse-url (concat docbook-menu-tdg-base-uri "/appf" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["G. DocBook Quick Reference"
	  (browse-url (concat docbook-menu-tdg-base-uri "/quickref" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["H. GNU Free Documentation License"
	  (browse-url (concat docbook-menu-tdg-base-uri "/aph" docbook-menu-tdg-additional-suffix ".html")) t]
	  ["I. ChangeLog"
	  (browse-url (concat docbook-menu-tdg-base-uri "/api" docbook-menu-tdg-additional-suffix ".html")) t]
	  )
    ["Glossary" (browse-url (concat docbook-menu-tdg-base-uri "/dbgloss" docbook-menu-tdg-additional-suffix ".html")) t]
    ["Index" (browse-url (concat docbook-menu-tdg-base-uri "/ix01" docbook-menu-tdg-additional-suffix ".html")) t]
    
    )
    "TDG submenu for 'docbook-menu'."
    )