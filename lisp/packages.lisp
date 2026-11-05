(godot:define-godot-package #:squash-the-creeps
  (:use #:cl #:godot #:godot-utility #:godot-clos)
  ;; Timer.start is GODOT:START; the game's startup function is its own
  (:shadow #:start))
