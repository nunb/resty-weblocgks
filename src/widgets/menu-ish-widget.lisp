(in-package :resty-weblocgks)

(defwidget nunb-menu-ish-post-overview ()
  ()
  (:documentation
   "List current list of tags, authors, and an archive
    arranged by date.  Simple right now, but can be fancied up with
    javascript-ish dropdowns etc."))


;; Render the menu-ish

(defmethod render-widget-body ((w nunb-menu-ish-post-overview) &rest args)
  "Render all posts by author, date, tags etc. This can be changed later, and made more javascripty .."
  (with-gensyms-prefix (posts authors)
    (with-html
      (:div ;; maybe later :onclick (format nil "javascript:$('~A').toggle();" posts)
	    "By post" 
	    (:div :id posts ;; :style "display:none;"
		  (:ul
		   (dolist (p (all-of 'post))
		     (with-gensyms-prefix (a b)
		       (with-html
			 (:li
			  (:div :class "post-title"
				(:a :href (format nil "/post/~A" (weblocks::url-encode (post-title p))) (str (post-title p))))))))))))))