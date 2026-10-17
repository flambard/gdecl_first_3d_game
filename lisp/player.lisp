(in-package #:squash-the-creeps)

;;; The Player scene's code, from "Moving the player with code", "Jumping and
;;; squashing monsters" and "Killing the player"

;; extends CharacterBody3D
;;
;; # Emitted when the player was hit by a mob.
;; signal hit
;;
;; # How fast the player moves in meters per second.
;; @export var speed = 14
;; # The downward acceleration when in the air, in meters per second squared.
;; @export var fall_acceleration = 75
;; # Vertical impulse applied to the character upon jumping in meters per second.
;; @export var jump_impulse = 20
;; # Vertical impulse applied to the character upon bouncing over a mob in
;; # meters per second.
;; @export var bounce_impulse = 16
;;
;; var target_velocity = Vector3.ZERO

;; The class Player in Godot, whose instances' Lisp objects are PLAYERs
(defclass player (character-body-3d)
  (;; How fast the player moves in meters per second.
   (speed :initform 14 :export :int :reader player-speed)
   ;; The downward acceleration when in the air, in meters per second squared.
   (fall-acceleration :initform 75 :export :int :reader player-fall-acceleration)
   ;; Vertical impulse applied to the character upon jumping in meters per second.
   (jump-impulse :initform 20 :export :int :reader player-jump-impulse)
   ;; Vertical impulse applied to the character upon bouncing over a mob in
   ;; meters per second.
   (bounce-impulse :initform 16 :export :int :reader player-bounce-impulse)
   (target-velocity :initform (vector3) :reader player-target-velocity)
   ;; The child node Pivot
   (pivot :onready "Pivot" :reader player-pivot))
  (:metaclass godot-class)
  ;; Emitted when the player was hit by a mob.
  (:signals (hit)))

;; func _physics_process(delta):
;;     # We create a local variable to store the input direction.
;;     var direction = Vector3.ZERO
;;
;;     # We check for each move input and update the direction accordingly.
;;     if Input.is_action_pressed("move_right"):
;;         direction.x += 1
;;     if Input.is_action_pressed("move_left"):
;;         direction.x -= 1
;;     if Input.is_action_pressed("move_back"):
;;         # Notice how we are working with the vector's x and z axes.
;;         # In 3D, the XZ plane is the ground plane.
;;         direction.z += 1
;;     if Input.is_action_pressed("move_forward"):
;;         direction.z -= 1
;;
;;     if direction != Vector3.ZERO:
;;         direction = direction.normalized()
;;         # Setting the basis property will affect the rotation of the node.
;;         $Pivot.basis = Basis.looking_at(direction)
;;
;;     # Ground Velocity
;;     target_velocity.x = direction.x * speed
;;     target_velocity.z = direction.z * speed
;;
;;     # Vertical Velocity
;;     if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
;;         target_velocity.y = target_velocity.y - (fall_acceleration * delta)
;;
;;     # Jumping.
;;     if is_on_floor() and Input.is_action_just_pressed("jump"):
;;         target_velocity.y = jump_impulse
;;
;;     # Iterate through all collisions that occurred this frame
;;     for index in range(get_slide_collision_count()):
;;         # We get one of the collisions with the player
;;         var collision = get_slide_collision(index)
;;
;;         # If there are duplicate collisions with a mob in a single frame
;;         # the mob will be deleted after the first collision, and a second call to
;;         # get_collider will return null, leading to a null pointer when calling
;;         # collision.get_collider().is_in_group("mob").
;;         # This block of code prevents processing duplicate collisions.
;;         if collision.get_collider() == null:
;;             continue
;;
;;         # If the collider is with a mob
;;         if collision.get_collider().is_in_group("mob"):
;;             var mob = collision.get_collider()
;;             # we check that we are hitting it from above.
;;             if Vector3.UP.dot(collision.get_normal()) > 0.1:
;;                 # If so, we squash it and bounce.
;;                 mob.squash()
;;                 target_velocity.y = bounce_impulse
;;                 # Prevent further duplicate calls.
;;                 break
;;
;;     # Moving the Character
;;     velocity = target_velocity
;;     move_and_slide()
(defmethod physics-process ((player player) delta)
  (let ((direction (vector3))           ; The input direction
        (target-velocity (player-target-velocity player)))
    ;; We check for each move input and update the direction accordingly.
    (when (input-is-action-pressed "move_right")
      (incf (vector3-x direction)))
    (when (input-is-action-pressed "move_left")
      (decf (vector3-x direction)))
    ;; Notice how we are working with the vector's x and z axes.
    ;; In 3D, the XZ plane is the ground plane.
    (when (input-is-action-pressed "move_back")
      (incf (vector3-z direction)))
    (when (input-is-action-pressed "move_forward")
      (decf (vector3-z direction)))
    (unless (equalp direction (vector3))
      (setf direction (vector3-normalized direction))
      ;; Setting the basis property will affect the rotation of the node.
      (node-3d-set-basis (player-pivot player) (basis-looking-at direction)))
    ;; Ground Velocity
    (setf (vector3-x target-velocity) (* (vector3-x direction) (player-speed player))
          (vector3-z target-velocity) (* (vector3-z direction) (player-speed player)))
    ;; Vertical Velocity
    (unless (character-body-3d-is-on-floor player) ; If in the air, fall towards the floor. Literally gravity
      (setf (vector3-y target-velocity)
            (float (- (vector3-y target-velocity) (* (player-fall-acceleration player) delta))
                   1.0)))
    ;; Jumping.
    (when (and (character-body-3d-is-on-floor player) (input-is-action-just-pressed "jump"))
      (setf (vector3-y target-velocity) (float (player-jump-impulse player) 1.0)))
    ;; Iterate through all collisions that occurred this frame
    (dotimes (index (character-body-3d-get-slide-collision-count player))
      ;; We get one of the collisions with the player
      (let* ((collision (character-body-3d-get-slide-collision player index))
             (collider (kinematic-collision-3d-get-collider collision)))
        ;; If there are duplicate collisions with a mob in a single frame the mob
        ;; will be deleted after the first collision, and a second call to
        ;; get_collider will return null. This prevents processing duplicate
        ;; collisions.
        (when collider
          ;; If the collider is with a mob
          (when (node-is-in-group collider "mob")
            ;; we check that we are hitting it from above.
            (when (> (vector3-dot (vector3 0.0 1.0 0.0) (kinematic-collision-3d-get-normal collision))
                     0.1)
              ;; If so, we squash it and bounce.
              (squash collider)
              (setf (vector3-y target-velocity) (float (player-bounce-impulse player) 1.0))
              ;; Prevent further duplicate calls.
              (return))))))
    ;; Moving the Character
    (character-body-3d-set-velocity player target-velocity)
    (character-body-3d-move-and-slide player)))

;; func die():
;;     hit.emit()
;;     queue_free()
(define-godot-generic die (self))

(defmethod die ((player player))
  (object-emit-signal player "hit")
  (node-queue-free player))

;; func _on_mob_detector_body_entered(body):
;;     die()
(define-godot-generic on-mob-detector-body-entered (self (body :object))
  (:godot-name "_on_mob_detector_body_entered"))

(defmethod on-mob-detector-body-entered ((player player) body)
  (declare (ignore body))
  (die player))
