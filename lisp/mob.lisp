(in-package #:squash-the-creeps)

;;; The Mob scene's code, from "Spawning monsters"

;; extends CharacterBody3D
;;
;; # Minimum speed of the mob in meters per second.
;; @export var min_speed = 10
;; # Maximum speed of the mob in meters per second.
;; @export var max_speed = 18

;; The Lisp object of a Mob is a MOB
(gdext:define-class mob ("Mob" "CharacterBody3D")
  (;; Minimum speed of the mob in meters per second.
   (min-speed 10 :export :int)
   ;; Maximum speed of the mob in meters per second.
   (max-speed 18 :export :int)))
