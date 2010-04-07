
(in-package :resty-weblocgks)

(defun init-user-session (comp)
  "callback function to initialize new sessions"
  (let ((menu (make-instance 'nunb-menu-ish-post-overview)))
    (setf (composite-widgets comp)
	(make-instance 'nunb-blog-toplevel :menu-widget menu))))

(defwidget nunb-blog-toplevel (on-demand-selector)
  ((menu-widget :initarg :menu-widget :documentation "Show a menu-standin .. TODO"))
  (:default-initargs :lookup-function #'blog-selector-choose-post)
  (:documentation
   "A toplevel dispatcher that should a) Render the post (or
    collection of posts) searched-for/arrived-at via REST url, b)
    Render some kind of menu-ish sidebar listing posts by date, author
    and tags"))

(defwidget nunb-menu-ish-post-overview ()
  ()
  (:documentation
   "List current list of tags, authors, and an archive
    arranged by date.  Simple right now, but can be fancied up with
    javascript-ish dropdowns etc."))

(defmethod blog-selector-choose-post (selector tokens)
  "Given the selector and a set of tokens, return the blog post, or carp if not found.
   Because of the way the toplevel is called, it will also  be the resp. of this fn. to
   return a menu-ish widget that shows what url paths are available (ie the monthly archive
   sidebar that most blogs have). We'll start with english, and as an exercise see how hard
   it would be to add other languages."
  ;;(break (format nil "TOKENS ~{~S, ~} ~%" tokens))
  (cond
    ((equal (first tokens) "tags")
     (values (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
						      (with-html (:div "Search posts by tags"))))
	     tokens nil))
    ((equal (first tokens) "author")
          (values (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
						      (with-html (:div "Search posts by author"))))
	     tokens nil))
    (t ;; Handle year/month/date and year/month/title
     (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
						      (with-html (:div "Fell through to year/month/date and year/month/title case"))))
     ))
  )


;; Utility fn.s

(defun all-of (type)
  "Accepts an argument symbol, finds stored objects of that type"
  (declare (ignore arg))
  (find-persistent-objects (class-store type) type :order-by (cons 'name :asc)))

(defun all-of-and-subtypes (class)
  "Get all entitites (was companies) of this type and subtypes"
  (loop for classname in (cons class (mapcar #'class-name (moptilities:subclasses (find-class class)))) 
	     nconc (find-persistent-objects (class-store 'class) classname)))

;; Model classes

(defclass* tagged-item ()
  ((tags :documentation "Use tags")))

(defclass* nunb-post (post)
  ((ts :documentation "I like timestamps")))

