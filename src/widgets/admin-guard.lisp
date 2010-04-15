(in-package :resty-weblocgks)

(defwidget admin-guard-widget ()
  ((admin-page :initform (make-admin-page-weasel)))
  (:documentation "Guard an admin page"))

(defmethod render-widget-body ((widget admin-guard-widget) &rest args)
  (with-slots (admin-page) widget
    (if (authenticatedp)
	(render-widget admin-page)
	(progn 
	  ;;(send-script "alert('Login failure! and also send a script that adds a warning about # of failures to document.body');")
	  (with-html (:div "Only administrators may access the admin page. Please login"))
	  (render-link (lambda/cc (&rest args)
			 (with-flow (root-composite)
			   (do-confirmation-flow
			       "Click Ok to login, and Cancel to simulate not having the right password or login credentials."
			     :no-text "Cancel"
			     :if-yes (f_% (save-in-session *authentication-key* "john_q_user") (redirect "/admin"))
			     :if-no  (f_% (save-in-session *authentication-key* nil))
			     :after  (f_% (aif (get-from-session 'login-failures)
					       (save-in-session 'login-failures (+ 1 it))
					       (save-in-session 'login-failures 1))))))
		       "login")))
    ))

(defun make-admin-page-weasel ()
  "Avoid dependency on layout.lisp"
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