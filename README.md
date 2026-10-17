# Squash the Creeps in Common Lisp

The game from Godot's tutorial [Your first 3D game](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html), written in Common Lisp instead of GDScript. The Lisp code runs in [Embeddable Common Lisp](https://ecl.common-lisp.dev) (ECL) inside Godot, through [gdecl](https://github.com/flambard/gdecl), a framework for programming Godot with Common Lisp.

The game's classes are CLOS classes, with gdecl's `godot-clos`: each is a `defclass` with the metaclass `godot-class`, and its methods, such as `_physics_process` and the signal handlers, are `defmethod`s of generic functions.

This is a work in progress that follows the tutorial step by step. gdecl is a proof of concept, and it is improved along the way with what the game needs.

## Requirements

- Godot ≥ 4.4, as `godot` on `PATH`
- ECL, with `ecl-config` on `PATH`
- GNU Make and a C compiler (clang is used if it's installed)

## Getting started

gdecl is a git submodule, so clone with `--recurse-submodules`, or run this in an existing clone:

```sh
git submodule update --init
```

Build the GDExtension library:

```sh
make
```

This compiles the Lisp code and gdecl into `project/bin/libgdecl.so`. The first time, it also runs Godot to generate the GDExtension API files that gdecl needs. Then open the Godot project:

```sh
godot --path project --editor
```

Run `make` again after changing the Lisp code, and restart Godot to load the new library.

## Layout

```
gdecl/      the gdecl framework (git submodule)
lisp/       the game's Lisp code, the ASDF system squash-the-creeps
project/    the Godot project, with the tutorial's art and fonts
Makefile    names the ASDF system and the library, and includes gdecl/gdecl.mk
```

## License

The tutorial's art, music and fonts in `project/art/` and `project/fonts/` come from the [Godot documentation project starters](https://github.com/godotengine/godot-docs-project-starters); see their licenses there and in `project/fonts/LICENSE.txt`.
