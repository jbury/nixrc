{ pkgs, lib }:

let
  callPackage = (lib.callPackageWith pkgs);
in {
  kustomize = (callPackage ./kustomize.nix {});
  remontoire = (callPackage ./remontoire.nix {});
  vanta-agent = (callPackage ./vanta-agent.nix {});
}
