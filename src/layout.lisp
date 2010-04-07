(in-package :resty-weblocgks)

(defun save-in-session (key data)
  (setf (webapp-session-value key)
	  data))

(defun get-from-session (key)
  (multiple-value-bind (data success)
      (webapp-session-value key)
    (if success data "err")))

(defun make-main-page ()
  (let (blog-page)
    (setf blog-page
	  (make-blog-widget))
    (make-instance 'static-selector
		   :panes
		   (list
		    
		     (cons 'main blog-page)
		     (cons 'admin (make-admin-page))))))

;; get-widget-for-tokens

(defun make-users-gridedit ()
  (make-instance 'gridedit
		 :name 'users-grid
		 :data-class 'user
		 :view 'user-table-view
		 :widget-prefix-fn (lambda (&rest args)
				     (declare (ignore args))
				     (with-html (:h1 "Users")))
		 :item-data-view 'user-data-view
		 :item-form-view 'user-form-view))

(defun make-posts-gridedit ()
  (let (blog)
    (setf blog
	  (make-instance 'gridedit
			 :name 'posts-grid
			 :data-class 'post
			 :widget-prefix-fn (lambda (&rest args)
					     (declare (ignore args))
					     (with-html (:h1 "Posts")))
			 :view 'post-table-view
			 :item-data-view 'post-data-view
			 :item-form-view 'post-form-view
			 :on-add-item
			 (lambda (&rest args) ;; (break "me")
			   (aif (get-from-session 'blog)
				(reset-blog it)
				(break "no,error"))
			   (redirect "/main"))
			 :on-delete-item
			 (lambda (&rest args) ;; (break "me")
			   (aif (get-from-session 'blog)
				(reset-blog it)
				(break "no,error")))))
    ;; (save-in-session 'main blog)
    blog))

(defun make-admin-page ()
  (make-instance 'composite
		 :widgets
		 (list (make-users-gridedit)
		       (make-widget
			(lambda ()
			 ;; gridedit widgets were probably not
			 ;; intended to be put 2 on the same page, so
			 ;; I add an HR tag between the two
			 (with-html (:div (:hr :style "margin: 2em;")))))
		       (make-posts-gridedit))))

(defun make-blog-widget ()
  (let* ((blog       (make-instance 'blog-widget
				    :post-short-view 'post-short-view
				    :post-full-view 'post-full-view))
	 (composite (make-instance
		     'composite :widgets (list blog))))    
    (save-in-session 'blog blog)
    composite))
