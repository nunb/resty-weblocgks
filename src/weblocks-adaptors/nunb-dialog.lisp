(in-package :weblocks)

(export '(nunb-do-dialog))

;; We need to define 2 items as they're defined in the source for weblocks-lagru, but not for weblocks-tallinn

#+weblocks-tallinn
(defun dialog-uri ()
  "Return the URI at which the dialog is needed"
  (or (identity (cl-ppcre:regex-replace "/?(?:\\?.*)$" (request-uri*) ""))))

#+weblocks-tallinn
(defun dialog-uri-or-webroot ()
  "Either / or dialog-uri"
  (awhen (dialog-uri)
    (if (text-input-present-p it)
	it
	"/")))


(defun/cc nunb-do-dialog (title callee &key css-class close)
  (declare (special weblocks::*on-ajax-complete-scripts*))
  "Custom do-dialog, useful in weblocks-stable, not important now.."
  (assert (stringp title))
  (if (ajax-request-p)
      (cond
	((weblocks::current-dialog)
	 ;;(break (format nil  "uri was ~A ?" (dialog-uri)))
	 (warn "Multiple dialogs not allowed, redirecting to continuation url..")
	 (redirect (weblocks::dialog-uri-or-webroot))
	(t
	 (prog1
	     (weblocks::call
	      callee (lambda (new-callee)
		       (setf (weblocks::current-dialog)
			     (make-dialog :title title
					  :widget new-callee
					  :close close
					  :css-class css-class))
		       (send-script (ps* (make-dialog-js title new-callee css-class close)))))
	   ;; (break "continuation returned, let's move on")
	   (setf (weblocks::current-dialog) nil)
	   (send-script (ps (remove-dialog))))))
      (do-modal title callee :css-class css-class)))

