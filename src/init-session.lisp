(in-package :resty-weblocgks)

;; navigation

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

(defmethod initialize-instance :after ((w nunb-blog-toplevel) &rest args)
  (with-slots (menu-widget) w
    (setf menu-widget (make-instance 'nunb-menu-ish-post-overview))))

(defmethod blog-selector-choose-post (selector tokens)
  "Given the selector and a set of tokens, return the blog post, or carp if not found.
   Because of the way the toplevel is called, it will also  be the resp. of this fn. to
   return a menu-ish widget that shows what url paths are available (ie the monthly archive
   sidebar that most blogs have). We'll start with english, and as an exercise see how hard
   it would be to add other languages."
  ;;(break (format nil "TOKENS ~{~S, ~} ~%" tokens))
  (with-slots (menu-widget) selector
    (let ((menu-renderer (f_% (render-widget menu-widget))))
      (cond
	((equal (first tokens) "tags")
	 (values (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
								  (with-html (:div "Search posts by tags"))))
		 tokens nil))
	((equal (first tokens) "author")
	 (values (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
								  (with-html (:div "Search posts by author"))))
		 tokens nil))
	((equal (first tokens) "post")
	 (values (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
								  (with-html (:div "Retrieve post with specified title"))))
		 tokens nil))
	((equal (first tokens) "admin")
	 (values
	  ;;(make-admin-page)
	  ;;#+nomore
	  (make-instance 'admin-guard-widget) ;; This used to be a simple-widget, but that was too simplistic an approach!
	  tokens nil))

	((and (eql (length (first tokens)) 4)
	      (member (first tokens)  (list "2010" "2010" "2010" "2010" "2010" "2010"))) ;; handle year/month/date and year/month/title
	 (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
							  (with-html (:div "Fell through to year/month/date and year/month/title case"))
							  (render-widget menu-widget)))
	 )
	(t ;; Handle anything else
	 (make-instance 'funcall-widget :fun-designator (lambda (&rest args)
							  (with-html (:div "Fell through to unknown URI: dunno what user wants"))))
	 #+nomore(values menu-widget tokens nil)))))
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

(defmacro with-gensyms-prefix (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym "d")))
                 syms)
     ,@body))

;; Model classes

(defclass* tagged-item ()
  ((tags :documentation "Use tags")))

(defclass* nunb-post (post)
  ((ts :documentation "I like timestamps")))


;; Render the menu-ish

(defmethod render-widget-body ((w nunb-menu-ish-post-overview) &rest args)
  "Render all posts by author, date, tags etc. This can be changed later, and made more javascripty .."
  (with-html
    (:div "(menu-ish) list of all posts"
	  (:ul
	   (dolist (p (all-of 'post))
	     (with-gensyms-prefix (a b)
	       (with-html
		 (:li
		  (:div :class "post-title"
			(:a :href (format nil "/post/~A" (weblocks::url-encode (post-title p))) (str (post-title p))))))))))))