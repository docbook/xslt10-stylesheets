;; doctoc.el --- Handle table of contents for docbook

;; Copyright (C) 2001, 2002 Jens Emmerich <Jens.Emmerich@itp.uni-leipzig.de>
;; Version: 2.0
;; Keywords: wp, sgml, xml, docbook

;; Maintainer: Jens Emmerich

;; This file is neither part of GNU Emacs nor XEmacs.

;; This Program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; version 2.

;; This Program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs or XEmacs; see the file COPYING.  If not,
;; write to the Free Software Foundation Inc., 59 Temple Place - Suite
;; 330, Boston, MA 02111-1307, USA.

;;; Compatible with (at least): XEmacs 21.1, 21.4

;;; Commentary:

;; `doctoc' provides support for an interactive table of contents for
;; DocBook(x) documents using an external parser (toc.pl) or the psgml
;; parse tree. Currently, only the psgml-version is complete.

;; For the external parser it is quite general, it only (re-)starts a
;; process, pipes the current buffer through it and can jump to the
;; line given at the end of output lines. Unlike RefTeX, it only
;; handles the current buffer in this case.

;; Install into load-path and add something like
;;
;; (defun my-sgml-setup ()
;;   "Customize psgml for xml."
;;   (require 'doctoc-psgml) 
;;   ;; ... more customizations
;;   (define-key sgml-mode-map [(control c)(=)] 'doctoc-toc-current-line))
;;
;; (add-hook 'sgml-mode-hook 'my-sgml-setup)
;;
;; to your init.el (or .emacs) file.
;;
;; Keybindings are somewhat inspired by RefTeX:
;;
;;  'return close TOC buffer and jump to the selected entry
;;  'space  show buffer around selected entry
;;  'q      close TOC and return to where C-= left off
;;  'g      re-generate TOC
;;  [(shift button2)] show buffer around selected entry (same as 'space)
;;  [(shift button3)] show buffer around selected entry (same as 'space) 
;;  'button2  close TOC buffer and jump to the selected entry (as 'return)
;;  'button3  close TOC buffer and jump to the selected entry (as 'return)


;;; Code:

;; dependencies on psgml are entity-handling for parsing with an
;; external parser and additionally the parse-tree for the internal
;; (psgml-based) parser

(require 'psgml)

;;; Variables for customizations

(defvar doctoc-toc-buffer "*TOC %s*"
  "Buffer holding the toc for a docbook document")

(defvar doctoc-generate-function 'doctoc-psgml-generate-toc
  "Function to run to generate TOC.
It is called in the document buffer
with the TOC buffer as argument.")

;; Faces used for Highlighting

(make-face 'doctoc-level1-face)
(set-face-foreground 'doctoc-level1-face "red")
(make-face-bold 'doctoc-level1-face)
(make-face 'doctoc-level2-face)
(set-face-foreground 'doctoc-level2-face "blue")
(make-face-bold 'doctoc-level2-face)
(make-face 'doctoc-level3-face)
(set-face-foreground 'doctoc-level3-face "blue")

(defvar doctoc-level-faces
  (list
   0 'doctoc-level1-face
   1 'doctoc-level1-face
   2 'doctoc-level2-face
   3 'doctoc-level3-face)
  "A property list of level - face relations.")

;;; TOC generation / document buffer commands

(defun doctoc-toc ()
  "Create or select a table of contents for current (docbook-) buffer"
  (interactive)
  (when (and (boundp 'sgml-parent-document) sgml-parent-document)
    (find-file sgml-parent-document))
  (let
      ((buffer (get-buffer (format doctoc-toc-buffer (buffer-name)))))
    (if buffer
	(doctoc-select-toc buffer)
      (doctoc-make-toc))))

(defun doctoc-kill-toc ()
  "Delete toc buffer of current buffer, if any"
  (interactive)
  (let
      ((buffer (get-buffer (format doctoc-toc-buffer (buffer-name)))))
    (if buffer
	(kill-buffer buffer))))

(defun doctoc-regenerate ()
  "Regenerate visited table of contents"
  (interactive)
  (let
      ((toc-buffer (current-buffer))
       (line  (count-lines 1 (min (point-max) (1+ (point)))))
       (doc-buffer document-buffer))
    (message "Regenerating toc ... ")
    (setq buffer-read-only nil)
    (erase-buffer)
    (save-excursion
      (set-buffer doc-buffer)
      (funcall doctoc-generate-function toc-buffer))
    (goto-char (point-min))
    (insert (format "Table of Contents for %s\n\n" (buffer-name doc-buffer)))
    (doctoc-set-text-properties (point-min) (1- (point))
				(plist-get doctoc-level-faces 0) 0)
    (setq buffer-read-only t)
    (message "Regenerating toc ... done")
    (goto-line line)
    ;; strange, but recenter fixes a problem (only lines in current
    ;; window are displayed, otherwise goto-line has no effect)
    (recenter '(t))
    (sit-for 2)
    (message nil)))

(defun doctoc-make-toc ()
  "Generate a toc for the docbook-xml document in current buffer
Return the buffer holding the toc"
  (interactive)
  (let ((toc-buffer 
	 (get-buffer-create (format doctoc-toc-buffer (buffer-name))))
	(doc-buffer (current-buffer))
	(win-config (current-window-configuration)))
    (make-local-hook 'kill-buffer-hook)
    (add-hook 'kill-buffer-hook 'doctoc-kill-toc)
    (save-excursion
      (set-buffer toc-buffer)
      (setq buffer-disble-undo t)
      (setq buffer-read-only nil)
      (erase-buffer))
    (message "Generating toc ... ")
    (funcall doctoc-generate-function toc-buffer)
    (switch-to-buffer-other-window toc-buffer)
    (goto-char (point-min))
    (insert (format "Table of Contents for %s\n\n" (buffer-name doc-buffer)))
    (doctoc-set-text-properties (point-min) (point)
				(plist-get doctoc-level-faces 0) 0)
    (doctoc-mode)
    (make-local-variable 'document-buffer)
    (make-local-variable 'window-configuration)
    (setq document-buffer doc-buffer
	  window-configuration win-config)
    (message "Generating toc ... done")
    (sit-for 2)
    (message nil)
    toc-buffer))

(defun doctoc-select-toc (buffer)
  "Jump to the toc in BUFFER"
  (let ((win-config (current-window-configuration)))
    (pop-to-buffer buffer)
    (setq window-configuration win-config)))

;;; TOC buffer commands

(defun doctoc-back ()
  "Leave doctoc buffer and switch back to buffer 'doc-buffer"
  (interactive)
  (let ((dest-buffer document-buffer))
    (set-window-configuration window-configuration)
    (switch-to-buffer dest-buffer)))

(defun doctoc-goto-epos-toc (epos)
  "Search EPOS in toc and move point to it.
Goto first line in toc where title epos <= EPOS."
  (let ((pos
	 (map-extents 'doctoc-compare-extent nil nil nil epos)))
    (goto-char
     (if pos pos (point-max)))))
	
(defun doctoc-compare-extent (extent epos)
  "Return start of extent if epos property is not after EPOS"
  (let ((tocentry-epos (extent-property extent 'epos)))
    (if tocentry-epos
	(if (<= (sgml-epos-before tocentry-epos) (sgml-epos-before epos))
	    (extent-start-position extent)
	  nil)
      nil)))
  
(defun doctoc-toc-current-line ()
  "Goto toc entry corresponding to point"
  (interactive)
  (let ((epos (sgml-epos (point))))
    (doctoc-toc)
    (doctoc-goto-epos-toc epos)))

(defun doctoc-find-epos ()
  "Return epos of toc entry at point."
  (let ((extent (extent-at (point) nil 'epos)))
    (if extent
	(extent-property extent 'epos)
      nil)))

(defun doctoc-find-upos ()
  "Return upos of toc entry at point."
  (let ((extent (extent-at (point) nil 'upos)))
    (if extent
	(extent-property extent 'upos)
      nil)))

(defun doctoc-jump ()
  "Jump to position pointed to by current toc entry."
  (interactive)
  (let ((epos (doctoc-find-epos))
	(upos (doctoc-find-upos)))
    (cond
     (epos (set-window-configuration window-configuration)
	   (doctoc-goto-epos epos))
     (upos (set-window-configuration window-configuration)
	   (doctoc-goto-upos upos))
     (t    (message "No toc entry at point.")))))

(defun doctoc-jump-mouse ()
  (interactive)
  (goto-char (event-closest-point current-mouse-event))
  (doctoc-jump))

(defun doctoc-show ()
  "Show the line given by the number at eol 'doc-buffer in other window"
  (interactive)
  (let 
      ((epos (doctoc-find-epos))
       (upos (doctoc-find-upos)))
    (when (or epos upos)
      (let ((extent
	     (progn 
	       (save-selected-window
		 (switch-to-buffer-other-window document-buffer)
		 (if epos
		     (doctoc-goto-epos epos)
		   (doctoc-goto-upos upos))
		 (recenter '(t))
		 (doctoc-highlight-title)))))
	(if (extentp extent)
	    (let ((inhibit-quit t))
	      (sit-for 4e4)		; 'for-e-ver'
	      (delete-extent extent))
	  (message "Can't find title, regenerate TOC!"))))))

(defun doctoc-show-mouse ()
  "Show the line given by the number at eol 'doc-buffer in other window
The title is shown as long as the button is pressed"
  (interactive)
  (goto-char (event-closest-point current-mouse-event))
  (let 
      ((epos (doctoc-find-epos))
       (upos (doctoc-find-upos)))
    (when (or epos upos)
      (save-window-excursion
	(let ((extent
	       (progn 
		 (switch-to-buffer-other-window document-buffer)
		 (if epos
		     (doctoc-goto-epos epos)
		   (doctoc-goto-upos upos))
		 (recenter '(t))
		 (doctoc-highlight-title))))
	  (if (extentp extent)
	      (let ((inhibit-quit t))
		(sit-for 4e4)		; 'for-e-ver'
		(delete-extent extent))
	    (message "Can't find title, regenerate TOC!")))))))
   

(defun doctoc-highlight-title ()
  "Highlight next title in document buffer
Highlight next title at/after current line and return extent.
Return nil if no title was found."
  (let* ((tstart (save-excursion
		   (beginning-of-line)
		   (cond
		    ((re-search-forward "<title[^>]*>" (min (point-max) (+ (point) 1000)) t)
		     (match-end 0))
		    ((re-search-backward "<title[^>]*>" (max (point-min) (- (point) 1000)) t)
		     (match-end 0))
		    (t nil))))
	 (tend (cond
		(tstart
		 (goto-char tstart)
		 (and (re-search-forward "</title>" (point-max) t)
		      (match-beginning 0)))
		(t nil))))
    (when (and tstart tend)
      (let ((extent (make-extent tstart tend)))
	(set-extent-face extent 'highlight)
	extent))))

(defun doctoc-goto-epos (epos)
  "Goto a position in an entity given by EPOS.
Opens the file in case of an external entity."
  (assert epos)
  (cond ((sgml-bpos-p epos)
	 (goto-char epos))
	(t
	 (let* 
	     ((eref (sgml-epos-eref epos))
	      (entity (sgml-eref-entity eref))
	      (file (if (consp (sgml-entity-text entity))
			(sgml-external-file (sgml-entity-text entity)
					    (sgml-entity-type entity)
					    (sgml-entity-name entity))
		      nil)))
	   (cond (file
		  (find-file file)
		  (goto-char (sgml-epos-pos epos)))
		 (t
		  (sgml-goto-epos epos)
		  (switch-to-buffer (current-buffer))))))))

(defun doctoc-goto-upos (upos)
  "Goto a position in an entity referenced by UPOS.
UPOS is defined as (URL.LINE)"
  (assert (consp upos))
  (require 'ffap)
  (find-file-at-point (car upos))
  (goto-line (cdr upos)))

;;; Major mode definition
	      
(defvar doctoc-mode-map
   (let ((m (make-sparse-keymap)))
	(set-keymap-name m 'doctoc-mode-map)
	(define-key m 'return 'doctoc-jump)
	(define-key m 'space 'doctoc-show)
	(define-key m 'q 'doctoc-back)
	(define-key m 'g 'doctoc-regenerate)
	(define-key m [(shift button2)] 'doctoc-show-mouse)
	(define-key m [(shift button3)] 'doctoc-show-mouse)
	(define-key m 'button2 'doctoc-jump-mouse)
	(define-key m 'button3 'doctoc-jump-mouse)
	m)
	"Keymap for doctoc mode")


(defun doctoc-mode ()
  "Major mode for visiting a table of contents containing line numbers
The buffer refereced by the line numbers is given by document-buffer.
This variable should be buffer-local.

Commands are:
\\{doctoc-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (setq buffer-read-only t)
  (use-local-map doctoc-mode-map)
  (setq major-mode 'doctoc-mode)
  (setq mode-name "doctoc")
  (setq truncate-lines t)
  ;; length of match defines level => also match spaces
  (when (featurep 'outline)
    (setq outline-regexp "^\\([0-9]+\\(\\.[0-9]+\\)*\\)? +\\b")
    (outline-minor-mode 1))
  ;; turn off horizontal scrollbars in this buffer
  ;; toc.pl produces short enough lines
  (when (featurep 'scrollbar)
    (set-specifier scrollbar-height (cons (current-buffer) 0)))
  (setq indent-tabs-mode nil)
  (run-hooks 'doctoc-mode-hook))

;;; Extent handling
;; This is probably stronly XEmacs dependent

(defun doctoc-set-text-properties (start end &optional title-face epos upos)
  "Make extent from START to END, set FACE and jump-destination EPOS or UPOS.
EPOS is as defined in psgml-parse.el
UPOS is (URL . line)"
  (let ((title-extent (make-extent start end)))
    (set-extent-property title-extent 'start-open t)
    (set-extent-property title-extent 'end-open t)
    (when epos
      (set-extent-property title-extent 'epos epos))
    (when upos
      (set-extent-property title-extent 'upos upos))
    (when title-face
      (set-extent-face title-extent title-face))
    (set-extent-mouse-face title-extent 'highlight)))

(provide 'doctoc)