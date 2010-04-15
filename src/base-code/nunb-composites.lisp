(in-package :resty-weblocgks)

(defwidget simple-widget ()
  ((var :accessor get-var :initarg :var)
   (render-fn :accessor render-fn :initarg :render-fn :initform (constantly nil)))
  (:documentation "There is now a funcall-widget in weblocks core that is identical to this."))

(defmethod render-widget-body ((widget simple-widget) &rest args)
  (funcall (render-fn widget) widget))

(defwidget composite-with-tags (composite)
  ())

(defmethod render-widget-body ((widget composite-with-tags) &rest args)
  (with-extra-tags
    (render-widget-children widget)))

(defmethod render-widget-children ((obj composite-with-tags) &rest args)
   (mapc (lambda (child)
	   (apply #'render-widget child args))
          (widget-children obj)))

(defmethod render-widget ((obj composite-with-tags) &rest args &key inlinep &allow-other-keys)
  "Give responsibility of rendering children to render-widget-body,
   unlike what weblocks-dev now seems to do, which is to render widget
   children after running render-widget-body of the parent. WTF, weblocks?"
   (let ((*current-widget* obj))
    (declare (special *current-widget*))
    ;;(setf inlinep t)
    (if inlinep
      (progn (apply #'render-widget-body obj args)
	     #+nomore
	     (apply #'render-widget-children obj (remove-keyword-parameter args :inlinep)))
      (apply #'with-widget-header
	     obj
	     (lambda (obj &rest args)
	       (apply #'render-widget-body obj args)
	       #+nomore(apply #'render-widget-children obj (remove-keyword-parameter args :inlinep)))
             (append
               (when (widget-prefix-fn obj)
                 (list :widget-prefix-fn (widget-prefix-fn obj)))
               (when (widget-suffix-fn obj)
                 (list :widget-suffix-fn (widget-suffix-fn obj)))
               args)))))


;; Some utility fn.s to wrap widgets in composites: do not call these during rendering, for FSMs sake!

(defun wrap-in-composite (w)
  (make-instance 'composite :widgets (if (atom w) (list w) w)))

(defun wrap-in-composite-2 (w &optional dom-class)
  (make-instance 'composite
		 :widgets (if (atom w) (list w) w)
		 :dom-class dom-class))

(defwidget nunb-custom-composite (composite)
  ((dom-width  :initform nil :initarg :dom-width)
   (dom-style  :initform nil :initarg :dom-style)))

(defun wrap-in-width-composite (w &optional width)
  (make-instance 'nunb-custom-composite
		 :widgets (if (atom w) (list w) w)
		 :dom-width width))

(defun wrap-in-style-composite (w &optional style)
  (make-instance 'nunb-custom-composite
		 :widgets (if (atom w) (list w) w)
		 :dom-style style))

(defun wrap-in-class-composite (w &optional dom-class)
  (make-instance 'composite :widgets (if (atom w) (list w) w)
		 :dom-class dom-class))

(defmethod with-widget-header ((obj nunb-custom-composite) body-fn &rest args &key
			       widget-prefix-fn widget-suffix-fn
			       &allow-other-keys)
  (with-slots (dom-width dom-style) obj
    (with-html
      (:div
       :class (dom-classes obj)
       :style (if dom-style dom-style (format nil "width:~A;" (or dom-width "0px")))
       :id (dom-id obj)
	    (safe-apply widget-prefix-fn obj args)
	    (apply body-fn obj args)
	    (safe-apply widget-suffix-fn obj args)))))


(defun wrap-in-composite-2-tags (w &optional dom-class)
  (make-instance 'composite-with-tags
		 :widgets (if (atom w) (list w) w)
		 :dom-class dom-class))

(defun wrap-in-fake-details (w)
  (wrap-in-composite-2-tags w "lagru-details"))

(defun wrap-in-template-div (w)
  (wrap-in-class-composite w "template"))

(defun wrap-in-fake-form (w &key title)
  (let ((widgets (if (atom w) (list w) w)))
    (make-instance 'composite-with-tags
		 :widgets widgets
		 :dom-class "lagru-details fake-form"
		 :prefix-fn (f_% (with-html (:style :type "text/css" ".fake-form .extra-top-1,  .fake-form .extra-top-2,  .fake-form .extra-top-3 { height: 28px !important;}"))))))


(defun wrap-in-popup (something &key width)
  "Wrap in a popup class for styling."
  (let ((comp (if width
		  (wrap-in-width-composite
		   (wrap-in-composite-2 something "dialog-popup-grid pop_white")
		   width)
		  (wrap-in-composite-2 something "dialog-popup-grid pop_white"))))
    comp))
