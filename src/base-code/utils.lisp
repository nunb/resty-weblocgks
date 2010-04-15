(in-package :resty-weblocgks)

(defun save-in-session (key data)
  (setf (webapp-session-value key)
	  data))

(defun get-from-session (key)
  (multiple-value-bind (data success)
      (webapp-session-value key)
    (if success data nil)))


;; Utility fn.s to retrieve from cl-persistence

(defun all-of (type)
  "Accepts an argument symbol, finds stored objects of that type"
  (declare (ignore arg))
  (find-persistent-objects (class-store type) type :order-by (cons 'name :asc)))

(defun all-of-and-subtypes (class)
  "Get all entitites (was companies) of this type and subtypes"
  (loop for classname in (cons class (mapcar #'class-name (moptilities:subclasses (find-class class)))) 
	     nconc (find-persistent-objects (class-store 'class) classname)))

(defmacro with-gensyms-prefix (syms &body body)
  "Make gensyms compatible with html dom ids"
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym "d")))
                 syms)
     ,@body))
