(in-package #:squash-the-creeps)

;;; The Main scene's code, from "Spawning monsters"

;; extends Node
;;
;; @export var mob_scene: PackedScene

;; The Lisp object of a Main is a MAIN
(gdext:define-class main ("Main" "Node")
  (;; The Mob scene. A PackedScene is RefCounted, so Main keeps a reference to it.
   (mob-scene nil :export :object :class "PackedScene")))
