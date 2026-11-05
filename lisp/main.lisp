(in-package #:squash-the-creeps)

;;; The Main scene's code, from "Spawning monsters", "Killing the player" and
;;; "Score and replay"

;; extends Node
;;
;; @export var mob_scene: PackedScene

;; The class Main in Godot, whose instances' Lisp objects are MAINs
(defclass main (node)
  (;; The Mob scene. A PackedScene is RefCounted, so Main keeps a reference to it.
   (mob-scene :initform nil :export :object :class "PackedScene" :reader main-mob-scene))
  (:metaclass godot-class))

;; func _ready():
;;     $UserInterface/Retry.hide()
(defmethod ready ((main main))
  (hide ($ main "UserInterface/Retry")))

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
;;
;;     # We connect the mob to the score label to update the score upon squashing one.
;;     mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
(define-godot-generic on-mob-timer-timeout (self))

(defmethod on-mob-timer-timeout ((main main))
  (let (;; Create a new instance of the Mob scene.
        (mob (instantiate (main-mob-scene main)))
        ;; Choose a random location on the SpawnPath.
        ;; We store the reference to the SpawnLocation node.
        (mob-spawn-location ($ main "SpawnPath/SpawnLocation")))
    ;; And give it a random offset.
    (setf (progress-ratio mob-spawn-location) (randf))
    (let ((player-position (position ($ main "Player"))))
      (initialize mob (position mob-spawn-location) player-position))
    ;; Spawn the mob by adding it to the Main scene.
    (add-child main mob)
    ;; We connect the mob to the score label to update the score upon squashing
    ;; one.
    (let ((score-label ($ main "UserInterface/ScoreLabel")))
      (gdext:connect-signal mob 'squashed (lambda () (on-mob-squashed score-label))
                            :target score-label))))

;; func _on_player_hit():
;;     $MobTimer.stop()
;;     $UserInterface/Retry.show()
(define-godot-generic on-player-hit (self))

(defmethod on-player-hit ((main main))
  (stop ($ main "MobTimer"))
  (show ($ main "UserInterface/Retry")))

;; func _unhandled_input(event):
;;     if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
;;         # This restarts the current scene.
;;         get_tree().reload_current_scene()
(defmethod unhandled-input ((main main) event)
  (when (and (is-action-pressed event "ui_accept")
             (visible ($ main "UserInterface/Retry")))
    ;; This restarts the current scene.
    (reload-current-scene (get-tree main))))
