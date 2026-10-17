(in-package #:squash-the-creeps)

;;; Functions for the methods of the engine classes the game uses, besides those
;;; gdecl defines, named <class>-<method>, e.g. CHARACTER-BODY-3D-MOVE-AND-SLIDE.
;;; They're generated from gdecl/extension_api.json when the code is compiled,
;;; and added to the package GODOT, with a struct for each class, such as
;;; CHARACTER-BODY-3D, which the game's classes inherit from.

(gdext:define-engine-class "CharacterBody3D")
(gdext:define-engine-class "PathFollow3D")
(gdext:define-engine-class "KinematicCollision3D")
