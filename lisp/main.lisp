(in-package #:squash-the-creeps)

;;; The Main scene's code, from "Spawning monsters"

;; extends Node
;;
;; @export var mob_scene: PackedScene

;; The Lisp object of a Main is a MAIN
(gdext:define-class main ("Main" "Node")
  (;; The Mob scene. A PackedScene is RefCounted, so Main keeps a reference to it.
   (mob-scene nil :export :object :class "PackedScene"))
  (:method "_on_mob_timer_timeout" main-on-mob-timer-timeout))

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
(defun main-on-mob-timer-timeout (main)
  (let (;; Create a new instance of the Mob scene.
        (mob (packed-scene-instantiate (main-mob-scene main)))
        ;; Choose a random location on the SpawnPath.
        ;; We store the reference to the SpawnLocation node.
        (mob-spawn-location (node-get-node main "SpawnPath/SpawnLocation")))
    ;; And give it a random offset.
    (path-follow-3d-set-progress-ratio mob-spawn-location (randf))
    (let ((player-position (node-3d-get-position (node-get-node main "Player"))))
      (mob-initialize mob (node-3d-get-position mob-spawn-location) player-position))
    ;; Spawn the mob by adding it to the Main scene.
    (node-add-child main mob)))
