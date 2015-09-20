;; doctoc-ext.el --- external parser module for doctoc

;; part of doctoc version 2.0

(require 'doctoc)
(require 'ffap)

;;; parser interface

(defun doctoc-ext-generate-toc (toc-buffer)
  "Run external command to generate toc in DOCTOC-TOC-BUFFER."
  (shell-command-on-region (point-min) (point-max)
			   doctoc-ext-toc-command toc-buffer)
  (if (buffer-live-p toc-buffer)
      (let ((doc-buffer (current-buffer)))
	(save-excursion
	  (set-buffer toc-buffer)
	  (doctoc-ext-parse doc-buffer)))
    (error "External command produced no output.")))

;;; internally used definitions

(defvar doctoc-ext-toc-command "toc.pl"
  "Command producing the toc to stdout from stdin docbook document")

(defvar doctoc-ext-line-number-regexp 
  "[^\n\r]*[ \t]:?\\([0-9]+\\)[\r\n]"
"Regexp for finding the next line number in toc.
Should also match in outline-minor-mode.
Eats up one character more that the line number.")

(defvar doctoc-ext-level-regexp
  (list
   '("^ *[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . 1)
   '("^ *[0-9]+\\.[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . 2)
   '("^ *[0-9]+\\.[0-9]+\\.[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . 3))
  "A list of cons cells (regexp . level) determining heading levels for doctoc buffers.
The regexp is matched with point at the beginning of a line
end extends to the line number given for that toc-entry.
The first matching regexp is used.")

(defun doctoc-ext-parse (document-buffer)
  "Parse buffer and set extents for highlighting/jumping in doctoc-mode"
  (goto-char 0)
  (let (bgn)
    (while (progn 
	     (beginning-of-line)
	     (setq bgn (point))
	     (re-search-forward doctoc-ext-line-number-regexp (point-max) t))
      (let* ((line-begin (match-beginning 1))
	     (line-end (match-end 1))
	     (line (string-to-int (buffer-substring line-begin line-end)))
	     (url nil)
	     (level nil)
	     (levels doctoc-ext-level-regexp)
	     (face nil)
	     (epos nil)
	     (upos nil))
	(save-excursion
	  (goto-char bgn)
	  (while (and levels (not level))
	    (if (looking-at (caar levels))
		(setq level (cdar levels))
	      (setq levels (cdr levels))))
	  (goto-char (1- line-begin))
	  (if (looking-at ":")
	      (progn
		(setq url (ffap-next-guess 'back bgn))
		(when url (setq upos (cons url line))))
	    (progn
	      (set-buffer document-buffer)
	      (goto-line line)
	      (setq epos (sgml-epos (point))))))
	(when level
	  (setq face (plist-get doctoc-level-faces level)))
	(doctoc-set-text-properties bgn (1- (point)) face epos upos)))
    (goto-char 0)))
	    
(setq doctoc-generate-function 'doctoc-ext-generate-toc)

(provide 'doctoc-ext)

