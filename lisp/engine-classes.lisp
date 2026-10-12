(in-package #:squash-the-creeps)

;;; Functions for the methods of the engine classes the game uses, besides those
;;; gdecl defines, named <class>-<method>, e.g. CHARACTER-BODY-3D-MOVE-AND-SLIDE.
;;; They're generated from gdecl/extension_api.json when the code is compiled,
;;; and added to the package GODOT.

(gdext:define-engine-class "CharacterBody3D")
(gdext:define-engine-class "PathFollow3D")
(gdext:define-engine-class "KinematicCollision3D")
