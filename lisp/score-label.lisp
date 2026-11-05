(in-package #:squash-the-creeps)

;;; The ScoreLabel's code, from "Score and replay"

;; extends Label
;;
;; var score = 0

;; The class ScoreLabel in Godot, whose instances' Lisp objects are
;; SCORE-LABELs
(defclass score-label (label)
  ((score :initform 0 :accessor score-label-score))
  (:metaclass godot-class))

;; func _on_mob_squashed():
;;     score += 1
;;     text = "Score: %s" % score
(defun on-mob-squashed (score-label)
  (incf (score-label-score score-label))
  (setf (text score-label) (format nil "Score: ~d" (score-label-score score-label))))
