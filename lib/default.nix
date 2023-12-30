{ inputs, lib, pkgs, ... }:

let
  inherit (lib) makeExtensible attrValues foldr;

  modules = import ./modules.nix {
    inherit lib;
    final.attrs = import ./attrs.nix {
      inherit lib;
      final = { };
    };
  };

  mylib = makeExtensible (final:
    modules.mapModules ./.
    (file: import file { inherit final lib pkgs inputs; }));
in mylib.extend (final: prev: foldr (a: b: a // b) { } (attrValues prev))
