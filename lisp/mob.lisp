(in-package #:squash-the-creeps)

;;; The Mob scene's code, from "Spawning monsters", "Jumping and squashing
;;; monsters" and "Character animation"

;; extends CharacterBody3D
;;
;; # Minimum speed of the mob in meters per second.
;; @export var min_speed = 10
;; # Maximum speed of the mob in meters per second.
;; @export var max_speed = 18
;;
;; # Emitted when the player jumped on the mob.
;; signal squashed

;; The class Mob in Godot, whose instances' Lisp objects are MOBs
(defclass mob (character-body-3d)
  (;; Minimum speed of the mob in meters per second.
   (min-speed :initform 10 :export :int :reader mob-min-speed)
   ;; Maximum speed of the mob in meters per second.
   (max-speed :initform 18 :export :int :reader mob-max-speed))
  (:metaclass godot-class)
  ;; Emitted when the player jumped on the mob.
  (:signals (squashed))
  ;; _physics_process runs every physics frame, so Godot calls the plain
  ;; function, without generic dispatch
  (:direct-functions (physics-process mob-physics-process)))

;; func _physics_process(_delta):
;;     move_and_slide()
(defun mob-physics-process (mob delta)
  (declare (ignore delta))
  (move-and-slide mob))

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
;;
;;     $AnimationPlayer.speed_scale = random_speed / min_speed
(define-godot-generic initialize (self (start-position :vector3) (player-position :vector3)))

(defmethod initialize ((mob mob) start-position player-position)
  ;; We position the mob by placing it at start_position
  ;; and rotate it towards player_position, so it looks at the player.
  (look-at-from-position mob start-position player-position (vector3 0.0 1.0 0.0))
  ;; Rotate this mob randomly within range of -45 and +45 degrees,
  ;; so that it doesn't move directly towards the player.
  (rotate-y mob (randf-range (- (/ pi 4)) (/ pi 4)))
  (let* (;; We calculate a random speed (float)
         (random-speed (randf-range (mob-min-speed mob) (mob-max-speed mob)))
         ;; We calculate a forward velocity that represents the speed.
         (velocity (vector3* (vector3 0.0 0.0 -1.0) random-speed)))
    ;; We then rotate the velocity vector based on the mob's Y rotation
    ;; in order to move in the direction the mob is looking.
    (setf velocity (vector3-rotated velocity (vector3 0.0 1.0 0.0)
                                    (vector3-y (rotation mob))))
    (setf (velocity mob) velocity)
    ;; The faster the mob, the faster its animation
    (setf (speed-scale ($ mob "AnimationPlayer")) (/ random-speed (mob-min-speed mob)))))

;; func _on_visible_on_screen_notifier_3d_screen_exited():
;;     queue_free()
(define-godot-generic on-visible-on-screen-notifier-3d-screen-exited (self))

(defmethod on-visible-on-screen-notifier-3d-screen-exited ((mob mob))
  (queue-free mob))

;; func squash():
;;     squashed.emit()
;;     queue_free()
(define-godot-generic squash (self))

(defmethod squash ((mob mob))
  (emit-signal mob 'squashed)
  (queue-free mob))
