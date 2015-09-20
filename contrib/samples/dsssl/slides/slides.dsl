<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA DSSSL>
]>

<style-specification id="docbook-slides-print" use="docbook">

(define %visual-acuity% "my")
(define %paper-type% "A4")

(define %body-start-indent% 0pi)
(define %verbatim-size-factor% 0.95)

(define %callout-default-col% 70)

(element property ($mono-seq$))

(define %bf-size%
  ;; Defines the body font size
  (case %visual-acuity%
    (("tiny") 8pt)
    (("normal") 10pt)
    (("eleven") 11pt)
    (("my") 13.5pt)
    (("presbyopic") 12pt)
    (("large-type") 24pt)))

(define %body-font-family% "Verdana")
(define %title-font-family% "Verdana")

(define preferred-mediaobject-extensions
  (list "wmf" "eps" "ps" "jpg" "jpeg" "png"))

(define preferred-mediaobject-notations
  (list "WMF" "EPS" "PS" "JPG" "JPEG" "PNG" "linespecific"))

(element slides
  (make simple-page-sequence
    page-n-columns: %page-n-columns%
    page-number-format: ($page-number-format$)
    use: default-text-style
    left-header:   ($left-header$)
    center-header:  (literal "")
    right-header:  ($right-header$)
;;    left-footer:   (literal (data (select-elements (children (select-elements (children (current-node)) (normalize "slidesinfo"))) (normalize "title"))))
    left-footer: ($left-footer$)
    center-footer: ($center-footer$)
;;    right-footer:  ($right-footer$)
    right-footer: (literal "")
    start-indent: %body-start-indent%
    input-whitespace-treatment: 'collapse
    quadding: %default-quadding%
    (process-children)))

(element slidesinfo
  (make sequence
    quadding: 'center
  (process-children)))

(element (slidesinfo author)
  (make paragraph
    quadding: 'center
    space-before: 96pt
    space-after: 96pt
  (next-match)
  (process-node-list (select-elements (children (current-node)) (normalize "email") ))))

(element (slidesinfo author email)
  (make paragraph
    (process-children)))

(element (slidesinfo confgroup)
  (make paragraph
    quadding: 'center
    space-before: 16pt
    (next-match)))

(element (confdates)
  (make paragraph
    (next-match)))

(element (slidesinfo copyright)
  (make paragraph
    space-before: 242pt
    font-size: 10pt
    (next-match)))

(element (slidesinfo releaseinfo)
  (make paragraph
    font-size: 10pt
    (process-children)))

(element (slidesinfo title)
  (let* ((renderas (attribute-string "renderas"))
	 (hlevel 0)                   
	 (hs (HSIZE (- 4 hlevel))))
    (make paragraph
      font-family-name: %title-font-family%
      font-weight:  (if (< hlevel 5) 'bold 'medium)
      font-posture: (if (< hlevel 5) 'upright 'italic)
      font-size: hs
      line-spacing: (* hs %line-spacing-factor%)
      space-before: (* hs %head-before-factor%)
      space-after: (* hs %head-after-factor%)
      start-indent: (if (< hlevel 3)
			0pt
			%body-start-indent%)
      first-line-start-indent: 0pt
      quadding: 'center
      keep-with-next?: #t
      (process-children))))

(element (slidesinfo subtitle)
  (let* ((renderas (attribute-string "renderas"))
	 (hlevel 2)                   
	 (hs (HSIZE (- 4 hlevel))))
    (make paragraph
      font-family-name: %title-font-family%
      font-weight:  (if (< hlevel 5) 'bold 'medium)
      font-posture: (if (< hlevel 5) 'upright 'italic)
      font-size: hs
      line-spacing: (* hs %line-spacing-factor%)
      space-before: (* hs %head-before-factor%)
      space-after: (* hs %head-after-factor%)
      start-indent: (if (< hlevel 3)
			0pt
			%body-start-indent%)
      first-line-start-indent: 0pt
      quadding: 'center
      keep-with-next?: #t
      (process-children))))
  

(element foil
;;  (make paragraph
;;    break-before: 'page
  (make simple-page-sequence
    page-n-columns: %page-n-columns%
    page-number-format: ($page-number-format$)
    use: default-text-style
    left-header:   (literal (data (select-elements (children (parent (current-node))) (normalize "title"))))
    center-header: ($center-header$)
    right-header:  (literal (data (select-elements (children (current-node)) (normalize "title"))))
    left-footer:   (literal (data 
			     (select-elements
			      (children
			       (select-elements
				(children
				 (select-elements 
				  (parent
				   (select-elements 
				    (parent (current-node)) 
				    (normalize "foilgroup"))) 
				  (normalize "slides")))
				(normalize "slidesinfo")))
			      (normalize "title"))))
    center-footer: ($center-footer$)
    right-footer:  (literal (format-number (element-number (current-node)) "1"))
    start-indent: %body-start-indent%
    input-whitespace-treatment: 'collapse
    quadding: %default-quadding%
    (process-children)))

(element (foil title)
  (let* ((renderas (attribute-string "renderas"))
	 (hlevel 1)                   
	 (hs (HSIZE (- 4 hlevel))))
    (make paragraph
      font-family-name: %title-font-family%
      font-weight:  (if (< hlevel 5) 'bold 'medium)
      font-posture: (if (< hlevel 5) 'upright 'italic)
      font-size: hs
      line-spacing: (* hs %line-spacing-factor%)
      ;; space-before: (* hs %head-before-factor%)
      space-after: (* hs %head-after-factor%)
      start-indent: (if (< hlevel 3)
			0pt
			%body-start-indent%)
      first-line-start-indent: 0pt
      quadding: 'center
      keep-with-next?: #t
      (process-children))))

(element (foil subtitle)
  (let* ((renderas (attribute-string "renderas"))
	 (hlevel 2)                   
	 (hs (HSIZE (- 4 hlevel))))
    (make paragraph
      font-family-name: %title-font-family%
      font-weight:  (if (< hlevel 5) 'bold 'medium)
      font-posture: (if (< hlevel 5) 'upright 'italic)
      font-size: hs
      line-spacing: (* hs %line-spacing-factor%)
      space-before: (* hs %head-before-factor%)
      space-after: (* hs %head-after-factor%)
      start-indent: (if (< hlevel 3)
			0pt
			%body-start-indent%)
      first-line-start-indent: 0pt
      quadding: 'center
      keep-with-next?: #t
      (process-children))))

(element foilgroup
  (process-children))

(element (foilgroup title)
  (empty-sosofo))

(define (named-formal-objects)
  (list (normalize "equation")))

</style-specification>

<external-specification id="docbook" document="docbook.dsl">


