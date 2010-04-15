(in-package :resty-weblocgks)

;; navigation

(defun init-user-session (comp)
  "callback function to initialize new sessions"
  (let ((menu (make-instance 'nunb-menu-ish-post-overview)))
    (setf (composite-widgets comp)
	(make-instance 'nunb-blog-toplevel :menu-widget menu))))


;; Model classes

(defclass* tagged-item ()
  ((tags :documentation "Use tags")))

(defclass* nunb-post (post)
  ((ts :documentation "I like timestamps")))

