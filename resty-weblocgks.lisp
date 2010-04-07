
(defpackage #:resty-weblocgks
  (:use :cl :weblocks :cl-who
	:metabang.utilities :anaphora)
  (:import-from :anaphora #:aif #:aprog1 #:awhen)
  (:documentation
   "A web application based on Weblocks."))

(in-package :resty-weblocgks)

(export '(start-resty-weblocgks stop-resty-weblocgks))

(defwebapp resty-weblocgks
    :prefix "/"
    :description "resty-weblocgks: An example application"
    :init-user-session 'resty-weblocgks::init-user-session
    :autostart nil                   ;; have to start the app manually
    :dependencies '((:stylesheet "navigation"))
    :ignore-default-dependencies nil) ;; accept the defaults

(defun start-resty-weblocgks (&rest args)
  "Starts the application by calling 'start-weblocks' with appropriate
arguments."
  (apply #'start-weblocks args)
  (start-webapp 'resty-weblocgks))

(defun stop-resty-weblocgks ()
  "Stops the application by calling 'stop-weblocks'."
  (stop-webapp 'resty-weblocgks)
  (stop-weblocks))

