(defsystem "squash-the-creeps"
    :description "Godot's \"Your first 3D game\" tutorial in Common Lisp"
    :author "Markus Flambard"
    :license "MIT"
    :depends-on ("gdecl")
    :components ((:file "packages")
                 (:file "engine-classes" :depends-on ("packages"))
                 (:file "player" :depends-on ("packages" "engine-classes"))
                 (:file "mob" :depends-on ("packages" "engine-classes"))
                 (:file "main" :depends-on ("packages" "engine-classes" "mob"))
                 (:file "squash-the-creeps" :depends-on ("packages" "player" "mob" "main"))))
