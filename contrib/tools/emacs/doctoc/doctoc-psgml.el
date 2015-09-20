;; doctoc-psgml.el --- PSGML's parser module for doctoc

;; part of doctoc version 2.0

(require 'doctoc)
(require 'psgml)

;;; parser interface

(defun doctoc-psgml-generate-toc (toc-buffer)
  "Insert TOC for document in current psgml parse tree."
  (interactive)
  (unless (fboundp 'sgml-top-element)
    (error "Need PSGML-mode for TOC."))
  (sgml-parse-to (point-max))
  (message nil)
  (doctoc-psgml-traverse (sgml-top-element) 0 toc-buffer))

;;; internally used definitions

(defun doctoc-psgml-traverse (element level toc-buffer)
  "Insert TOC for subtree ELEMENT on LEVEL."
  (let ((c (sgml-element-content element)))
    (while c
      (if (member (downcase (sgml-element-gi c)) '("title" "refname" "refdescriptor"))
	  (doctoc-psgml-handle-title c level toc-buffer)
	(doctoc-psgml-traverse c (+ 1 level) toc-buffer))
      (setq c (sgml-element-next c)))))
    
(defun doctoc-psgml-handle-title (element level toc-buffer)
  "Generate TOC entry for ELEMENT on LEVEL.
Tests if LEVEL is correct, i.e. parent is not .*info.
If it is, level is decremented."
  (save-excursion
    (let* ((epos (sgml-element-stag-epos element))
	   (bgn (progn
		  (sgml-goto-epos epos)
		  (forward-char (sgml-element-stag-len element))
		  (skip-chars-forward " \t\n\r")
		  (point)))
	   (end (progn
		  (sgml-goto-epos (sgml-element-etag-epos element))
		  (skip-chars-backward " \t\n\r")
		  (point)))
	   (toc-text (buffer-substring-no-properties bgn end))
	   (line (count-lines (point-min) bgn))
	   (parent (sgml-element-parent element))
	   (infoelement (or (string-match "info$" (sgml-element-gi parent))
			    (member (downcase (sgml-element-gi parent))
				    '("title" "refname" "refdescriptor"))))
	   (sect-level (if infoelement (1- level) level))
	   (sect-element (if infoelement (sgml-element-parent parent) parent))
	   (indent (* 3 (1- sect-level)))
	   bor)
      (setq toc-text (doctoc-psgml-effective-text toc-text sect-element))
      (unless (not toc-text)
	(set-buffer toc-buffer)
	(setq bor (point))
	(setq left-margin indent)
	(insert toc-text)
	(unless (sgml-bpos-p epos)
	    (insert " [entity " 
		    (sgml-entity-name (sgml-eref-entity (sgml-epos-eref epos)))
		    "]"))
	(fill-region-as-paragraph bor (point))
	(skip-chars-backward " \t\n\r")
	(when (> (current-column) 72)
	  (newline))
	(insert " ")
	(insert (make-string (- 73 (current-column)) ?\.))
	(insert (format "%5i\n" line))
	(doctoc-set-text-properties bor (point)
				    (plist-get doctoc-level-faces sect-level)
				    epos)
	(when (= sect-level 0) (insert "\n"))
	))))

(defvar doctoc-psgml-format
  '("figure" "· Fig: "
    "table"  "· Tab: ")
  "Property list controlling TOC display.
The CAR is the GI of the identifier.
The CDR is
 'nil if the TOC text needs no modification
    This is the default if no entry matches.
 't if there should be no TOC entry
 STRING if the entry is to be prefixed with STRING.")

(defun doctoc-psgml-effective-text (text element)
  (let* ((gi (downcase (sgml-element-gi parent)))
	 (format (lax-plist-get doctoc-psgml-format gi)))
    (cond 
     ((not format) text)
     ((stringp format) (concat format text))
     (t nil))))

(setq doctoc-generate-function 'doctoc-psgml-generate-toc)

(provide 'doctoc-psgml)