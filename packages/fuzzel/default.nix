args_@{ lib, fetchFromGitea, stdenv, fuzzel, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "fuzzel" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
  (fuzzel.override args).overrideAttrs(old: {
    version = "${metadata.rev}";
    src = fetchFromGitea {
      inherit (metadata) domain owner repo rev sha256;
    };

    patches = [
      ./surface.patch
    ];
  })
