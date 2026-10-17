(in-package #:squash-the-creeps)

;;; The Main scene's code, from "Spawning monsters" and "Killing the player"

;; extends Node
;;
;; @export var mob_scene: PackedScene

;; The class Main in Godot, whose instances' Lisp objects are MAINs
(defclass main (node)
  (;; The Mob scene. A PackedScene is RefCounted, so Main keeps a reference to it.
   (mob-scene :initform nil :export :object :class "PackedScene" :reader main-mob-scene))
  (:metaclass godot-class))

;; func _on_mob_timer_timeout():
;;     # Create a new instance of the Mob scene.
;;     var mob = mob_scene.instantiate()
;;
;;     # Choose a random location on the SpawnPath.
;;     # We store the reference to the SpawnLocation node.
;;     var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
;;     # And give it a random offset.
;;     mob_spawn_location.progress_ratio = randf()
;;
;;     var player_position = $Player.position
;;     mob.initialize(mob_spawn_location.position, player_position)
;;
;;     # Spawn the mob by adding it to the Main scene.
;;     add_child(mob)
(define-godot-generic on-mob-timer-timeout (self)
  (:godot-name "_on_mob_timer_timeout"))

(defmethod on-mob-timer-timeout ((main main))
  (let (;; Create a new instance of the Mob scene.
        (mob (packed-scene-instantiate (main-mob-scene main)))
        ;; Choose a random location on the SpawnPath.
        ;; We store the reference to the SpawnLocation node.
        (mob-spawn-location (node-get-node main "SpawnPath/SpawnLocation")))
    ;; And give it a random offset.
    (path-follow-3d-set-progress-ratio mob-spawn-location (randf))
    (let ((player-position (node-3d-get-position (node-get-node main "Player"))))
      (initialize mob (node-3d-get-position mob-spawn-location) player-position))
    ;; Spawn the mob by adding it to the Main scene.
    (node-add-child main mob)))

;; func _on_player_hit():
;;     $MobTimer.stop()
(define-godot-generic on-player-hit (self)
  (:godot-name "_on_player_hit"))

(defmethod on-player-hit ((main main))
  (timer-stop (node-get-node main "MobTimer")))
