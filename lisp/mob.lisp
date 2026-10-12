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
   (max-speed 18 :export :int))
  (:method "initialize" mob-initialize
           :arguments (("start_position" :vector3) ("player_position" :vector3)))
  (:method "_on_visible_on_screen_notifier_3d_screen_exited"
           mob-on-visible-on-screen-notifier-3d-screen-exited))

;; # This function will be called from the Main scene.
;; func initialize(start_position, player_position):
;;     # We position the mob by placing it at start_position
;;     # and rotate it towards player_position, so it looks at the player.
;;     look_at_from_position(start_position, player_position, Vector3.UP)
;;     # Rotate this mob randomly within range of -45 and +45 degrees,
;;     # so that it doesn't move directly towards the player.
;;     rotate_y(randf_range(-PI / 4, PI / 4))
;;
;;     # We calculate a random speed (float)
;;     var random_speed = randf_range(min_speed, max_speed)
;;     # We calculate a forward velocity that represents the speed.
;;     velocity = Vector3.FORWARD * random_speed
;;     # We then rotate the velocity vector based on the mob's Y rotation
;;     # in order to move in the direction the mob is looking.
;;     velocity = velocity.rotated(Vector3.UP, rotation.y)
(defun mob-initialize (mob start-position player-position)
  ;; We position the mob by placing it at start_position
  ;; and rotate it towards player_position, so it looks at the player.
  (node-3d-look-at-from-position mob start-position player-position (vector3 0.0 1.0 0.0))
  ;; Rotate this mob randomly within range of -45 and +45 degrees,
  ;; so that it doesn't move directly towards the player.
  (node-3d-rotate-y mob (randf-range (- (/ pi 4)) (/ pi 4)))
  (let* (;; We calculate a random speed (float)
         (random-speed (randf-range (mob-min-speed mob) (mob-max-speed mob)))
         ;; We calculate a forward velocity that represents the speed.
         (velocity (vector3* (vector3 0.0 0.0 -1.0) random-speed)))
    ;; We then rotate the velocity vector based on the mob's Y rotation
    ;; in order to move in the direction the mob is looking.
    (setf velocity (vector3-rotated velocity (vector3 0.0 1.0 0.0)
                                    (vector3-y (node-3d-get-rotation mob))))
    (character-body-3d-set-velocity mob velocity)))

;; func _on_visible_on_screen_notifier_3d_screen_exited():
;;     queue_free()
(defun mob-on-visible-on-screen-notifier-3d-screen-exited (mob)
  (node-queue-free mob))
