{ inputs, lib, ... }:

let
  inherit (builtins) baseNameOf import;
  inherit (lib) mkDefault removeSuffix nixosSystem;

in rec {
  mkHost = path: pkgs: system: 
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName =
            mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        ../. # /default.nix
        (import path)
      ];
    };

  mapHosts = dir: pkgs:
    lib.my.mapModules dir (hostPath: mkHost hostPath pkgs);
}
