(in-package :resty-weblocgks)

(defwidget choice-maker ()
  ((message :initarg :message)
   (buttons :initarg :buttons :type (member :ok :ok/cancel :cancel) :initform :ok)
   (button-text :initarg :button-texts    :initform nil :accessor button-texts)
   (button-class :initarg :button-classes :initform nil :accessor button-classes)
   (on-success :initarg :on-success)
   (on-cancel :initarg :on-cancel))
  (:documentation "Display a message string, with custom styles and on-yes, on-no, after fns. Can also use (cons string render-fn) as message.
                   This is a takeoff on do-choices, but widgetized, mostly because I find it easier to understand :-)"))

(defmethod render-widget-body ((widget choice-maker) &rest args)
  "Render the choice widget"
  (with-slots (buttons on-success on-cancel message) widget
    (with-html
      (:div :class "error white" 
	    (:div :style "margin:5px; width:auto;text-align:center;"
		  (if (listp message)
		      (htm
		       (str (car message))
		       (:div (safe-funcall (cdr message)))) 
		      (str message))))
      (:div :class "view push-bottom" :style "padding-top:20px;"
	    (:div :class "submit" :style "width:auto;"
		  (when (or (eql buttons :ok)
			    (eql buttons :ok/cancel))
		    (render-link (f_% (safe-funcall on-success) (answer widget))
				 (or (getf (button-texts widget) :ok) "Ok") ;; (cl-i18n::translate )
				 :class (format nil "button ~A" (or (getf (button-classes widget) :ok)
								    "lagru-tick"))))
		  (when (eql buttons :ok/cancel)
		    (render-link (f_% (safe-funcall on-cancel)  (answer widget))
				 (or (getf (button-texts widget) :cancel)  "Annulla") ;;(cl-i18n::translate )
				 :class (format nil "button ~A" (or (getf (button-classes widget) :cancel)
								    "lagru-cross")))))))))


(defun/cc do-confirmation-flow (message &key if-yes if-no after yes-text no-text yes-class no-class)
  "Display a message string, with custom styles and on-yes, on-no, after fns. Can also use (cons string render-fn) as message."
  (with-flow (root-composite)
    (weblocks::nunb-do-dialog "Question"
		    (wrap-in-width-composite (wrap-in-popup
					      (make-instance 'choice-maker :message message :buttons (cond
												       ((and if-yes if-no) :ok/cancel)
												       (if-no              :cancel)
												       (if-yes             :ok))
							     :button-texts   (list :ok yes-text  :cancel no-text)
							     :button-classes (list :ok yes-class :cancel no-class)
							     :on-success if-yes :on-cancel if-no))
					     "400px"))
    (safe-funcall after)))
