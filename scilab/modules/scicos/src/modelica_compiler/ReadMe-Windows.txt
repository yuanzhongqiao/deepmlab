Install OCaml via Opam (https://ocaml.org/docs/ocaml-on-windows)
> opam install system-msvc

In a command line execute to setup environment:
> for /f "tokens=*" %i in ('opam env --switch=default') do @%i

And launch Visual Studio from this shell (devenv)
