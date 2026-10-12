(in-package #:squash-the-creeps)

;;; The Player scene's code, from "Moving the player with code" and "Jumping and
;;; squashing monsters"

;; extends CharacterBody3D
;;
;; # How fast the player moves in meters per second.
;; @export var speed = 14
;; # The downward acceleration when in the air, in meters per second squared.
;; @export var fall_acceleration = 75
;; # Vertical impulse applied to the character upon jumping in meters per second.
;; @export var jump_impulse = 20
;;
;; var target_velocity = Vector3.ZERO

;; The Lisp object of a Player is a PLAYER
(gdext:define-class player ("Player" "CharacterBody3D")
  (;; How fast the player moves in meters per second.
   (speed 14 :export :int)
   ;; The downward acceleration when in the air, in meters per second squared.
   (fall-acceleration 75 :export :int)
   ;; Vertical impulse applied to the character upon jumping in meters per second.
   (jump-impulse 20 :export :int)
   (target-velocity (vector3))
   ;; The child node Pivot
   (pivot nil :onready "Pivot"))
  (:virtual "_physics_process" player-physics-process))

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
;;     # Moving the Character
;;     velocity = target_velocity
;;     move_and_slide()
(defun player-physics-process (player delta)
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
    ;; Moving the Character
    (character-body-3d-set-velocity player target-velocity)
    (character-body-3d-move-and-slide player)))
