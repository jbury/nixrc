{ inputs, lib, pkgs, ... }:

let
  sys = "x86_64-linux";
  inherit (builtins) baseNameOf elem import;
  inherit (lib) mkDefault removeSuffix filterAttrs nixosSystem;
  inherit (lib.my) mapModules;
in rec {
  mkHost = path:
    attrs@{ system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName =
            mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../. # /default.nix
        (import path)
      ];
    };

  mapHosts = dir:
    attrs@{ system ? system, ... }:
    mapModules dir (hostPath: mkHost hostPath attrs);
}
