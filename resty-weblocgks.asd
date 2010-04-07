;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defpackage #:resty-weblocgks-asd
  (:use :cl :asdf))

(in-package :resty-weblocgks-asd)

(defsystem resty-weblocgks
  :name "resty-weblocgks"
  :version "0.0.2"
  :maintainer ""
  :author ""
  :licence ""
  :description "resty blog"
  :depends-on (:weblocks :f-underscore :anaphora)
  :components ((:file "resty-weblocgks")
	       (:module conf
			:components ((:file "stores"))
			:depends-on ("resty-weblocgks"))
	       (:module src
			:components 
			((:file "init-session" 
				:depends-on ("layout"))
			 (:file "layout" 
				:depends-on ("model" "views"))
			 (:module model
				  :components
				  ((:file "post"
					  :depends-on ("user"))
				   (:file "user")))
			 (:module views
				  :components
				  ((:file "post-views"
					  :depends-on ("presentations"))
				   (:module presentations
					    :components
					    ((:file "action-link"))))
				  :depends-on ("model"))
			 (:module widgets
				  :components
				  ((:file "post")
				   (:file "blog" 
					  :depends-on ("post")))
				  :depends-on ("model" "views")))
			:depends-on ("resty-weblocgks" conf))))
