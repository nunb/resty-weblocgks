(in-package :resty-weblocgks)

(defun save-in-session (key data)
  (setf (webapp-session-value key)
	  data))

(defun get-from-session (key)
  (multiple-value-bind (data success)
      (webapp-session-value key)
    (if success data nil)))
