(defsystem "squash-the-creeps"
    :description "Godot's \"Your first 3D game\" tutorial in Common Lisp"
    :author "Markus Flambard"
    :license "MIT"
    :depends-on ("gdecl")
    :components ((:file "packages")
                 (:file "squash-the-creeps" :depends-on ("packages"))))
