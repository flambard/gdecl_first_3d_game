(in-package #:squash-the-creeps)

(defun start ()
  (godot-print "Squash the Creeps: Lisp code loaded"))

(gdext:add-initialize-hook 'start)
