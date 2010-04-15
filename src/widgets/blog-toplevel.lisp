(in-package :resty-weblocgks)

(defwidget nunb-blog-toplevel (on-demand-selector)
  ((menu-widget :initarg :menu-widget :documentation "Show a menu-standin .. TODO"))
  (:default-initargs :lookup-function #'blog-selector-choose-post)
  (:documentation
   "A toplevel dispatcher that should a) Render the post (or
    collection of posts) searched-for/arrived-at via REST url, b)
    Render some kind of menu-ish sidebar listing posts by date, author
    and tags"))

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
							  (with-html (:div "Fell through to unknown URI: dunno what user wants")
								     (str (format nil "Also public files path ~A" *our-public-files-path*)))))
	 #+nomore(values menu-widget tokens nil))))))
