;; doctoc.el --- Handle table of contents for docbook

;; Copyright (C) 2001, 2002 Jens Emmerich <Jens.Emmerich@itp.uni-leipzig.de>
;; Version: 1.3
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

;; This file provides support for am interactive table of contents for
;; docbook(x) documents using an external parser (toc.pl). In fact it
;; is quite general, it only (re-)starts a process, pipes the current
;; buffer through it and can jump to the line given at the end of the
;; line. Unlike RefTeX, it only handles the current buffer.

;; Install into load-path and add something like
;;
;; (defun my-sgml-setup ()
;;   "Customize psgml for xml."
;;   (load "doctoc") 
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


(defvar doctoc-toc-buffer "*TOC %s*"
  "Buffer holding the toc for a docbook document")

(defvar doctoc-toc-command "toc.pl 2> /dev/null"
  "Command producing the toc to stdout from stdin docbook document")

(defvar doctoc-line-number-regexp 
  "[^\n\r]* \\([0-9]+\\)[\r\n]"
"Regexp for finding the next line number in toc.
Should also match in outline-minor-mode.")

(defun doctoc-toc ()
  "Create or select a table of contents for current (docbook-) buffer"
  (interactive)
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
      (shell-command-on-region (point-min) (point-max)
			       doctoc-toc-command toc-buffer))
    (doctoc-make-extents)
    (setq buffer-read-only t)
    (message "Regenerating toc ... done")
    (goto-line line)
    ;; strange, but recenter fixes a problem (only lines in current
    ;; window are displayed, otherwise goto-line has no effect)
    (recenter '(t))
    (sit-for 4e4 t)
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
    (shell-command-on-region (point-min) (point-max)
			     doctoc-toc-command toc-buffer)
    (switch-to-buffer-other-window toc-buffer)
    (doctoc-mode)
    (make-local-variable 'document-buffer)
    (make-local-variable 'window-configuration)
    (setq document-buffer doc-buffer
	  window-configuration win-config)
    (doctoc-make-extents)
    (message "Generating toc ... done")
    (sit-for 4e4)
    (message nil)
    toc-buffer))

(defun doctoc-select-toc (buffer)
  "Jump to the toc in BUFFER"
  (let ((win-config (current-window-configuration)))
    (pop-to-buffer buffer)
    (setq window-configuration win-config)))

(defun doctoc-back ()
  "Leave doctoc buffer and switch back to buffer 'doc-buffer"
  (interactive)
  (let ((dest-buffer document-buffer))
    (set-window-configuration window-configuration)
    (switch-to-buffer dest-buffer)))

(defun doctoc-find-line ()
  "Search for next line number as given by 'doctoc-line-number-regexp
Line number is returned, nil if not found. Keep point."
  (save-excursion
    (doctoc-find-line-move)))

(defun doctoc-find-line-move ()
  "Search for next line number as given by 'doctoc-line-number-regexp
Line number is returned, nil if not found. Point is left at beginning
of matching line."
  (beginning-of-line)
  (while (not (or (looking-at doctoc-line-number-regexp) (eobp)))
    (forward-line))
  (if (looking-at doctoc-line-number-regexp)
      (string-to-int (buffer-substring
		      (match-beginning 1) (match-end 1)))
    nil))

(defun doctoc-goto-line-toc (line)
  "Search LINE in toc and move point to it.
Goto first line where line number at end <= LINE."
  (while
      (let
	  ((found-line (doctoc-find-line-move)))
	(and found-line (< found-line line) (not (eobp))))
    (forward-line)))
	
(defun doctoc-toc-current-line ()
  "Goto toc entry corresponding to point"
  (interactive)
  (let ((goal-line (line-number)))
    (doctoc-toc)
    (doctoc-goto-line-toc goal-line)))

(defun doctoc-jump ()
  "Jump back to line given by the number at eol to buffer 'doc-buffer"
  (interactive)
  (let ((dest-buffer document-buffer)
	(lineno (doctoc-find-line)))
    (if lineno
	(progn
	  (set-window-configuration window-configuration)
	  (switch-to-buffer dest-buffer)
	  (goto-line lineno))
      (message "No toc entry at point."))))

(defun doctoc-jump-mouse ()
  (interactive)
  (goto-char (event-closest-point current-mouse-event))
  (doctoc-jump))
   
(defun doctoc-show ()
  "Show the line given by the number at eol 'doc-buffer in other window"
  (interactive)
  (let 
      ((lineno (doctoc-find-line)))
    (if lineno
	(let ((extent
	       (progn 
		 (save-selected-window
		   (switch-to-buffer-other-window document-buffer)
		   (goto-line lineno)
		   (recenter '(t))
		   (doctoc-highlight-title)))))
	  (if (extentp extent)
	      (let ((inhibit-quit t))
		(sit-for 4e4)		; 'for-e-ver'
		(delete-extent extent)))))))

(defun doctoc-show-mouse ()
  "Show the line given by the number at eol 'doc-buffer in other window
The title is shown as long as the button is pressed"
  (interactive)
  (goto-char (event-closest-point current-mouse-event))
  (let 
      ((lineno (doctoc-find-line)))
    (if lineno
	(save-window-excursion
	  (let ((extent
		 (progn 
		   (switch-to-buffer-other-window document-buffer)
		   (goto-line lineno)
		   (recenter '(t))
		   (doctoc-highlight-title))))
	    (if (extentp extent)
		(let ((inhibit-quit t))
		  (sit-for 4e4)		; 'for-e-ver'
		  (delete-extent extent))))))))
   
;; highlight next title at/after current line and return extent
;; return nil if no title was found
(defun doctoc-highlight-title ()
  (let ((tstart (progn 
		  (beginning-of-line)
		  (if (re-search-forward "<title[^>]*>" (point-max) t)
		      (match-end 0)
		    nil))))
    (if tstart
	(progn
	  (goto-char tstart)
	  (if (re-search-forward "</title>" (point-max) t)
	      (let ((extent 
		     (make-extent tstart (match-beginning 0))))
		(set-extent-face extent 'highlight)
		extent))))))

	      
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
  (setq outline-regexp "^[0-9]+\\(\\.[0-9]+\\)* +\\b")
  (outline-minor-mode 1)
  ;; turn off horizontal scrollbars in this buffer
  ;; toc.pl produces short enough lines
  (when (featurep 'scrollbar)
    (set-specifier scrollbar-height (cons (current-buffer) 0)))
  (run-hooks 'doctoc-mode-hook))

;;; Faces used for Highlighting

(make-face 'doctoc-level1-face)
(set-face-foreground 'doctoc-level1-face "red")
(make-face-bold 'doctoc-level1-face)
(make-face 'doctoc-level2-face)
(set-face-foreground 'doctoc-level2-face "blue")
(make-face-bold 'doctoc-level2-face)
(make-face 'doctoc-level3-face)
(set-face-foreground 'doctoc-level3-face "blue")

;; 'doctoc-level-faces a la font-lock-keywords 
(defvar doctoc-level-faces
  (list
   '("^ *[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . doctoc-level1-face)
   '("^ *[0-9]+\\.[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . doctoc-level2-face)
   '("^ *[0-9]+\\.[0-9]+\\.[0-9]+ +\\(.*[^0-9]\n\\)*.*[0-9]$" . doctoc-level3-face))
  "A list of cons cells (regexp . face) determining faces for doctoc buffers
The regexp is matched at the beginning of a line end extends
to the line number given for that toc-entry. The first
matching regexp is used.")

;;;; Extent handling
;;; This is probably stronly XEmacs dependent

;; parse buffer and set extents for highlighting
(defun doctoc-make-extents ()
  (goto-char 0)
  (while (not (eobp))
    (let ((bgn (progn
		 (beginning-of-line)
		 (point)))
	  (end (progn
		 (re-search-forward doctoc-line-number-regexp (point-max) t)
		 (re-search-backward "\\>" (point-min) t))))
      (doctoc-set-text-properties bgn end)
      (forward-line)))
  (goto-char 0))
	    
;; make extent from start to end and set face according
;; to doctoc-level-faces
(defun doctoc-set-text-properties (start end)
  (let ((title-extent (make-extent start end))
	(faces doctoc-level-faces)
	(face nil))
      (save-excursion
	(goto-char start)
	(while (and faces (not face))
	  (if (looking-at (caar faces))
	      (setq face (cdar faces))
	    (setq faces (cdr faces)))))
      (set-extent-property title-extent 'start-open t)
      (set-extent-property title-extent 'end-open t)
      (set-extent-face     title-extent (or face 'default))
      (set-extent-mouse-face title-extent 'highlight)))
